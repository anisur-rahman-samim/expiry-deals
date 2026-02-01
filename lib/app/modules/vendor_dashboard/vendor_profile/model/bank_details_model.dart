class MyBankDetailsModel {
  MyBankDetailsModel({
     this.success,
     this.message,
     this.data,
  });

  final bool? success;
  final String? message;
  final Data? data;

  factory MyBankDetailsModel.fromJson(Map<String, dynamic> json){
    return MyBankDetailsModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.id,
    required this.vendor,
    required this.accountNumber,
    required this.routingNumber,
    required this.bankName,
    required this.bankHolderName,
    required this.bankAddress,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String? id;
  final String? vendor;
  final String? accountNumber;
  final String? routingNumber;
  final String? bankName;
  final String? bankHolderName;
  final String? bankAddress;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      id: json["_id"],
      vendor: json["vendor"],
      accountNumber: json["accountNumber"],
      routingNumber: json["routingNumber"],
      bankName: json["bankName"],
      bankHolderName: json["bankHolderName"],
      bankAddress: json["bankAddress"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
    );
  }

}
