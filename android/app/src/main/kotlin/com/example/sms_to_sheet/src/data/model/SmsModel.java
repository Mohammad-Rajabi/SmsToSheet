package com.example.sms_to_sheet.src.data.model;

import android.os.Parcel;
import android.os.Parcelable;

import java.io.Serializable;

public class SmsModel implements Parcelable {

    private int id;
    private String amount;
    private String jalaliDate;
    private String gregorianDate;

    protected SmsModel(Parcel in) {
        id = in.readInt();
        amount = in.readString();
        jalaliDate = in.readString();
        gregorianDate = in.readString();
    }

    public static final Creator<SmsModel> CREATOR = new Creator<SmsModel>() {
        @Override
        public SmsModel createFromParcel(Parcel in) {
            return new SmsModel(in);
        }

        @Override
        public SmsModel[] newArray(int size) {
            return new SmsModel[size];
        }
    };

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

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeInt(id);
        dest.writeString(amount);
        dest.writeString(jalaliDate);
        dest.writeString(gregorianDate);
    }
}
