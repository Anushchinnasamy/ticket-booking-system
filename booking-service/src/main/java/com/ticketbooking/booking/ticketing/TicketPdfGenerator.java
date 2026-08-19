package com.ticketbooking.booking.ticketing;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDPageContentStream;
import org.apache.pdfbox.pdmodel.common.PDRectangle;
import org.apache.pdfbox.pdmodel.font.PDType1Font;
import org.apache.pdfbox.pdmodel.font.Standard14Fonts;
import org.apache.pdfbox.pdmodel.graphics.image.PDImageXObject;
import org.springframework.stereotype.Component;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

@Component
public class TicketPdfGenerator {

    private static final DateTimeFormatter SHOW_TIME_FORMAT =
            DateTimeFormatter.ofPattern("EEE, dd MMM yyyy 'at' HH:mm 'UTC'").withZone(ZoneOffset.UTC);

    public byte[] generate(UUID bookingId, SeatDetails seat, byte[] qrPng) {
        try (PDDocument document = new PDDocument()) {
            PDPage page = new PDPage(PDRectangle.A5);
            document.addPage(page);

            PDType1Font bold = new PDType1Font(Standard14Fonts.FontName.HELVETICA_BOLD);
            PDType1Font regular = new PDType1Font(Standard14Fonts.FontName.HELVETICA);
            PDImageXObject qrImage = PDImageXObject.createFromByteArray(document, qrPng, "qr");

            float pageWidth = page.getMediaBox().getWidth();
            float y = page.getMediaBox().getHeight() - 60;
            float left = 40;

            try (PDPageContentStream cs = new PDPageContentStream(document, page)) {
                y = writeLine(cs, bold, 20, left, y, seat.eventTitle());
                y -= 10;
                y = writeLine(cs, regular, 12, left, y, seat.venueName());
                y = writeLine(cs, regular, 12, left, y, SHOW_TIME_FORMAT.format(seat.startTime()));
                y -= 15;
                y = writeLine(cs, bold, 14, left, y,
                        "Seat %s%d (%s)".formatted(seat.rowLabel(), seat.seatNumber(), seat.seatType()));
                y = writeLine(cs, regular, 12, left, y, "Price: %s %s".formatted("INR", seat.price()));
                y -= 10;
                y = writeLine(cs, regular, 9, left, y, "Booking ID: " + bookingId);

                float qrSize = 180;
                float qrX = (pageWidth - qrSize) / 2;
                float qrY = y - qrSize - 20;
                cs.drawImage(qrImage, qrX, qrY, qrSize, qrSize);

                writeLine(cs, regular, 9, left, qrY - 20, "Present this QR code at the venue entrance for check-in.");
            }

            ByteArrayOutputStream out = new ByteArrayOutputStream();
            document.save(out);
            return out.toByteArray();
        } catch (IOException ex) {
            throw new IllegalStateException("Failed to generate ticket PDF for booking " + bookingId, ex);
        }
    }

    private float writeLine(PDPageContentStream cs, PDType1Font font, float fontSize, float x, float y, String text)
            throws IOException {
        cs.beginText();
        cs.setFont(font, fontSize);
        cs.newLineAtOffset(x, y);
        cs.showText(text);
        cs.endText();
        return y - (fontSize + 6);
    }
}
