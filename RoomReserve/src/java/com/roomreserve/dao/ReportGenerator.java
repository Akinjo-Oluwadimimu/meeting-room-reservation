package com.roomreserve.dao;

import com.itextpdf.text.*;
import com.itextpdf.text.Document;
import com.itextpdf.text.Element;
import com.itextpdf.text.Image;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import com.roomreserve.model.Reservation;
import java.io.OutputStream;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class ReportGenerator {
    private ReservationDAO reservationDAO;

    public ReportGenerator() {
        reservationDAO = new ReservationDAO();
    }
    
    
    public void generateExcelReport(LocalDate startDate, LocalDate endDate, OutputStream output) {
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Reservations");
            
            
            // Create styles
            CellStyle headerStyle = createHeaderStyle(workbook);

            // Create header row
            Row headerRow = sheet.createRow(0);
            String[] headers = {"ID", "Room", "User", "Start Time", "End Time", "Purpose", "Status"};
            for (int i = 0; i < headers.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }
            
            // Get data
            List<Reservation> reservations = reservationDAO.getReservationsByDateRange(
                startDate.atStartOfDay(), 
                endDate.plusDays(1).atStartOfDay()
            );
            
            // Fill data
            int rowNum = 1;
            DateTimeFormatter dtFormat = DateTimeFormatter.ofPattern("MMM dd, yyyy\nhh:mm a");
            for (Reservation r : reservations) {
                Row row = sheet.createRow(rowNum++);
                row.createCell(0).setCellValue(r.getId());
                row.createCell(1).setCellValue(r.getRoom().getName());
                row.createCell(2).setCellValue(r.getUser().getFirstName() + " " + r.getUser().getLastName());
                row.createCell(3).setCellValue(r.getStartTime().format(dtFormat));
                row.createCell(4).setCellValue(r.getEndTime().format(dtFormat));
                row.createCell(5).setCellValue(r.getPurpose());
                row.createCell(6).setCellValue(r.getStatus());
            }
            
            workbook.write(output);
        } catch (Exception e) {
            throw new RuntimeException("Failed to generate Excel report", e);
        }
    }

    private CellStyle createHeaderStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();
        org.apache.poi.ss.usermodel.Font font = workbook.createFont();
        font.setBold(true);
        font.setColor(IndexedColors.WHITE.getIndex());
        style.setFont(font);
        style.setFillForegroundColor(IndexedColors.ROYAL_BLUE.getIndex());
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        style.setAlignment(HorizontalAlignment.CENTER);
        return style;
    }



    public void generatePdfReport(LocalDate startDate, LocalDate endDate, OutputStream output) {
        Document document = null;
        PdfWriter writer = null;

        try {
            // 1. Initialize document with proper margins
            document = new Document(PageSize.A4.rotate(), 20, 20, 40, 20); // Landscape with margins

            // 2. Create writer with strict PDF compliance
            writer = PdfWriter.getInstance(document, output);
            writer.setPdfVersion(PdfWriter.PDF_VERSION_1_7);
            writer.setFullCompression();

            // 3. Open document before adding content
            document.open();

            // 4. Add metadata
            document.addTitle("Meeting Room Reservations Report");
            document.addCreator("College Room Reservation System");
            document.addAuthor("Administrator");
            
            // Logo row (centered)
            Paragraph logoParagraph = new Paragraph();
            logoParagraph.setAlignment(Element.ALIGN_CENTER);

            try {
                Image logo = Image.getInstance(getClass().getResource("logo.PNG"));
                logo.scaleToFit(50, 50); // Slightly larger logo
                logoParagraph.add(new Chunk(logo, 0, 0));
            } catch (Exception e) {
                // Fallback text if logo fails
                logoParagraph.add(new Chunk("[College Logo]", 
                    new Font(Font.FontFamily.HELVETICA, 12, Font.ITALIC)));
            }

            logoParagraph.setSpacingAfter(0f);
            document.add(logoParagraph);

            // Title row (centered)
            Paragraph title = new Paragraph(
                "College Meeting Room Reservations\n",
                new Font(Font.FontFamily.HELVETICA, 20, Font.BOLD)
            );
            title.setAlignment(Element.ALIGN_CENTER);
            title.setSpacingAfter(5f);
            document.add(title);

            // Description row (centered)
            Paragraph description = new Paragraph(
                String.format("Reservations from %s to %s",
                    startDate.format(DateTimeFormatter.ofPattern("MMMM d, yyyy")),
                    endDate.format(DateTimeFormatter.ofPattern("MMMM d, yyyy"))),
                new Font(Font.FontFamily.HELVETICA, 12)
            );
            description.setAlignment(Element.ALIGN_CENTER);
            description.setSpacingAfter(10f);
            document.add(description);


            // 6. Create main table with proper setup
            PdfPTable table = new PdfPTable(new float[]{0.5f, 1.5f, 2f, 2f, 2f, 3f, 1f});
            table.setWidthPercentage(100);
            table.setSpacingBefore(15f);
            table.setSpacingAfter(20f);
            table.setSplitLate(false);
            table.setSplitRows(true);

            // 7. Add table headers with proper styling
            Font headerFont = new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD, BaseColor.WHITE);
            String[] headers = {"ID", "Room", "Reserved By", "Start Time", "End Time", "Purpose", "Status"};

            for (String header : headers) {
                PdfPCell cell = new PdfPCell(new Phrase(header, headerFont));
                cell.setBackgroundColor(new BaseColor(37, 99, 235)); // Royal blue
                cell.setPadding(8);
                cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
                table.addCell(cell);
            }

            // 8. Add table data with proper formatting
            Font dataFont = new Font(Font.FontFamily.HELVETICA, 9);
            Font monoFont = new Font(Font.FontFamily.COURIER, 9);
            DateTimeFormatter dtFormat = DateTimeFormatter.ofPattern("MMM dd, yyyy\nhh:mm a");

            List<Reservation> reservations = reservationDAO.getReservationsByDateRange(
                startDate.atStartOfDay(), 
                endDate.plusDays(1).atStartOfDay()
            );

            boolean alternate = false;
            for (Reservation r : reservations) {
                // Alternate row colors
                BaseColor rowColor = alternate ? new BaseColor(240, 240, 240) : BaseColor.WHITE;
                alternate = !alternate;

                // ID
                addCell(table, String.valueOf(r.getId()), dataFont, rowColor, Element.ALIGN_CENTER);

                // Room
                addCell(table, r.getRoom().getName(), dataFont, rowColor, Element.ALIGN_LEFT);

                // User
                addCell(table, r.getUser().getFirstName() + " " + r.getUser().getLastName(), dataFont, rowColor, Element.ALIGN_LEFT);

                // Start Time
                addCell(table, r.getStartTime().format(dtFormat), monoFont, rowColor, Element.ALIGN_CENTER);

                // End Time
                addCell(table, r.getEndTime().format(dtFormat), monoFont, rowColor, Element.ALIGN_CENTER);

                // Purpose
                addCell(table, r.getPurpose(), dataFont, rowColor, Element.ALIGN_LEFT);

                // Status with conditional formatting
                PdfPCell statusCell = new PdfPCell(new Phrase(r.getStatus(), dataFont));
                statusCell.setPadding(5);
                statusCell.setHorizontalAlignment(Element.ALIGN_CENTER);
                statusCell.setBackgroundColor(rowColor);

                switch(r.getStatus().toLowerCase()) {
                    case "approved":
                        statusCell.setPhrase(new Phrase(r.getStatus(), 
                            new Font(Font.FontFamily.HELVETICA, 9, Font.BOLD, new BaseColor(0, 128, 0))));
                        break;
                    case "pending":
                        statusCell.setPhrase(new Phrase(r.getStatus(), 
                            new Font(Font.FontFamily.HELVETICA, 9, Font.BOLD, new BaseColor(255, 165, 0))));
                        break;
                    case "rejected":
                        statusCell.setPhrase(new Phrase(r.getStatus(), 
                            new Font(Font.FontFamily.HELVETICA, 9, Font.BOLD, new BaseColor(220, 20, 60))));
                        break;
                    case "cancelled":
                        statusCell.setPhrase(new Phrase(r.getStatus(), 
                            new Font(Font.FontFamily.HELVETICA, 9, Font.BOLD, new BaseColor(70, 70, 70))));
                        break;
                    case "completed":
                        statusCell.setPhrase(new Phrase(r.getStatus(), 
                            new Font(Font.FontFamily.HELVETICA, 9, Font.BOLD, new BaseColor(0, 0, 220))));
                        break;
                    case "no-show":
                        statusCell.setPhrase(new Phrase(r.getStatus(), 
                            new Font(Font.FontFamily.HELVETICA, 9, Font.BOLD, new BaseColor(60, 20, 120))));
                        break;
                    default:
                        statusCell.setPhrase(new Phrase(r.getStatus(), 
                            new Font(Font.FontFamily.HELVETICA, 9, Font.BOLD, BaseColor.BLACK)));
                        break;
                }
                table.addCell(statusCell);
            }

            document.add(table);

            // 9. Add footer
            Paragraph footer = new Paragraph();
            footer.add(new Chunk("Generated on: ", new Font(Font.FontFamily.HELVETICA, 8)));
            footer.add(new Chunk(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")), 
                new Font(Font.FontFamily.COURIER, 8)));
            footer.add(new Chunk(" | Page ", new Font(Font.FontFamily.HELVETICA, 8)));
            footer.add(new Chunk(String.valueOf(writer.getPageNumber()), 
                new Font(Font.FontFamily.COURIER, 8)));
            footer.setAlignment(Element.ALIGN_RIGHT);
            document.add(footer);

        } catch (Exception e) {
            throw new RuntimeException("Failed to generate PDF report", e);
        } finally {
            // 10. Proper resource cleanup
            if (document != null && document.isOpen()) {
                document.close();
            }
            if (writer != null) {
                writer.close();
            }
        }
    }



    private void addCell(PdfPTable table, String content, Font font, BaseColor bgColor, int alignment) {
        PdfPCell cell = new PdfPCell(new Phrase(content, font));
        cell.setPadding(5);
        cell.setBackgroundColor(bgColor);
        cell.setHorizontalAlignment(alignment);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table.addCell(cell);
    }
}
