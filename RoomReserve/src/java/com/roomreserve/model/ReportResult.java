package com.roomreserve.model;

import java.util.List;
import java.util.Map;

public class ReportResult {
    private String reportName;
    private List<String> columnNames;
    private List<Map<String, Object>> data;

    public ReportResult() {
    }

    public String getReportName() {
        return reportName;
    }

    public void setReportName(String reportName) {
        this.reportName = reportName;
    }

    public List<String> getColumnNames() {
        return columnNames;
    }

    public void setColumnNames(List<String> columnNames) {
        this.columnNames = columnNames;
    }

    public List<Map<String, Object>> getData() {
        return data;
    }

    public void setData(List<Map<String, Object>> data) {
        this.data = data;
    }
    
    
}
