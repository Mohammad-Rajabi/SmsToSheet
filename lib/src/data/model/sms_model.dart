class SmsModel {
  int? amount;
  String? description;
  String? jalaliDate;
  String? gregorianDate;

  SmsModel(
      {this.amount, this.description, this.jalaliDate,this.gregorianDate});

  factory SmsModel.fromJson(Map<String, dynamic> json) {
    return SmsModel(
      amount: json["amount"],
      description: json["name"],
      jalaliDate: json["jalaliDate"]
    );
  }
}
