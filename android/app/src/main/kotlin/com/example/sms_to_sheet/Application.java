package com.example.sms_to_sheet;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.os.Build;

import com.example.sms_to_sheet.src.Constants;

import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;

public class Application extends FlutterApplication  {


    @Override
    public void onCreate() {
        super.onCreate();

        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
            NotificationChannel channel = new NotificationChannel(Constants.NOTIFICATION_CHANNEL_ID,"SmsMessage", NotificationManager.IMPORTANCE_LOW);
            NotificationManager manager  = getSystemService(NotificationManager.class);
            manager.createNotificationChannel(channel);
        }



    }
}
