package com.example.sms_to_sheet.src.util;

import static android.content.Context.NOTIFICATION_SERVICE;

import android.app.Notification;
import android.app.NotificationManager;
import android.content.Context;

import androidx.core.app.NotificationCompat;

import com.example.sms_to_sheet.src.Constants;


public class NotificationUtil {
    public static Notification getNotification(Context context,String title, int iconId) {
        NotificationCompat.Builder builder = new NotificationCompat.Builder(context, Constants.NOTIFICATION_CHANNEL_ID)
                .setContentTitle(title)
                .setSmallIcon(iconId);

        return builder.build();
    }

    public static void updateNotification(Context context,String title, int iconId) {
        NotificationManager notificationManager = (NotificationManager) context.getSystemService(
                NOTIFICATION_SERVICE);
        notificationManager.notify(Constants.NOTIFICATION_ID, getNotification(context,title, iconId));
    }
}
