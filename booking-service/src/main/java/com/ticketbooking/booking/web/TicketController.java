package com.ticketbooking.booking.web;

import com.ticketbooking.booking.ticketing.SharedTicketView;
import com.ticketbooking.booking.ticketing.TicketService;
import com.ticketbooking.booking.web.dto.CombinedTicketRequest;
import com.ticketbooking.booking.web.dto.RedeemRequest;
import com.ticketbooking.booking.web.dto.ShareLinkResponse;
import jakarta.validation.Valid;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import java.util.Arrays;
import java.util.List;
import java.util.UUID;

@RestController
public class TicketController {

    private final TicketService ticketService;

    public TicketController(TicketService ticketService) {
        this.ticketService = ticketService;
    }

    @GetMapping("/bookings/{id}/ticket")
    public ResponseEntity<byte[]> getTicket(@PathVariable UUID id, Authentication authentication) {
        UUID requestingUserId = UUID.fromString(authentication.getName());
        byte[] pdf = ticketService.getTicketPdf(id, requestingUserId, isAdmin(authentication));
        return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_PDF)
                .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"ticket-%s.pdf\"".formatted(id))
                .body(pdf);
    }

    @PostMapping("/bookings/{id}/share")
    public ShareLinkResponse createShareLink(@PathVariable UUID id, Authentication authentication) {
        UUID requestingUserId = UUID.fromString(authentication.getName());
        String token = ticketService.createShareLink(id, requestingUserId, isAdmin(authentication));
        return new ShareLinkResponse("/t/" + token);
    }

    /**
     * One PDF covering every seat in a booking group (all bookings from one
     * checkout) — one page per seat, one download, instead of a separate
     * ticket per seat.
     */
    @PostMapping("/bookings/tickets/combined")
    public ResponseEntity<byte[]> getCombinedTicket(@Valid @RequestBody CombinedTicketRequest request, Authentication authentication) {
        UUID requestingUserId = UUID.fromString(authentication.getName());
        byte[] pdf = ticketService.getCombinedTicketPdf(request.bookingIds(), requestingUserId, isAdmin(authentication));
        return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_PDF)
                .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"tickets.pdf\"")
                .body(pdf);
    }

    @PostMapping("/bookings/tickets/combined/share")
    public ShareLinkResponse createCombinedShareLink(@Valid @RequestBody CombinedTicketRequest request, Authentication authentication) {
        UUID requestingUserId = UUID.fromString(authentication.getName());
        String tokens = ticketService.createCombinedShareLink(request.bookingIds(), requestingUserId, isAdmin(authentication));
        return new ShareLinkResponse("/t/group/" + tokens);
    }

    /** Public, unauthenticated — this is the URL a recipient opens from a shared link, no app or account needed. */
    @GetMapping(value = "/t/{shareToken}", produces = MediaType.TEXT_HTML_VALUE)
    public String viewSharedTicket(@PathVariable String shareToken) {
        SharedTicketView view = ticketService.getSharedTicketView(shareToken);
        return renderHtml(view);
    }

    /** Public, unauthenticated — same idea as {@link #viewSharedTicket}, but for a whole booking group's worth of seats on one page. */
    @GetMapping(value = "/t/group/{tokens}", produces = MediaType.TEXT_HTML_VALUE)
    public String viewCombinedSharedTicket(@PathVariable String tokens) {
        List<SharedTicketView> views = Arrays.stream(tokens.split(","))
                .map(ticketService::getSharedTicketView)
                .toList();
        return renderCombinedHtml(views);
    }

    /** Staff/gate app only — scans the QR and posts its raw payload here. */
    @PostMapping("/tickets/redeem")
    @ResponseStatus(HttpStatus.OK)
    public void redeem(@Valid @RequestBody RedeemRequest request) {
        ticketService.redeem(request.qrPayload());
    }

    private boolean isAdmin(Authentication authentication) {
        return authentication.getAuthorities().stream()
                .map(GrantedAuthority::getAuthority)
                .anyMatch("ROLE_ADMIN"::equals);
    }

    private String renderHtml(SharedTicketView view) {
        var seat = view.seat();
        return """
                <!doctype html>
                <html>
                <head>
                    <meta charset="utf-8">
                    <title>Ticket</title>
                    <meta name="viewport" content="width=device-width, initial-scale=1">
                    <style>
                        body { font-family: sans-serif; max-width: 420px; margin: 40px auto; padding: 0 16px; text-align: center; }
                        h1 { font-size: 1.4rem; }
                        .status { display: inline-block; padding: 4px 12px; border-radius: 12px; font-size: 0.85rem;
                                  background: %s; color: white; margin: 8px 0; }
                        img { margin-top: 16px; width: 220px; height: 220px; }
                        .details { text-align: left; margin-top: 16px; line-height: 1.6; }
                    </style>
                </head>
                <body>
                    <h1>%s</h1>
                    <div class="status">%s</div>
                    <div class="details">
                        <div>Venue: %s</div>
                        <div>Show time: %s</div>
                        <div>Seat: %s%d (%s)</div>
                        <div>Booking ID: %s</div>
                    </div>
                    <img src="data:image/png;base64,%s" alt="Ticket QR code">
                </body>
                </html>
                """.formatted(
                statusColor(view.status().name()),
                escape(seat.eventTitle()),
                view.status(),
                escape(seat.venueName()),
                seat.startTime(),
                seat.rowLabel(), seat.seatNumber(), seat.seatType(),
                view.bookingId(),
                view.qrPngBase64());
    }

    private String renderCombinedHtml(List<SharedTicketView> views) {
        var first = views.get(0).seat();
        StringBuilder seatsHtml = new StringBuilder();
        for (SharedTicketView view : views) {
            var seat = view.seat();
            seatsHtml.append("""
                    <div class="seat-card">
                        <div class="status">%s</div>
                        <div class="details">
                            <div>Seat: %s%d (%s)</div>
                            <div>Booking ID: %s</div>
                        </div>
                        <img src="data:image/png;base64,%s" alt="Ticket QR code">
                    </div>
                    """.formatted(
                    view.status(), seat.rowLabel(), seat.seatNumber(), seat.seatType(),
                    view.bookingId(), view.qrPngBase64()));
        }

        return """
                <!doctype html>
                <html>
                <head>
                    <meta charset="utf-8">
                    <title>Tickets</title>
                    <meta name="viewport" content="width=device-width, initial-scale=1">
                    <style>
                        body { font-family: sans-serif; max-width: 480px; margin: 40px auto; padding: 0 16px; text-align: center; }
                        h1 { font-size: 1.4rem; }
                        .venue { color: #555; margin-bottom: 8px; }
                        .seat-card { border: 1px solid #ddd; border-radius: 12px; padding: 16px; margin-top: 20px; }
                        .status { display: inline-block; padding: 4px 12px; border-radius: 12px; font-size: 0.85rem;
                                  background: #2563eb; color: white; margin-bottom: 8px; }
                        .details { text-align: left; line-height: 1.6; }
                        img { margin-top: 12px; width: 200px; height: 200px; }
                    </style>
                </head>
                <body>
                    <h1>%s</h1>
                    <div class="venue">%s &middot; %s</div>
                    <div>%d seat%s on this ticket</div>
                    %s
                </body>
                </html>
                """.formatted(
                escape(first.eventTitle()),
                escape(first.venueName()), first.startTime(),
                views.size(), views.size() == 1 ? "" : "s",
                seatsHtml);
    }

    private String statusColor(String status) {
        return switch (status) {
            case "CHECKED_IN" -> "#16a34a";
            case "CANCELLED" -> "#dc2626";
            default -> "#2563eb";
        };
    }

    private String escape(String value) {
        return value.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
    }
}
