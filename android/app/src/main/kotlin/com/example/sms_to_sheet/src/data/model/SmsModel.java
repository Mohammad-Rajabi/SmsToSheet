package com.example.sms_to_sheet.src.data.model;

import java.io.Serializable;

public class SmsModel implements Serializable {

    private int id;
    private String amount;
    private String jalaliDate;
    private String gregorianDate;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setAmount(String amount) {
        this.amount = amount;
    }

    public void setJalaliDate(String jalaliDate) {
        this.jalaliDate = jalaliDate;
    }

    public void setGregorianDate(String gregorianDate) {
        this.gregorianDate = gregorianDate;
    }

    public String getAmount() {
        return amount;
    }

    public String getJalaliDate() {
        return jalaliDate;
    }

    public String getGregorianDate() {
        return gregorianDate;
    }

    public SmsModel(){ }

    public SmsModel(String amount, String jalaliDate, String gregorianDate) {
        this.amount = amount;
        this.jalaliDate = jalaliDate;
        this.gregorianDate = gregorianDate;
    }
}
