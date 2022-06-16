class SmsResponseModel{

  String? status;
  String? message;


  SmsResponseModel({this.status, this.message});

  factory SmsResponseModel.fromJson(Map<String, dynamic> json) {
    return SmsResponseModel(
        status: json["status"],
        message: json["message"]
    );
  }
}
