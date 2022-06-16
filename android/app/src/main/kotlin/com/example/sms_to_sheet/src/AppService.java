package com.example.sms_to_sheet.src;

import android.app.Service;
import android.content.Intent;
import android.os.Handler;
import android.os.IBinder;
import android.util.Log;

import androidx.annotation.Nullable;
import androidx.work.Constraints;
import androidx.work.NetworkType;
import androidx.work.OneTimeWorkRequest;
import androidx.work.WorkManager;

import com.example.sms_to_sheet.R;
import com.example.sms_to_sheet.src.data.local.DBHelper;
import com.example.sms_to_sheet.src.data.model.SmsModel;
import com.example.sms_to_sheet.src.data.remote.ApiService;
import com.example.sms_to_sheet.src.util.NetworkUtil;
import com.example.sms_to_sheet.src.util.NotificationUtil;
import com.example.sms_to_sheet.src.util.ResponseCallback;
import com.example.sms_to_sheet.src.util.SmsSenderWorker;

import java.util.Iterator;
import java.util.List;


public class AppService extends Service {

    private ApiService apiService;
    private DBHelper dbHelper;

    @Override
    public void onCreate() {
        super.onCreate();
        dbHelper = new DBHelper(getApplication());
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {

        if (!intent.hasExtra(Constants.EXTRA_KEY_SMS_LIST)) {
            stopSelf();
        }

        List<SmsModel> smsList = intent.getParcelableArrayListExtra(Constants.EXTRA_KEY_SMS_LIST);


        if (NetworkUtil.isInternetAvailable(getBaseContext())) {

            apiService = new ApiService();

            startForeground(Constants.NOTIFICATION_ID, NotificationUtil.getNotification(this, getResources().getString(R.string.sending_sms), R.drawable.upload));

            for (int i=0;i<smsList.size();i++){
                SmsModel smsModel = smsList.get(i);

                apiService.sendSms(smsModel, new ResponseCallback() {
                    @Override
                    public void success() {
                        NotificationUtil
                                .updateNotification(AppService.this, getResources().getString(R.string.sent_sms_successful), R.drawable.check_circle);
                    }

                    @Override
                    public void failure() {
                    }
                });

            }

        } else {

            startForeground(Constants.NOTIFICATION_ID, NotificationUtil.getNotification(this, getResources().getString(R.string.no_internet), R.drawable.wifi_off));

            for (int i = 0; i < smsList.size(); i++) {
                dbHelper.addSms(smsList.get(i));
            }
            Constraints constraints = new Constraints.Builder()
                    .setRequiresBatteryNotLow(true)
                    .setRequiredNetworkType(NetworkType.CONNECTED)
                    .build();
            OneTimeWorkRequest work = new OneTimeWorkRequest.Builder(SmsSenderWorker.class).setConstraints(constraints).build();
            WorkManager.getInstance(getApplication()).enqueue(work);

        }
        stopService();
        return START_REDELIVER_INTENT;
    }

    private void stopService() {
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                stopSelf();
            }
        }, 15000);
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        stopForeground(true);
    }

}
