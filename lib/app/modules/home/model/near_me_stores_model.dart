class NearMeStoresModel {
  NearMeStoresModel({
     this.success,
     this.message,
     this.data,
  });

  final bool? success;
  final String? message;
  final Data? data;

  factory NearMeStoresModel.fromJson(Map<String, dynamic> json){
    return NearMeStoresModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.meta,
    required this.data,
  });

  final Meta? meta;
  final List<NearMeStores> data;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
      data: json["data"] == null ? [] : List<NearMeStores>.from(json["data"]!.map((x) => NearMeStores.fromJson(x))),
    );
  }

}

class NearMeStores {
  NearMeStores({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.openingHours,
    required this.openingDays,
    required this.logo,
    required this.banner,
    required this.document,
    required this.author,
    required this.location,
    required this.isDeleted,
    required this.bannerColor,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String? id;
  final String? name;
  final String? description;
  final String? address;
  final String? openingHours;
  final String? openingDays;
  final String? logo;
  final String? banner;
  final String? document;
  final Author? author;
  final Location? location;
  final bool? isDeleted;
  final String? bannerColor;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory NearMeStores.fromJson(Map<String, dynamic> json){
    return NearMeStores(
      id: json["_id"],
      name: json["name"],
      description: json["description"],
      address: json["address"],
      openingHours: json["openingHours"],
      openingDays: json["openingDays"],
      logo: json["logo"],
      banner: json["banner"],
      document: json["document"],
      author: json["author"] == null ? null : Author.fromJson(json["author"]),
      location: json["location"] == null ? null : Location.fromJson(json["location"]),
      isDeleted: json["isDeleted"],
      bannerColor: json["bannerColor"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
    );
  }

}

class Author {
  Author({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.profile,
  });

  final String? id;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? profile;

  factory Author.fromJson(Map<String, dynamic> json){
    return Author(
      id: json["_id"],
      name: json["name"],
      email: json["email"],
      phoneNumber: json["phoneNumber"],
      profile: json["profile"],
    );
  }

}

class Location {
  Location({
    required this.type,
    required this.coordinates,
  });

  final String? type;
  final List<double> coordinates;

  factory Location.fromJson(Map<String, dynamic> json){
    return Location(
      type: json["type"],
      coordinates: json["coordinates"] == null ? [] : List<double>.from(json["coordinates"]!.map((x) => x)),
    );
  }

}

class Meta {
  Meta({
    required this.page,
    required this.limit,
    required this.total,
  });

  final int? page;
  final int? limit;
  final int? total;

  factory Meta.fromJson(Map<String, dynamic> json){
    return Meta(
      page: json["page"],
      limit: json["limit"],
      total: json["total"],
    );
  }

}
