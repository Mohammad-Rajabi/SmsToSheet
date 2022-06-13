package com.example.sms_to_sheet.src.data.model;


public class UserGoogleSheetInfoModel {

    private String googleSheetUrl;
    private String googleScriptsUrl;

    public String getGoogleSheetUrl() {
        return googleSheetUrl;
    }

    public void setGoogleSheetUrl(String googleSheetUrl) {
        this.googleSheetUrl = googleSheetUrl;
    }

    public String getGoogleScriptsUrl() {
        return googleScriptsUrl;
    }

    public void setGoogleScriptsUrl(String googleScriptsUrl) {
        this.googleScriptsUrl = googleScriptsUrl;
    }

    public UserGoogleSheetInfoModel(){ }

    public UserGoogleSheetInfoModel(String googleSheetUrl, String googleScriptsUrl) {
        this.googleSheetUrl = googleSheetUrl;
        this.googleScriptsUrl = googleScriptsUrl;
    }
}

