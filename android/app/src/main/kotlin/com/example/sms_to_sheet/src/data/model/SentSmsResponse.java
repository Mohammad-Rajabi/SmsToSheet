package com.example.sms_to_sheet.src.data.model;

import com.google.gson.annotations.SerializedName;

public class SentSmsResponse {
    @SerializedName("status")
    public String status;
    public String message;


    public SentSmsResponse(String status, String message) {
        this.status = status;
        this.message = message;
    }
}
