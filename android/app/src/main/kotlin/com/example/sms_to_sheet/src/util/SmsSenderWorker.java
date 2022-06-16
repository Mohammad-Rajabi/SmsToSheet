package com.example.sms_to_sheet.src.util;

import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.work.Worker;
import androidx.work.WorkerParameters;

import com.example.sms_to_sheet.R;
import com.example.sms_to_sheet.src.data.local.DBHelper;
import com.example.sms_to_sheet.src.data.model.SmsModel;
import com.example.sms_to_sheet.src.data.remote.ApiService;

import java.util.List;

public class SmsSenderWorker extends Worker {

    private Context context;
    DBHelper dbHelper;
    ApiService apiService;

    public SmsSenderWorker(@NonNull Context context, @NonNull WorkerParameters workerParams) {
        super(context, workerParams);
        this.context = context;
        this.dbHelper = new DBHelper(context);
    }

    @NonNull
    @Override
    public Result doWork() {

        List<SmsModel> smsList = dbHelper.getSmses();

        Result result = Result.retry();


        if (NetworkUtil.isInternetAvailable(context)) {

            apiService = new ApiService();

            NotificationUtil.getNotification(context, context.getResources().getString(R.string.sending_sms), R.drawable.upload);

            for (int i = 0; i < smsList.size(); i++) {


                SmsModel sms = smsList.get(i);
                apiService.workerSendSms(sms, new ResponseCallback() {
                    @Override
                    public void success() {
                        dbHelper.deleteSms(sms);
                    }

                    @Override
                    public void failure() {
                    }
                });

            }

            if (dbHelper.isEmpty()) {
                NotificationUtil.updateNotification(context, context.getResources().getString(R.string.sent_smses_successful), R.drawable.check_circle);
                result = Result.success();
            }

        }

        return result;
    }


}
