package com.example.sms_to_sheet.src.data.model;

public class SentSmsResponse {
    public String status;
    public String message;


    public SentSmsResponse(String status, String message) {
        this.status = status;
        this.message = message;
    }
}
