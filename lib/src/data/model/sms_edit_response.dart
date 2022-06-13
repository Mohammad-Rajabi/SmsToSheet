class SmsEditResponse{

  String? status;
  String? message;


  SmsEditResponse({this.status, this.message});

  factory SmsEditResponse.fromJson(Map<String, dynamic> json) {
    return SmsEditResponse(
        status: json["status"],
        message: json["message"]
    );
  }
}
