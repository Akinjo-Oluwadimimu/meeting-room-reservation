package com.roomreserve.dao;

import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Chunk;
import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.Image;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import com.roomreserve.model.ReportDefinition;
import com.roomreserve.model.ReportResult;
import com.roomreserve.util.DBUtil;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import java.util.Date;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.JSONObject;

public class ReportDAO {
    private Connection connection;

    public ReportDAO() throws SQLException {
        this.connection = DBUtil.getConnection();
    }

    public List<ReportDefinition> getAllReportDefinitions() throws SQLException {
        List<ReportDefinition> reports = new ArrayList<>();
        String sql = "SELECT * FROM report_definitions ORDER BY report_name";
        
        try (Statement stmt = connection.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                ReportDefinition report = new ReportDefinition();
                report.setReportId(rs.getInt("report_id"));
                report.setReportName(rs.getString("report_name"));
                report.setDescription(rs.getString("description"));
                report.setQuery(rs.getString("query"));
                
                JSONObject paramsJson = new JSONObject(rs.getString("parameters"));
                Map<String, String> parameters = new LinkedHashMap<>();
                for (String key : paramsJson.keySet()) {
                    parameters.put(key, paramsJson.getString(key));
                }
                report.setParameters(parameters);
                
                report.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                report.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
                
                reports.add(report);
            }
        }
        return reports;
    }
    
    public ReportDefinition getReportDefinitionById(int id) throws SQLException {
        ReportDefinition report = new ReportDefinition();
        String sql = "SELECT * FROM report_definitions WHERE report_id = ? ORDER BY report_name";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                report.setReportId(rs.getInt("report_id"));
                report.setReportName(rs.getString("report_name"));
                report.setDescription(rs.getString("description"));
                report.setQuery(rs.getString("query"));
                
                JSONObject paramsJson = new JSONObject(rs.getString("parameters"));
                Map<String, String> parameters = new LinkedHashMap<>();
                for (String key : paramsJson.keySet()) {
                    parameters.put(key, paramsJson.getString(key));
                }
                report.setParameters(parameters);
                
                report.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                report.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
            }
        }
        return report;
    }

    public ReportResult executeReport(int reportId, Map<String, Object> parameters) throws SQLException {
        ReportDefinition definition = getReportDefinitionById(reportId);
        ReportResult result = new ReportResult();
        result.setReportName(definition.getReportName());

        // Prepare the query with parameters
        String query = definition.getQuery();

        // Extract parameter names in the order they appear in the query
        List<String> orderedParamNames = new ArrayList<>();
        Pattern pattern = Pattern.compile(":(\\w+)");
        Matcher matcher = pattern.matcher(query);
        while (matcher.find()) {
            orderedParamNames.add(matcher.group(1));
        }

        // Replace named parameters with ?
        for (String paramName : orderedParamNames) {
            query = query.replace(":" + paramName, "?");
        }

        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            // Set parameters in the order they appear in the query
            int paramIndex = 1;
            for (String paramName : orderedParamNames) {
                Object value = parameters.get(paramName);

                if (value instanceof java.util.Date) {
                    stmt.setTimestamp(paramIndex++, new Timestamp(((java.util.Date) value).getTime()));
                } else if (value instanceof String) {
                    stmt.setString(paramIndex++, (String) value);
                } else if (value instanceof Integer) {
                    stmt.setInt(paramIndex++, (Integer) value);
                } else {
                    stmt.setObject(paramIndex++, value);
                }
            }

            // Execute query and process results...
            ResultSet rs = stmt.executeQuery();
            ResultSetMetaData metaData = rs.getMetaData();
            int columnCount = metaData.getColumnCount();

            // Set column names
            List<String> columnNames = new ArrayList<>();
            for (int i = 1; i <= columnCount; i++) {
                columnNames.add(metaData.getColumnName(i));
            }
            result.setColumnNames(columnNames);

            // Process data
            List<Map<String, Object>> data = new ArrayList<>();
            while (rs.next()) {
                Map<String, Object> row = new LinkedHashMap<>();
                for (int i = 1; i <= columnCount; i++) {
                    row.put(metaData.getColumnName(i), rs.getObject(i));
                }
                data.add(row);
            }
            result.setData(data);
        }

        return result;
    }
    
    public byte[] exportReportToExcel(int reportId, Map<String, Object> parameters) throws SQLException {
        ReportResult result = executeReport(reportId, parameters);

        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet(result.getReportName());

            CellStyle headerStyle = createHeaderStyle(workbook);
            
            // Create header row
            Row headerRow = sheet.createRow(0);
            for (int i = 0; i < result.getColumnNames().size(); i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(result.getColumnNames().get(i));
                cell.setCellStyle(headerStyle);
            }

            // Create data rows
            int rowNum = 1;
            for (Map<String, Object> row : result.getData()) {
                Row dataRow = sheet.createRow(rowNum++);
                int colNum = 0;
                for (String colName : result.getColumnNames()) {
                    Cell cell = dataRow.createCell(colNum++);
                    Object value = row.get(colName);
                    if (value instanceof Number) {
                        cell.setCellValue(((Number) value).doubleValue());
                    } else if (value instanceof Date) {
                        cell.setCellValue((Date) value);
                        CellStyle style = workbook.createCellStyle();
                        style.setDataFormat(workbook.createDataFormat().getFormat("m/d/yy"));
                        cell.setCellStyle(style);
                    } else {
                        cell.setCellValue(value != null ? value.toString() : "");
                    }
                }
            }

            // Auto-size columns
            for (int i = 0; i < result.getColumnNames().size(); i++) {
                sheet.autoSizeColumn(i);
            }

            // Write to byte array
            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            workbook.write(outputStream);
            return outputStream.toByteArray();
        } catch (IOException e) {
            throw new SQLException("Failed to generate Excel file", e);
        }
    }

    public byte[] exportReportToPDF(int reportId, Map<String, Object> parameters) throws SQLException {
        ReportResult result = executeReport(reportId, parameters);

        try (ByteArrayOutputStream outputStream = new ByteArrayOutputStream()) {
            Document document = new Document();
            PdfWriter.getInstance(document, outputStream);
            document.open();
            
            // 4. Add metadata
            document.addTitle(result.getReportName());
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
                result.getReportName(),
                new Font(Font.FontFamily.HELVETICA, 20, Font.BOLD)
            );
            title.setAlignment(Element.ALIGN_CENTER);
            title.setSpacingAfter(5f);
            document.add(title);

            
            // Add date range if available
            if (parameters.containsKey("start_date") && parameters.containsKey("end_date")) {
                Paragraph description = new Paragraph(
                    String.format("From %s to %s", 
                        parameters.get("start_date").toString(),
                        parameters.get("end_date").toString()),
                    new Font(Font.FontFamily.HELVETICA, 12));
                description.setAlignment(Element.ALIGN_CENTER);
            description.setSpacingAfter(10f);
            document.add(description);
            }

            // Create table
            PdfPTable table = new PdfPTable(result.getColumnNames().size());
            table.setWidthPercentage(100);
            table.setSpacingBefore(15f);

            // Add header
            Font headerFont = new Font(Font.FontFamily.HELVETICA, 10, Font.BOLD, BaseColor.WHITE);
            for (String colName : result.getColumnNames()) {
                PdfPCell cell = new PdfPCell(new Phrase(colName, headerFont));
                cell.setBackgroundColor(new BaseColor(37, 99, 235));
                cell.setPadding(5);
                table.addCell(cell);
            }

            // Add data
            Font dataFont = FontFactory.getFont(FontFactory.HELVETICA);
            for (Map<String, Object> row : result.getData()) {
                for (String colName : result.getColumnNames()) {
                    Object value = row.get(colName);
                    String text = value != null ? value.toString() : "";
                    table.addCell(new Phrase(text, dataFont));
                }
            }

            document.add(table);
            document.close();
            return outputStream.toByteArray();
        } catch (DocumentException | IOException e) {
            throw new SQLException("Failed to generate PDF file", e);
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

}