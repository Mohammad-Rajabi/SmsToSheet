package com.example.sms_to_sheet.src.data.local;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.os.Parcelable;
import android.telephony.SmsMessage;
import android.util.Log;

import com.example.sms_to_sheet.src.AppService;
import com.example.sms_to_sheet.src.Constants;
import com.example.sms_to_sheet.src.data.model.SmsModel;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import saman.zamani.persiandate.PersianDate;

public class SmsReceiver extends BroadcastReceiver {

    public static final String pdu_type = "pdus";

    @Override
    public void onReceive(Context context, Intent intent) {
        Bundle bundle = intent.getExtras();
        SmsMessage[] messages;
        String format = bundle.getString("format");
        List<SmsModel> smsList = new ArrayList<>();
        Object[] pdus = (Object[]) bundle.get(pdu_type);

        if (pdus != null) {
            messages = new SmsMessage[pdus.length];
            for (int i = 0; i < messages.length; i++) {
                if (Build.VERSION.SDK_INT >=
                        Build.VERSION_CODES.M) {
                    messages[i] =
                            SmsMessage.createFromPdu((byte[]) pdus[i], format);
                }
//                else {
//                    messages[i] = SmsMessage.createFromPdu((byte[]) pdus[i]);
//                }

                if (messages[i].getDisplayOriginatingAddress().contains("bank") || messages[i].getDisplayOriginatingAddress().contains("500014747")) {
                    ////////////////////
                    Log.i("SMS",messages[i].getDisplayOriginatingAddress());
                    SmsModel smsModel = fetchInfo(messages[i]);
                    smsList.add(smsModel);
                }
            }
            if (!smsList.isEmpty()) {
                startService(context, smsList);
            }
        }
    }

    private SmsModel fetchInfo(SmsMessage smsMessage) {
        String amount = smsMessage.getMessageBody().split("مبلغ")[1].split("\n")[0];
        long currentTimeMillis = smsMessage.getTimestampMillis();
        Date date = new Date(currentTimeMillis);

        DateFormat simpleDateFormat = new SimpleDateFormat("dd MMM yyyy HH:mm");

        String gregorianDate = simpleDateFormat.format(date);


        PersianDate persianDate = new PersianDate(currentTimeMillis);

        String jalaliDate = persianDate.toString();
        SmsModel smsModel = new SmsModel(amount, jalaliDate, gregorianDate);
        return smsModel;
    }

    private void startService(Context context, List<SmsModel> smsList) {
        Intent intent = new Intent(context, AppService.class).putParcelableArrayListExtra(Constants.EXTRA_KEY_SMS_LIST, (ArrayList<? extends Parcelable>) smsList);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            context.startForegroundService(intent);
        } else {
            context.startService(intent);
        }
    }
}
