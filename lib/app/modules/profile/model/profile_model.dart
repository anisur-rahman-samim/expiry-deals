class ProfileModel {
    ProfileModel({
         this.success,
         this.message,
         this.data,
    });

    final bool? success;
    final String? message;
    final Data? data;

    factory ProfileModel.fromJson(Map<String, dynamic> json){ 
        return ProfileModel(
            success: json["success"],
            message: json["message"],
            data: json["data"] == null ? null : Data.fromJson(json["data"]),
        );
    }

}

class Data {
    Data({
        required this.verification,
        required this.id,
        required this.status,
        required this.name,
        required this.shop,
        required this.email,
        required this.phoneNumber,
        required this.password,
        required this.gender,
        required this.dateOfBirth,
        required this.loginWth,
        required this.profile,
        required this.document,
        required this.role,
        required this.address,
        required this.city,
        required this.state,
        required this.country,
        required this.zipCode,
        required this.isDeleted,
        required this.balance,
        required this.expireAt,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
    });

    final Verification? verification;
    final String? id;
    final String? status;
    final String? name;
    final dynamic shop;
    final String? email;
    final dynamic phoneNumber;
    final String? password;
    final dynamic gender;
    final dynamic dateOfBirth;
    final String? loginWth;
    final String? profile;
    final dynamic document;
    final String? role;
    final dynamic address;
    final dynamic city;
    final dynamic state;
    final dynamic country;
    final dynamic zipCode;
    final bool? isDeleted;
    final int? balance;
    final dynamic expireAt;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final int? v;

    factory Data.fromJson(Map<String, dynamic> json){ 
        return Data(
            verification: json["verification"] == null ? null : Verification.fromJson(json["verification"]),
            id: json["_id"],
            status: json["status"],
            name: json["name"],
            shop: json["shop"],
            email: json["email"],
            phoneNumber: json["phoneNumber"],
            password: json["password"],
            gender: json["gender"],
            dateOfBirth: json["dateOfBirth"],
            loginWth: json["loginWth"],
            profile: json["profile"],
            document: json["document"],
            role: json["role"],
            address: json["address"],
            city: json["city"],
            state: json["state"],
            country: json["country"],
            zipCode: json["zipCode"],
            isDeleted: json["isDeleted"],
            balance: json["balance"],
            expireAt: json["expireAt"],
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
            v: json["__v"],
        );
    }

}

class Verification {
    Verification({
        required this.otp,
        required this.expiresAt,
        required this.status,
    });

    final int? otp;
    final DateTime? expiresAt;
    final bool? status;

    factory Verification.fromJson(Map<String, dynamic> json){ 
        return Verification(
            otp: json["otp"],
            expiresAt: DateTime.tryParse(json["expiresAt"] ?? ""),
            status: json["status"],
        );
    }

}
