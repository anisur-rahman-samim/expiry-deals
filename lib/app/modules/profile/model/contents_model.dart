class ContentModel {
  ContentModel({
     this.success,
     this.message,
     this.data,
  });

  final bool? success;
  final String? message;
  final Data? data;

  factory ContentModel.fromJson(Map<String, dynamic> json){
    return ContentModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.id,
    required this.aboutUs,
    required this.termsAndConditions,
    required this.privacyPolicy,
    required this.supports,
    required this.faq,
    required this.isDeleted,
    required this.banner,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String? id;
  final String? aboutUs;
  final String? termsAndConditions;
  final String? privacyPolicy;
  final String? supports;
  final String? faq;
  final bool? isDeleted;
  final List<dynamic> banner;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      id: json["_id"],
      aboutUs: json["aboutUs"],
      termsAndConditions: json["termsAndConditions"],
      privacyPolicy: json["privacyPolicy"],
      supports: json["supports"],
      faq: json["faq"],
      isDeleted: json["isDeleted"],
      banner: json["banner"] == null ? [] : List<dynamic>.from(json["banner"]!.map((x) => x)),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
    );
  }

}
