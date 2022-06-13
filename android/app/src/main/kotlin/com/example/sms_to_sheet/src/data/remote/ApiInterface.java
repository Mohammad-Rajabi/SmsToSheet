package com.example.sms_to_sheet.src.data.remote;

import com.example.sms_to_sheet.src.data.model.SentSmsResponse;

import retrofit2.Call;
import retrofit2.http.Field;
import retrofit2.http.FormUrlEncoded;
import retrofit2.http.POST;
import retrofit2.http.Url;

public interface ApiInterface {

    @FormUrlEncoded
    @POST
    Call<SentSmsResponse> sendSms(
            @Url String url,
            @Field("ssid") String ssid,
                                  @Field("amount") String amount,
                                  @Field("jalaliDate") String jalaliDate,
                                  @Field("gregorianDate") String gregorianDate,
                                  @Field("isEditMode") String isEditMode);
}
