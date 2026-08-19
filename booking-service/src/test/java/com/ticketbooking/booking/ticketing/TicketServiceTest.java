package com.ticketbooking.booking.ticketing;

import com.ticketbooking.booking.client.EventServiceClient;
import com.ticketbooking.booking.domain.Booking;
import com.ticketbooking.booking.domain.Ticket;
import com.ticketbooking.booking.repository.BookingRepository;
import com.ticketbooking.booking.repository.TicketRepository;
import com.ticketbooking.common.event.BookingConfirmedEvent;
import com.ticketbooking.common.exception.ConflictException;
import com.ticketbooking.common.exception.ResourceNotFoundException;
import com.ticketbooking.common.exception.ValidationException;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.util.ReflectionTestUtils;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.Optional;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class TicketServiceTest {

    @Mock
    private TicketRepository ticketRepository;

    @Mock
    private BookingRepository bookingRepository;

    @Mock
    private EventServiceClient eventServiceClient;

    @Mock
    private TicketSigningService signingService;

    @Mock
    private QrCodeGenerator qrCodeGenerator;

    @Mock
    private TicketPdfGenerator pdfGenerator;

    @Mock
    private TicketStorageService storageService;

    private TicketService newService() {
        return new TicketService(ticketRepository, bookingRepository, eventServiceClient, signingService,
                qrCodeGenerator, pdfGenerator, storageService, 24);
    }

    private static SeatDetails sampleSeat() {
        return new SeatDetails("Test Concert", "Test Arena", Instant.now(), "A", 12, "PREMIUM", new BigDecimal("500.00"));
    }

    private static Booking bookingWithId(UUID showId, UUID seatId, UUID userId) {
        Booking booking = new Booking(showId, seatId, userId);
        ReflectionTestUtils.setField(booking, "id", UUID.randomUUID());
        return booking;
    }

    @Test
    void generateTicket_whenNoExistingTicket_signsRendersUploadsAndSaves() {
        TicketService service = newService();
        BookingConfirmedEvent event = new BookingConfirmedEvent(
                UUID.randomUUID(), UUID.randomUUID(), UUID.randomUUID(), UUID.randomUUID(), Instant.now());
        when(ticketRepository.findByBookingId(event.bookingId())).thenReturn(Optional.empty());
        when(eventServiceClient.getSeatDetails(event.showId(), event.seatId())).thenReturn(sampleSeat());
        when(signingService.sign(event.bookingId(), event.showId(), event.seatId(), event.confirmedAt()))
                .thenReturn("signed-payload");
        when(qrCodeGenerator.generatePng("signed-payload")).thenReturn(new byte[]{1, 2, 3});
        when(pdfGenerator.generate(eq(event.bookingId()), any(), any())).thenReturn(new byte[]{9, 9});

        service.generateTicket(event);

        verify(storageService).upload(eq("tickets/%s.pdf".formatted(event.bookingId())), any(), eq("application/pdf"));
        ArgumentCaptor<Ticket> ticketCaptor = ArgumentCaptor.forClass(Ticket.class);
        verify(ticketRepository).save(ticketCaptor.capture());
        assertThat(ticketCaptor.getValue().getBookingId()).isEqualTo(event.bookingId());
        assertThat(ticketCaptor.getValue().getQrPayload()).isEqualTo("signed-payload");
    }

    @Test
    void generateTicket_whenTicketAlreadyExists_isNoOp() {
        TicketService service = newService();
        BookingConfirmedEvent event = new BookingConfirmedEvent(
                UUID.randomUUID(), UUID.randomUUID(), UUID.randomUUID(), UUID.randomUUID(), Instant.now());
        when(ticketRepository.findByBookingId(event.bookingId()))
                .thenReturn(Optional.of(new Ticket(event.bookingId(), "x", "tickets/x.pdf")));

        service.generateTicket(event);

        verifyNoInteractions(eventServiceClient, signingService, qrCodeGenerator, pdfGenerator, storageService);
        verify(ticketRepository, never()).save(any());
    }

    @Test
    void getTicketPdf_whenOwner_returnsBytes() {
        TicketService service = newService();
        UUID userId = UUID.randomUUID();
        Booking booking = bookingWithId(UUID.randomUUID(), UUID.randomUUID(), userId);
        Ticket ticket = new Ticket(booking.getId(), "payload", "tickets/key.pdf");
        when(bookingRepository.findById(booking.getId())).thenReturn(Optional.of(booking));
        when(ticketRepository.findByBookingId(booking.getId())).thenReturn(Optional.of(ticket));
        when(storageService.download("tickets/key.pdf")).thenReturn(new byte[]{7});

        byte[] result = service.getTicketPdf(booking.getId(), userId, false);

        assertThat(result).containsExactly(7);
    }

    @Test
    void getTicketPdf_whenNotOwnerAndNotAdmin_throwsResourceNotFoundException() {
        TicketService service = newService();
        Booking booking = bookingWithId(UUID.randomUUID(), UUID.randomUUID(), UUID.randomUUID());
        when(bookingRepository.findById(booking.getId())).thenReturn(Optional.of(booking));

        assertThatThrownBy(() -> service.getTicketPdf(booking.getId(), UUID.randomUUID(), false))
                .isInstanceOf(ResourceNotFoundException.class);
        verifyNoInteractions(storageService);
    }

    @Test
    void getTicketPdf_whenAdmin_returnsEvenForNonOwner() {
        TicketService service = newService();
        Booking booking = bookingWithId(UUID.randomUUID(), UUID.randomUUID(), UUID.randomUUID());
        Ticket ticket = new Ticket(booking.getId(), "payload", "tickets/key.pdf");
        when(bookingRepository.findById(booking.getId())).thenReturn(Optional.of(booking));
        when(ticketRepository.findByBookingId(booking.getId())).thenReturn(Optional.of(ticket));
        when(storageService.download("tickets/key.pdf")).thenReturn(new byte[]{1});

        byte[] result = service.getTicketPdf(booking.getId(), UUID.randomUUID(), true);

        assertThat(result).containsExactly(1);
    }

    @Test
    void getTicketPdf_whenTicketNotYetGenerated_throwsResourceNotFoundException() {
        TicketService service = newService();
        UUID userId = UUID.randomUUID();
        Booking booking = bookingWithId(UUID.randomUUID(), UUID.randomUUID(), userId);
        when(bookingRepository.findById(booking.getId())).thenReturn(Optional.of(booking));
        when(ticketRepository.findByBookingId(booking.getId())).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.getTicketPdf(booking.getId(), userId, false))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void createShareLink_whenOwner_issuesTokenOnTheTicket() {
        TicketService service = newService();
        UUID userId = UUID.randomUUID();
        Booking booking = bookingWithId(UUID.randomUUID(), UUID.randomUUID(), userId);
        Ticket ticket = new Ticket(booking.getId(), "payload", "tickets/key.pdf");
        when(bookingRepository.findById(booking.getId())).thenReturn(Optional.of(booking));
        when(ticketRepository.findByBookingId(booking.getId())).thenReturn(Optional.of(ticket));

        String token = service.createShareLink(booking.getId(), userId, false);

        assertThat(token).isNotBlank();
        assertThat(ticket.getShareToken()).isEqualTo(token);
        assertThat(ticket.isShareTokenValid()).isTrue();
    }

    @Test
    void redeem_whenValidAndConfirmed_checksIn() {
        TicketService service = newService();
        UUID bookingId = UUID.randomUUID();
        UUID showId = UUID.randomUUID();
        UUID seatId = UUID.randomUUID();
        Booking booking = bookingWithId(showId, seatId, UUID.randomUUID());
        booking.confirm();
        when(signingService.verify("qr")).thenReturn(new SignedTicketPayload(bookingId, showId, seatId, Instant.now()));
        when(bookingRepository.findById(bookingId)).thenReturn(Optional.of(booking));
        when(bookingRepository.checkInIfConfirmed(eq(bookingId), any())).thenReturn(1);

        service.redeem("qr");

        verify(bookingRepository).checkInIfConfirmed(eq(bookingId), any());
    }

    @Test
    void redeem_whenAlreadyCheckedIn_throwsConflictException() {
        TicketService service = newService();
        UUID bookingId = UUID.randomUUID();
        UUID showId = UUID.randomUUID();
        UUID seatId = UUID.randomUUID();
        Booking booking = bookingWithId(showId, seatId, UUID.randomUUID());
        ReflectionTestUtils.setField(booking, "status", com.ticketbooking.booking.domain.BookingStatus.CHECKED_IN);
        when(signingService.verify("qr")).thenReturn(new SignedTicketPayload(bookingId, showId, seatId, Instant.now()));
        when(bookingRepository.findById(bookingId)).thenReturn(Optional.of(booking));
        when(bookingRepository.checkInIfConfirmed(eq(bookingId), any())).thenReturn(0);

        assertThatThrownBy(() -> service.redeem("qr"))
                .isInstanceOf(ConflictException.class)
                .hasMessageContaining("already redeemed");
    }

    @Test
    void redeem_whenShowOrSeatMismatch_throwsValidationExceptionWithoutTouchingCheckIn() {
        TicketService service = newService();
        UUID bookingId = UUID.randomUUID();
        Booking booking = bookingWithId(UUID.randomUUID(), UUID.randomUUID(), UUID.randomUUID());
        when(signingService.verify("qr"))
                .thenReturn(new SignedTicketPayload(bookingId, UUID.randomUUID(), UUID.randomUUID(), Instant.now()));
        when(bookingRepository.findById(bookingId)).thenReturn(Optional.of(booking));

        assertThatThrownBy(() -> service.redeem("qr")).isInstanceOf(ValidationException.class);
        verify(bookingRepository, never()).checkInIfConfirmed(any(), any());
    }
}
