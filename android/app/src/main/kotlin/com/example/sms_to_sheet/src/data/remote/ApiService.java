package com.example.sms_to_sheet.src.data.remote;


import static com.example.sms_to_sheet.src.Constants.BASE_URL;
import static com.example.sms_to_sheet.src.Constants.GOOGLE_SHEET_ID;
import static com.example.sms_to_sheet.src.Constants.POST_ENDPOINT;

import com.example.sms_to_sheet.src.data.model.SentSmsResponse;
import com.example.sms_to_sheet.src.data.model.SmsModel;
import com.example.sms_to_sheet.src.util.ResponseCallback;

import java.io.IOException;

import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

public class ApiService {

    private Retrofit retrofit;
    private ApiInterface apiInterface;

    public ApiService() {

        retrofit = new Retrofit.Builder()
                .baseUrl(BASE_URL)
                .addConverterFactory(GsonConverterFactory.create())
                .build();

        apiInterface = retrofit.create(ApiInterface.class);
    }


    public void sendSms(SmsModel smsModel, ResponseCallback callback) {

        Call<SentSmsResponse> call = apiInterface.sendSms(POST_ENDPOINT, GOOGLE_SHEET_ID,
                smsModel.getAmount(),
                smsModel.getJalaliDate(),
                smsModel.getGregorianDate(), "false");

        call.enqueue(new Callback<SentSmsResponse>() {
            @Override
            public void onResponse(Call<SentSmsResponse> call, Response<SentSmsResponse> response) {
                if (response.body() != null && response.body().status.equals("SUCCESS")) {
                    callback.successful();

                } else {
                    callback.failure();
                }
            }

            @Override
            public void onFailure(Call<SentSmsResponse> call, Throwable t) {
                callback.failure();
            }
        });
    }

    public void workerSendSms( SmsModel smsModel, ResponseCallback callback) {


        Call<SentSmsResponse> call = apiInterface.sendSms(POST_ENDPOINT, GOOGLE_SHEET_ID,
                smsModel.getAmount(),
                smsModel.getJalaliDate(),
                smsModel.getGregorianDate(), "false");

        try {
            Response<SentSmsResponse> response = call.execute();
            if (response.body() != null && response.body().status.equals("SUCCESS")) {
                callback.successful();
            } else {
                callback.failure();
            }
        } catch (IOException e) {
            callback.failure();
        }

    }
}
