package com.example.sms_to_sheet.src.util;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public final class NativeMethodChannel {
    private static final String CHANNEL_NAME = "smsChannel";
    private static MethodChannel methodChannel;


    public static void configureChannel(FlutterEngine flutterEngine) {
        methodChannel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL_NAME);
    }


    public static void sendSms(String amount,String jalaliDate,String gregorianDate) {
        Map<String,String> arguments = new HashMap<>();
        arguments.put("amount",amount);
        arguments.put("jalaliDate",jalaliDate);
        arguments.put("gregorianDate",gregorianDate);

        methodChannel.invokeMethod("sendSms", arguments);
    }
}


