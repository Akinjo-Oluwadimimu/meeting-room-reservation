package com.roomreserve.dao;

import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Chunk;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.Image;
import com.itextpdf.text.PageSize;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import com.roomreserve.exceptions.ReportGenerationException;
import com.roomreserve.model.Amenity;
import com.roomreserve.model.ExportRequest;
import com.roomreserve.model.Reservation;
import com.roomreserve.model.Room;
import com.roomreserve.util.DBUtil;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import javax.servlet.ServletContext;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class ExportDAO {
    private Connection connection;
    private final ReservationDAO reservationDAO;
    private final RoomDAO roomDAO;
    private final String reportDirectory;

    public ExportDAO(ServletContext context) throws SQLException {
        this.connection = DBUtil.getConnection();
        this.reservationDAO = new ReservationDAO();
        this.roomDAO = new RoomDAO();
        this.reportDirectory = context.getRealPath("/WEB-INF/reports");
        createReportDirectory();
    }

    public boolean saveExportRequest(ExportRequest request) {
        String sql = "INSERT INTO export_history (manager_id, export_type, start_date, end_date, format, file_path) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setInt(1, request.getManagerId());
            statement.setString(2, request.getExportType().toString());
            statement.setDate(3, request.getStartDate() != null ? 
                Date.valueOf(request.getStartDate()) : null);
            statement.setDate(4, request.getEndDate() != null ? 
                Date.valueOf(request.getEndDate()) : null);
            statement.setString(5, request.getFormat().toString());
            statement.setString(6, request.getFilePath());
            
            int affectedRows = statement.executeUpdate();
            if (affectedRows == 0) {
                return false;
            }
            
            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    request.setExportId(generatedKeys.getInt(1));
                }
            }
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<ExportRequest> getExportHistory(int managerId) {
        List<ExportRequest> history = new ArrayList<>();
        String sql = "SELECT * FROM export_history WHERE manager_id = ? ORDER BY created_at DESC";
        
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, managerId);
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                ExportRequest request = new ExportRequest();
                request.setExportId(rs.getInt("export_id"));
                request.setManagerId(rs.getInt("manager_id"));
                request.setExportType(ExportRequest.ExportType.valueOf(rs.getString("export_type").toUpperCase()));
                request.setStartDate(rs.getDate("start_date") != null ? 
                    rs.getDate("start_date").toLocalDate() : null);
                request.setEndDate(rs.getDate("end_date") != null ? 
                    rs.getDate("end_date").toLocalDate() : null);
                request.setFormat(ExportRequest.ExportFormat.valueOf(rs.getString("format").toUpperCase()));
                request.setFilePath(rs.getString("file_path"));
                request.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                
                history.add(request);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return history;
    }

    public String generateReservationsReport(LocalDate start, LocalDate end, ExportRequest.ExportFormat format) 
            throws ReportGenerationException {
        try {
            List<Reservation> reservations = reservationDAO.getReservationsByDateRange(start.atStartOfDay(), end.atTime(23, 59, 59));
            
            switch (format) {
                case CSV:
                    return generateReservationsCSV(reservations, start, end);
                case EXCEL:
                    return generateReservationsExcel(reservations, start, end);
                case PDF:
                    return generateReservationsPDF(reservations, start, end);
                default:
                    throw new ReportGenerationException("Unsupported format: " + format);
            }
        } catch (Exception e) {
            throw new ReportGenerationException("Failed to generate reservations report", e);
        }
    }

    public String generateRoomsReport(ExportRequest.ExportFormat format) throws ReportGenerationException {
        try {
            List<Room> rooms = roomDAO.getAllRooms();
            
            switch (format) {
                case CSV:
                    return generateRoomsCSV(rooms);
                case EXCEL:
                    return generateRoomsExcel(rooms);
                case PDF:
                    return generateRoomsPDF(rooms);
                default:
                    throw new ReportGenerationException("Unsupported format: " + format);
            }
        } catch (Exception e) {
            throw new ReportGenerationException("Failed to generate rooms report", e);
        }
    }

    public String generateUsageReport(LocalDate start, LocalDate end, ExportRequest.ExportFormat format) 
            throws ReportGenerationException {
        try {
            Map<String, Object> usageData = reservationDAO.getUsageStatistics(start.atStartOfDay(), end.atTime(23, 59, 59));
            
            switch (format) {
                case CSV:
                    return generateUsageCSV(usageData, start, end);
                case EXCEL:
                    return generateUsageExcel(usageData, start, end);
                case PDF:
                    return generateUsagePDF(usageData, start, end);
                default:
                    throw new ReportGenerationException("Unsupported format: " + format);
            }
        } catch (Exception e) {
            throw new ReportGenerationException("Failed to generate usage report", e);
        }
    }

    // Helper method to create report directory if it doesn't exist
    private void createReportDirectory() {
        File dir = new File(reportDirectory);
        if (!dir.exists()) {
            dir.mkdirs();
        }
    }

    // ========== CSV Generation Methods ==========
    
    private String generateReservationsCSV(List<Reservation> reservations, LocalDate start, LocalDate end) 
            throws IOException {
        String fileName = String.format("reservations_%s_to_%s_%d.csv", 
            start, end, System.currentTimeMillis());
        String filePath = reportDirectory + File.separator + fileName;
        
        try (PrintWriter writer = new PrintWriter(new FileWriter(filePath))) {
            DateTimeFormatter dtFormat = DateTimeFormatter.ofPattern("MMM dd, yyyy\nhh:mm a");
            // Write CSV header
            writer.println("Reservation ID,Room,User,Start Time,End Time,Status,Purpose");
            
            // Write data rows
            for (Reservation r : reservations) {
                writer.println(String.format("%d,%s,%s,%s,%s,%s,%s",
                    r.getId(),
                    escapeCsv(r.getRoom().getName()),
                    escapeCsv(r.getUser().getFirstName()),
                    r.getStartTime().format(dtFormat),
                    r.getEndTime().format(dtFormat),
                    r.getStatus(),
                    escapeCsv(r.getPurpose())
                ));
            }
        }
        
        return filePath;
    }
    
    private String generateRoomsCSV(List<Room> rooms) 
            throws IOException {
        String fileName = String.format("rooms_%d.csv", 
            System.currentTimeMillis());
        String filePath = reportDirectory + File.separator + fileName;
        
        try (PrintWriter writer = new PrintWriter(new FileWriter(filePath))) {
            // Write CSV header
            writer.println("Room ID,Building,Name,Room Number,floor,capacity,type,description,Amenities");
            
            // Write data rows
            for (Room r : rooms) {
                writer.println(String.format("%d,%s,%s,%s,%d,%d,%s,%s,%s",
                    r.getId(),
                    escapeCsv(r.getName()),
                    escapeCsv(r.getBuilding().getName()),
                    r.getRoomNumber(),
                    r.getFloor(),
                    r.getCapacity(),
                    r.getRoomType(),
                    escapeCsv(r.getDescription()),
                    escapeCsv(r.getAmenities().stream()
                        .map(Amenity::getName) 
                        .collect(Collectors.joining(", ")))
                ));
            }
        }
        
        return filePath;
    }
    
    private String generateUsageCSV(Map<String, Object> usageData, LocalDate start, LocalDate end) 
            throws IOException {
        String fileName = String.format("usage_%s_to_%s_%d.csv", 
            start, end, System.currentTimeMillis());
        String filePath = reportDirectory + File.separator + fileName;

        try (PrintWriter writer = new PrintWriter(new FileWriter(filePath))) {
            // Write CSV header
            writer.println("Report Type,Item,Count");

            // 1. Write total reservations
            writer.printf("\"Total Reservations\",\"All\",%d%n", 
                usageData.get("totalReservations"));

            // 2. Write reservations by status
            @SuppressWarnings("unchecked")
            Map<String, Integer> statusCounts = (Map<String, Integer>) 
                usageData.get("reservationsByStatus");

            writer.println("\"Reservations by Status\"");
            for (Map.Entry<String, Integer> entry : statusCounts.entrySet()) {
                writer.printf(",\"%s\",%d%n", 
                    escapeCSV(entry.getKey()), 
                    entry.getValue());
            }

            // 3. Write room utilization
            @SuppressWarnings("unchecked")
            Map<String, Integer> roomUsage = (Map<String, Integer>) 
                usageData.get("roomUtilization");

            writer.println("\"Room Utilization\"");
            int rank = 1;
            for (Map.Entry<String, Integer> entry : roomUsage.entrySet()) {
                writer.printf(",\"%d. %s\",%d%n", 
                    rank++, 
                    escapeCSV(entry.getKey()), 
                    entry.getValue());
            }

            // 4. Write summary statistics
            int totalRooms = roomUsage.size();
            int totalReservations = (Integer) usageData.get("totalReservations");
            double avgPerRoom = totalRooms > 0 ? (double) totalReservations / totalRooms : 0;

            writer.println("\"Summary Statistics\"");
            writer.printf(",\"Total Rooms\",%d%n", totalRooms);
            writer.printf(",\"Average Bookings per Room\",%.2f%n", avgPerRoom);
        }

        return filePath;
    }

    private String escapeCSV(String input) {
        if (input == null) {
            return "";
        }
        return input.replace("\"", "\"\""); // Escape double quotes
    }

    private String escapeCsv(String input) {
        if (input == null) return "";
        return input.contains(",") ? "\"" + input + "\"" : input;
    }

    // ========== Excel Generation Methods ==========
    
    private String generateReservationsExcel(List<Reservation> reservations, LocalDate start, LocalDate end) 
            throws IOException {
        String fileName = String.format("reservations_%s_to_%s_%d.xlsx", 
            start, end, System.currentTimeMillis());
        String filePath = reportDirectory + File.separator + fileName;
        
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Reservations");
            
            CellStyle headerStyle = createHeaderStyle(workbook);
            
            // Create header row
            Row headerRow = sheet.createRow(0);
            String[] headers = {"ID", "Room", "User", "Start Time", "End Time", "Status", "Purpose"};
            for (int i = 0; i < headers.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
                sheet.autoSizeColumn(i);
            }
            
            // Create data rows
            int rowNum = 1;
            DateTimeFormatter dtFormat = DateTimeFormatter.ofPattern("MMM dd, yyyy\nhh:mm a");
            for (Reservation r : reservations) {
                Row row = sheet.createRow(rowNum++);
                row.createCell(0).setCellValue(r.getId());
                row.createCell(1).setCellValue(r.getRoom().getName());
                row.createCell(2).setCellValue(r.getUser().getFirstName());
                row.createCell(3).setCellValue(r.getStartTime().format(dtFormat));
                row.createCell(4).setCellValue(r.getEndTime().format(dtFormat));
                row.createCell(5).setCellValue(r.getStatus());
                row.createCell(6).setCellValue(r.getPurpose());
            }
            
            // Auto-size all columns
            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
            }
            
            // Write to file
            try (FileOutputStream outputStream = new FileOutputStream(filePath)) {
                workbook.write(outputStream);
            }
        }
        
        return filePath;
    }
    
    private String generateRoomsExcel(List<Room> rooms) 
            throws IOException {
        String fileName = String.format("rooms_%d.xlsx", 
            System.currentTimeMillis());
        String filePath = reportDirectory + File.separator + fileName;
        
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Rooms");
            
            CellStyle headerStyle = createHeaderStyle(workbook);
            
            // Create header row
            Row headerRow = sheet.createRow(0);
            String[] headers = {"Room ID", "Building", "Name", "Room Number", "Floor", "Capacity", "Type", "Description", "Amenities"};
            for (int i = 0; i < headers.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
                sheet.autoSizeColumn(i);
            }
            
            // Create data rows
            int rowNum = 1;
            for (Room r : rooms) {
                Row row = sheet.createRow(rowNum++);
                row.createCell(0).setCellValue(r.getId());
                row.createCell(1).setCellValue(r.getBuilding().getName());
                row.createCell(2).setCellValue(r.getName());
                row.createCell(3).setCellValue(r.getRoomNumber());
                row.createCell(4).setCellValue(r.getFloor());
                row.createCell(5).setCellValue(r.getCapacity());
                row.createCell(6).setCellValue(r.getRoomType());
                row.createCell(7).setCellValue(r.getDescription());
                row.createCell(8).setCellValue(r.getAmenities().stream()
                        .map(Amenity::getName) 
                        .collect(Collectors.joining(", ")));
            }
            
            // Auto-size all columns
            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
            }
            
            // Write to file
            try (FileOutputStream outputStream = new FileOutputStream(filePath)) {
                workbook.write(outputStream);
            }
        }
        
        return filePath;
    }
    
    private String generateUsageExcel(Map<String, Object> usageData, LocalDate start, LocalDate end) 
            throws IOException {
        String fileName = String.format("usage_%s_to_%s_%d.xlsx", 
            start, end, System.currentTimeMillis());
        String filePath = reportDirectory + File.separator + fileName;

        try (Workbook workbook = new XSSFWorkbook()) {
            // Create styles
            CellStyle headerStyle = createHeaderStyle(workbook);

            // ===== SUMMARY SHEET =====
            Sheet summarySheet = workbook.createSheet("Summary");

            // Summary headers
            Row summaryHeader = summarySheet.createRow(0);
            summaryHeader.createCell(0).setCellValue("Metric");
            summaryHeader.createCell(1).setCellValue("Value");
            summaryHeader.getCell(0).setCellStyle(headerStyle);
            summaryHeader.getCell(1).setCellStyle(headerStyle);

            // Summary data
            int summaryRowNum = 1;
            Row totalRow = summarySheet.createRow(summaryRowNum++);
            totalRow.createCell(0).setCellValue("Total Reservations");
            totalRow.createCell(1).setCellValue((Integer)usageData.get("totalReservations"));

            // ===== STATUS BREAKDOWN SHEET =====
            Sheet statusSheet = workbook.createSheet("Status Breakdown");

            // Status headers
            Row statusHeader = statusSheet.createRow(0);
            statusHeader.createCell(0).setCellValue("Status");
            statusHeader.createCell(1).setCellValue("Count");
            statusHeader.getCell(0).setCellStyle(headerStyle);
            statusHeader.getCell(1).setCellStyle(headerStyle);

            // Status data
            @SuppressWarnings("unchecked")
            Map<String, Integer> statusCounts = (Map<String, Integer>)usageData.get("reservationsByStatus");
            int statusRowNum = 1;
            for (Map.Entry<String, Integer> entry : statusCounts.entrySet()) {
                Row row = statusSheet.createRow(statusRowNum++);
                row.createCell(0).setCellValue(entry.getKey());
                row.createCell(1).setCellValue(entry.getValue());
            }

            // ===== ROOM UTILIZATION SHEET =====
            Sheet roomSheet = workbook.createSheet("Room Utilization");

            // Room headers
            Row roomHeader = roomSheet.createRow(0);
            roomHeader.createCell(0).setCellValue("Room");
            roomHeader.createCell(1).setCellValue("Bookings");
            roomHeader.createCell(2).setCellValue("Percentage");
            roomHeader.getCell(0).setCellStyle(headerStyle);
            roomHeader.getCell(1).setCellStyle(headerStyle);
            roomHeader.getCell(2).setCellStyle(headerStyle);

            // Room data
            @SuppressWarnings("unchecked")
            Map<String, Integer> roomUsage = (Map<String, Integer>)usageData.get("roomUtilization");
            int totalBookings = (Integer)usageData.get("totalReservations");
            int roomRowNum = 1;
            for (Map.Entry<String, Integer> entry : roomUsage.entrySet()) {
                Row row = roomSheet.createRow(roomRowNum++);
                row.createCell(0).setCellValue(entry.getKey());
                row.createCell(1).setCellValue(entry.getValue());

                // Calculate percentage
                if (totalBookings > 0) {
                    double percentage = (entry.getValue() * 100.0) / totalBookings;
                    row.createCell(2).setCellValue(percentage);
                } else {
                    row.createCell(2).setCellValue(0);
                }
            }

            // Auto-size all columns in all sheets
            for (int i = 0; i < workbook.getNumberOfSheets(); i++) {
                Sheet sheet = workbook.getSheetAt(i);
                for (int j = 0; j < sheet.getRow(0).getLastCellNum(); j++) {
                    sheet.autoSizeColumn(j);
                }
            }

            // Write to file
            try (FileOutputStream outputStream = new FileOutputStream(filePath)) {
                workbook.write(outputStream);
            }
        }

        return filePath;
    }

    // ========== PDF Generation Methods ==========
    
    private String generateReservationsPDF(List<Reservation> reservations, LocalDate start, LocalDate end) 
            throws IOException, DocumentException {
        String fileName = String.format("reservations_%s_to_%s_%d.pdf", 
            start, end, System.currentTimeMillis());
        String filePath = reportDirectory + File.separator + fileName;
        
        Document document = null;
        PdfWriter writer = null;

        try (FileOutputStream fos = new FileOutputStream(filePath)) {
            // 1. Initialize document with proper margins
            document = new Document(PageSize.A4.rotate(), 20, 20, 40, 20); // Landscape with margins

            // 2. Create writer with strict PDF compliance
            writer = PdfWriter.getInstance(document, fos);
            writer.setPdfVersion(PdfWriter.PDF_VERSION_1_7);
            writer.setFullCompression();

            // 3. Open document before adding content
            document.open();

            // 4. Add metadata
            document.addTitle(String.format("reservations_%s_to_%s_%d.pdf", 
            start, end, System.currentTimeMillis()));
            document.addCreator("College Room Reservation System");
            document.addAuthor("Manager");
            
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
                String.format("Reservations Report: %s to %s", start, end),
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
                addCell(table, r.getUser().getFirstName() + " " +  r.getUser().getLastName(), dataFont, rowColor, Element.ALIGN_LEFT);

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
            document.close();
            
        } 
        
        return filePath;
    }
    
    private String generateRoomsPDF(List<Room> rooms) 
            throws IOException, DocumentException {
        String fileName = String.format("rooms_%d.pdf", 
            System.currentTimeMillis());
        String filePath = reportDirectory + File.separator + fileName;
        
        Document document = null;
        PdfWriter writer = null;

        try (FileOutputStream fos = new FileOutputStream(filePath)) {
            // 1. Initialize document with proper margins
            document = new Document(PageSize.A4.rotate(), 20, 20, 40, 20); // Landscape with margins

            // 2. Create writer with strict PDF compliance
            writer = PdfWriter.getInstance(document, fos);
            writer.setPdfVersion(PdfWriter.PDF_VERSION_1_7);
            writer.setFullCompression();

            // 3. Open document before adding content
            document.open();

            // 4. Add metadata
            document.addTitle(String.format("rooms_%d.pdf", 
            System.currentTimeMillis()));
            document.addCreator("College Room Reservation System");
            document.addAuthor("Manager");
            
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
                "Meeting Rooms Infoormation\n",
                new Font(Font.FontFamily.HELVETICA, 20, Font.BOLD)
            );
            title.setAlignment(Element.ALIGN_CENTER);
            title.setSpacingAfter(10f);
            document.add(title);


            // 6. Create main table with proper setup
            PdfPTable table = new PdfPTable(new float[]{0.5f, 1.5f, 1.5f, 1f, 1f, 1f, 1f, 3f, 2f});
            table.setWidthPercentage(100);
            table.setSpacingBefore(15f);
            table.setSpacingAfter(20f);
            table.setSplitLate(false);
            table.setSplitRows(true);

            // 7. Add table headers with proper styling
            Font headerFont = new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD, BaseColor.WHITE);
            String[] headers = {"ID", "Building", "Name", "Room Number", "Floor", "Capacity", "Type", "Description", "Amenities"};

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

            boolean alternate = false;
            for (Room r : rooms) {
                // Alternate row colors
                BaseColor rowColor = alternate ? new BaseColor(240, 240, 240) : BaseColor.WHITE;
                alternate = !alternate;

                // ID
                addCell(table, String.valueOf(r.getId()), dataFont, rowColor, Element.ALIGN_CENTER);

                // Building
                addCell(table, r.getBuilding().getName(), dataFont, rowColor, Element.ALIGN_LEFT);
                
                // Name
                addCell(table, r.getName(), dataFont, rowColor, Element.ALIGN_LEFT);

                // Room Number
                addCell(table, r.getRoomNumber(), dataFont, rowColor, Element.ALIGN_LEFT);

                // Floor
                addCell(table, String.valueOf(r.getFloor()), dataFont, rowColor, Element.ALIGN_LEFT);

                // Capacity
                addCell(table, String.valueOf(r.getCapacity()), dataFont, rowColor, Element.ALIGN_LEFT);
                
                // Type
                addCell(table, r.getRoomType(), dataFont, rowColor, Element.ALIGN_LEFT);
                
                // Description
                addCell(table, r.getDescription(), dataFont, rowColor, Element.ALIGN_LEFT);
                
                // Amenities
                addCell(table, String.valueOf(r.getAmenities().stream()
                        .map(Amenity::getName) 
                        .collect(Collectors.joining(", "))), dataFont, rowColor, Element.ALIGN_LEFT);

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
            document.close();
            
        } 
        
        return filePath;
    }
    
    private String generateUsagePDF(Map<String, Object> usageData, LocalDate start, LocalDate end) 
        throws IOException, DocumentException {
        String fileName = String.format("usage_%s_to_%s_%d.pdf", 
            start, end, System.currentTimeMillis());
        String filePath = reportDirectory + File.separator + fileName;

        Document document = null;
        PdfWriter writer = null;

        try (FileOutputStream fos = new FileOutputStream(filePath)) {
            // 1. Initialize document with proper margins
            document = new Document(PageSize.A4, 20, 20, 40, 20); // Landscape with margins

            // 2. Create writer with strict PDF compliance
            writer = PdfWriter.getInstance(document, fos);
            writer.setPdfVersion(PdfWriter.PDF_VERSION_1_7);
            writer.setFullCompression();

            // 3. Open document before adding content
            document.open();

            // 4. Add metadata
            document.addTitle(String.format("usage_report_%s_to_%s", start, end));
            document.addCreator("College Room Reservation System");
            document.addAuthor("System Administrator");

            // Logo row (centered)
            Paragraph logoParagraph = new Paragraph();
            logoParagraph.setAlignment(Element.ALIGN_CENTER);

            try {
                Image logo = Image.getInstance(getClass().getResource("logo.PNG"));
                logo.scaleToFit(50, 50);
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
                "Room Reservation Usage Report\n",
                new Font(Font.FontFamily.HELVETICA, 20, Font.BOLD)
            );
            title.setAlignment(Element.ALIGN_CENTER);
            title.setSpacingAfter(5f);
            document.add(title);

            // Date range (centered)
            Paragraph dateRange = new Paragraph(
                String.format("Period: %s to %s", start.format(DateTimeFormatter.ofPattern("MMM dd, yyyy")), 
                             end.format(DateTimeFormatter.ofPattern("MMM dd, yyyy"))),
                new Font(Font.FontFamily.HELVETICA, 12)
            );
            dateRange.setAlignment(Element.ALIGN_CENTER);
            dateRange.setSpacingAfter(15f);
            document.add(dateRange);

            // Summary Section
            Paragraph summaryTitle = new Paragraph(
                "Summary Statistics",
                new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD)
            );
            summaryTitle.setSpacingAfter(10f);
            document.add(summaryTitle);

            // Summary table
            PdfPTable summaryTable = new PdfPTable(2);
            summaryTable.setWidthPercentage(50);
            summaryTable.setHorizontalAlignment(Element.ALIGN_LEFT);
            summaryTable.setSpacingAfter(20f);

            // Add summary data
            addSummaryRow(summaryTable, "Total Reservations", usageData.get("totalReservations").toString());

            document.add(summaryTable);

            // Reservations by Status Section
            Paragraph statusTitle = new Paragraph(
                "Reservations by Status",
                new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD)
            );
            statusTitle.setSpacingAfter(10f);
            document.add(statusTitle);

            // Status table
            PdfPTable statusTable = new PdfPTable(2);
            statusTable.setWidthPercentage(100);
            statusTable.setHorizontalAlignment(Element.ALIGN_LEFT);
            statusTable.setSpacingAfter(20f);

            // Add status headers
            addTableHeader(statusTable, "Status");
            addTableHeader(statusTable, "Count");

            // Add status data
            @SuppressWarnings("unchecked")
            Map<String, Integer> statusCounts = (Map<String, Integer>) usageData.get("reservationsByStatus");
            for (Map.Entry<String, Integer> entry : statusCounts.entrySet()) {
                addDataRow(statusTable, entry.getKey(), entry.getValue().toString());
            }

            document.add(statusTable);

            // Room Utilization Section
            Paragraph roomTitle = new Paragraph(
                "Room Utilization (Top 10)",
                new Font(Font.FontFamily.HELVETICA, 14, Font.BOLD)
            );
            roomTitle.setSpacingAfter(10f);
            document.add(roomTitle);

            // Room table
            PdfPTable roomTable = new PdfPTable(2);
            roomTable.setWidthPercentage(100);
            roomTable.setHorizontalAlignment(Element.ALIGN_LEFT);
            roomTable.setSpacingAfter(20f);

            // Add room headers
            addTableHeader(roomTable, "Room Name");
            addTableHeader(roomTable, "Number of Bookings");

            // Add room data (limited to top 10)
            @SuppressWarnings("unchecked")
            Map<String, Integer> roomUsage = (Map<String, Integer>) usageData.get("roomUtilization");
            int count = 0;
            for (Map.Entry<String, Integer> entry : roomUsage.entrySet()) {
                if (count++ >= 10) break;
                addDataRow(roomTable, entry.getKey(), entry.getValue().toString());
            }

            document.add(roomTable);

            // Add footer
            Paragraph footer = new Paragraph();
            footer.add(new Chunk("Generated on: ", new Font(Font.FontFamily.HELVETICA, 8)));
            footer.add(new Chunk(LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")), 
                new Font(Font.FontFamily.COURIER, 8)));
            footer.add(new Chunk(" | Page ", new Font(Font.FontFamily.HELVETICA, 8)));
            footer.add(new Chunk(String.valueOf(writer.getPageNumber()), 
                new Font(Font.FontFamily.COURIER, 8)));
            footer.setAlignment(Element.ALIGN_RIGHT);
            document.add(footer);
            
            document.close();
            writer.close();

        }
        return filePath;
    }

    // Helper method to add table headers
    private void addTableHeader(PdfPTable table, String headerText) {
        PdfPCell header = new PdfPCell();
        header.setBackgroundColor(new BaseColor(37, 99, 235)); 
        header.setBorderWidth(1);
        header.setPhrase(new Phrase(headerText, 
            new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD, BaseColor.WHITE)));
        header.setPadding(5);
        table.addCell(header);
    }

    // Helper method to add data rows
    private void addDataRow(PdfPTable table, String label, String value) {
        table.addCell(new Phrase(label, 
            new Font(Font.FontFamily.HELVETICA, 9)));
        PdfPCell cell = new PdfPCell(new Phrase(value, 
            new Font(Font.FontFamily.HELVETICA, 9)));
        table.addCell(cell);
    }

    // Helper method to add summary rows
    private void addSummaryRow(PdfPTable table, String label, String value) {
        PdfPCell labelCell = new PdfPCell(new Phrase(label, 
            new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD)));
        labelCell.setBorder(PdfPCell.NO_BORDER);
        table.addCell(labelCell);

        PdfPCell valueCell = new PdfPCell(new Phrase(value, 
            new Font(Font.FontFamily.HELVETICA, 10)));
        valueCell.setBorder(PdfPCell.NO_BORDER);
        table.addCell(valueCell);
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
    
    private void addCell(PdfPTable table, String content, Font font, BaseColor bgColor, int alignment) {
        PdfPCell cell = new PdfPCell(new Phrase(content, font));
        cell.setPadding(5);
        cell.setBackgroundColor(bgColor);
        cell.setHorizontalAlignment(alignment);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        table.addCell(cell);
    }

}