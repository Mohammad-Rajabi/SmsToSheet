package com.example.sms_to_sheet.src.data.local;

import android.annotation.SuppressLint;
import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteException;
import android.database.sqlite.SQLiteOpenHelper;

import androidx.annotation.Nullable;

import com.example.sms_to_sheet.src.data.model.SmsModel;

import java.util.ArrayList;
import java.util.List;

public class DBHelper extends SQLiteOpenHelper {

    private static final int DB_VERSION = 1;
    private static final String TABLE_SMS = "tbl_sms";
    private static final String COLUMN_ID = "id";
    private static final String COLUMN_AMOUNT = "amount";
    private static final String COLUMN_JALALI_DATE = "jalaliDate";
    private static final String COLUMN_GREGORIAN_DATE = "gregorianDate";



    public DBHelper(@Nullable Context context) {
        super(context, "AppDb", null, DB_VERSION);
    }

    @Override
    public void onCreate(SQLiteDatabase db) {
        try {
            db.execSQL("CREATE TABLE " + TABLE_SMS + "(" + COLUMN_ID + " INTEGER PRIMARY KEY AUTOINCREMENT, " + COLUMN_AMOUNT + " TEXT," + COLUMN_JALALI_DATE + " TEXT," + COLUMN_GREGORIAN_DATE + " TEXT);");

        } catch (SQLiteException e) {

        }
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {

    }


    public long addSms(SmsModel sms) {
        SQLiteDatabase sqLiteDatabase = getWritableDatabase();
        ContentValues contentValues = new ContentValues();
        contentValues.put(COLUMN_AMOUNT, sms.getAmount());
        contentValues.put(COLUMN_JALALI_DATE, sms.getJalaliDate());
        contentValues.put(COLUMN_GREGORIAN_DATE, sms.getGregorianDate());
        long result = sqLiteDatabase.insert(TABLE_SMS, null, contentValues);
        sqLiteDatabase.close();
        return result;
    }

    public int deleteSms(SmsModel sms) {
        SQLiteDatabase sqLiteDatabase = getWritableDatabase();
        int result = sqLiteDatabase.delete(TABLE_SMS, "" + COLUMN_ID + "=?", new String[]{String.valueOf(sms.getId())});

        sqLiteDatabase.close();
        return result;
    }


    @SuppressLint("Range")
    public List<SmsModel> getSmses() {
        SQLiteDatabase sqLiteDatabase = getReadableDatabase();
        Cursor cursor = sqLiteDatabase.rawQuery("SELECT * FROM " + TABLE_SMS, null);
        List<SmsModel> smsModels = new ArrayList<>();
        if (cursor.moveToFirst()) {
            do {
                SmsModel smsModel = new SmsModel();
                smsModel.setAmount(cursor.getString(cursor.getColumnIndex(COLUMN_AMOUNT)));
                smsModel.setJalaliDate(cursor.getString(cursor.getColumnIndex(COLUMN_JALALI_DATE)));
                smsModel.setGregorianDate(cursor.getString(cursor.getColumnIndex(COLUMN_GREGORIAN_DATE)));
                smsModel.setId(cursor.getInt(cursor.getColumnIndex(COLUMN_ID)));
                smsModels.add(smsModel);
            } while (cursor.moveToNext());
        }
        sqLiteDatabase.close();
        return smsModels;
    }

    public boolean isEmpty() {

        SQLiteDatabase sqLiteDatabase = getReadableDatabase();
        Cursor cursor = sqLiteDatabase.rawQuery("SELECT count(*) FROM " + TABLE_SMS, null);
        cursor.moveToFirst();
        int count = cursor.getInt(0);

        if (count == 0) {
            return true;
        } else {
            return false;
        }
    }



}
