class StoreWiseProductModel {
  StoreWiseProductModel({
     this.success,
     this.message,
     this.data,
  });

  final bool? success;
  final String? message;
  final Data? data;

  factory StoreWiseProductModel.fromJson(Map<String, dynamic> json){
    return StoreWiseProductModel(
      success: json["success"],
      message: json["message"],
      data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );
  }

}

class Data {
  Data({
    required this.data,
    required this.meta,
  });

  final List<StoreWiseProduct> data;
  final Meta? meta;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      data: json["data"] == null ? [] : List<StoreWiseProduct>.from(json["data"]!.map((x) => StoreWiseProduct.fromJson(x))),
      meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    );
  }

}

class StoreWiseProduct {
  StoreWiseProduct({
    required this.id,
    required this.images,
    required this.author,
    required this.name,
    required this.details,
    required this.category,
    required this.price,
    required this.totalSell,
    required this.stock,
    required this.expiredAt,
    required this.discount,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  final String? id;
  final List<Image> images;
  final Author? author;
  final String? name;
  final String? details;
  final Category? category;
  final dynamic price;
  final int? totalSell;
  final int? stock;
  final String? expiredAt;
  final dynamic discount;
  final bool? isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory StoreWiseProduct.fromJson(Map<String, dynamic> json){
    return StoreWiseProduct(
      id: json["_id"],
      images: json["images"] == null ? [] : List<Image>.from(json["images"]!.map((x) => Image.fromJson(x))),
      author: json["author"] == null ? null : Author.fromJson(json["author"]),
      name: json["name"],
      details: json["details"],
      category: json["category"] == null ? null : Category.fromJson(json["category"]),
      price: json["price"],
      totalSell: json["totalSell"],
      stock: json["stock"],
      expiredAt: json["expiredAt"],
      discount: json["discount"],
      isDeleted: json["isDeleted"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

}

class Author {
  Author({
    required this.id,
    required this.name,
    required this.shop,
    required this.email,
    required this.phoneNumber,
    required this.profile,
  });

  final String? id;
  final String? name;
  final Shop? shop;
  final String? email;
  final dynamic phoneNumber;
  final dynamic profile;

  factory Author.fromJson(Map<String, dynamic> json){
    return Author(
      id: json["_id"],
      name: json["name"],
      shop: json["shop"] == null ? null : Shop.fromJson(json["shop"]),
      email: json["email"],
      phoneNumber: json["phoneNumber"],
      profile: json["profile"],
    );
  }

}

class Shop {
  Shop({
    required this.location,
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
    required this.isDeleted,
    required this.bannerColor,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final Location? location;
  final String? id;
  final String? name;
  final dynamic description;
  final dynamic address;
  final dynamic openingHours;
  final dynamic openingDays;
  final String? logo;
  final String? banner;
  final String? document;
  final String? author;
  final bool? isDeleted;
  final String? bannerColor;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory Shop.fromJson(Map<String, dynamic> json){
    return Shop(
      location: json["location"] == null ? null : Location.fromJson(json["location"]),
      id: json["_id"],
      name: json["name"],
      description: json["description"],
      address: json["address"],
      openingHours: json["openingHours"],
      openingDays: json["openingDays"],
      logo: json["logo"],
      banner: json["banner"],
      document: json["document"],
      author: json["author"],
      isDeleted: json["isDeleted"],
      bannerColor: json["bannerColor"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
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

class Category {
  Category({
    required this.id,
    required this.name,
    required this.banner,
  });

  final String? id;
  final String? name;
  final String? banner;

  factory Category.fromJson(Map<String, dynamic> json){
    return Category(
      id: json["_id"],
      name: json["name"],
      banner: json["banner"],
    );
  }

}

class Image {
  Image({
    required this.key,
    required this.url,
    required this.id,
  });

  final String? key;
  final String? url;
  final String? id;

  factory Image.fromJson(Map<String, dynamic> json){
    return Image(
      key: json["key"],
      url: json["url"],
      id: json["_id"],
    );
  }

}

class Meta {
  Meta({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPage,
  });

  final int? page;
  final int? limit;
  final int? total;
  final int? totalPage;

  factory Meta.fromJson(Map<String, dynamic> json){
    return Meta(
      page: json["page"],
      limit: json["limit"],
      total: json["total"],
      totalPage: json["totalPage"],
    );
  }

}
