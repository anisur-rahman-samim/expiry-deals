class MyVendorOrderModel {
  MyVendorOrderModel({
     this.success,
     this.message,
     this.data,
  });

  final bool? success;
  final String? message;
  final Data? data;

  factory MyVendorOrderModel.fromJson(Map<String, dynamic> json){
    return MyVendorOrderModel(
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

  final List<MyVendorOrder> data;
  final Meta? meta;

  factory Data.fromJson(Map<String, dynamic> json){
    return Data(
      data: json["data"] == null ? [] : List<MyVendorOrder>.from(json["data"]!.map((x) => MyVendorOrder.fromJson(x))),
      meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
    );
  }

}

class MyVendorOrder {
  MyVendorOrder({
    required this.billingDetails,
    required this.id,
    required this.user,
    required this.author,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.isPaid,
    required this.isDeleted,
    required this.datumId,
    required this.tnxId,
    required this.createdAt,
    required this.updatedAt,
  });

  final BillingDetails? billingDetails;
  final String? id;
  final UserClass? user;
  final UserClass? author;
  final List<Item> items;
  final double? totalPrice;
  final String? status;
  final bool? isPaid;
  final bool? isDeleted;
  final String? datumId;
  final String? tnxId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory MyVendorOrder.fromJson(Map<String, dynamic> json){
    return MyVendorOrder(
      billingDetails: json["billingDetails"] == null ? null : BillingDetails.fromJson(json["billingDetails"]),
      id: json["_id"],
      user: json["user"] == null ? null : UserClass.fromJson(json["user"]),
      author: json["author"] == null ? null : UserClass.fromJson(json["author"]),
      items: json["items"] == null ? [] : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
      totalPrice: json["totalPrice"],
      status: json["status"],
      isPaid: json["isPaid"],
      isDeleted: json["isDeleted"],
      datumId: json["id"],
      tnxId: json["tnxId"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
    );
  }

}

class UserClass {
  UserClass({
    required this.id,
    required this.name,
    required this.shop,
    required this.email,
    required this.phoneNumber,
    required this.profile,
  });

  final String? id;
  final String? name;
  final UserShop? shop;
  final String? email;
  final String? phoneNumber;
  final String? profile;

  factory UserClass.fromJson(Map<String, dynamic> json){
    return UserClass(
      id: json["_id"],
      name: json["name"],
      shop: json["shop"] == null ? null : UserShop.fromJson(json["shop"]),
      email: json["email"],
      phoneNumber: json["phoneNumber"],
      profile: json["profile"],
    );
  }

}

class UserShop {
  UserShop({
    required this.id,
    required this.name,
    required this.logo,
    required this.banner,
    required this.bannerColor,
  });

  final String? id;
  final String? name;
  final String? logo;
  final String? banner;
  final String? bannerColor;

  factory UserShop.fromJson(Map<String, dynamic> json){
    return UserShop(
      id: json["_id"],
      name: json["name"],
      logo: json["logo"],
      banner: json["banner"],
      bannerColor: json["bannerColor"],
    );
  }

}

class BillingDetails {
  BillingDetails({
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
  });

  final String? address;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? country;

  factory BillingDetails.fromJson(Map<String, dynamic> json){
    return BillingDetails(
      address: json["address"],
      city: json["city"],
      state: json["state"],
      zipCode: json["zipCode"],
      country: json["country"],
    );
  }

}

class Item {
  Item({
    required this.product,
    required this.price,
    required this.discount,
    required this.quantity,
    required this.id,
  });

  final Product? product;
  final double? price;
  final int? discount;
  final int? quantity;
  final String? id;

  factory Item.fromJson(Map<String, dynamic> json){
    return Item(
      product: json["product"] == null ? null : Product.fromJson(json["product"]),
      price: json["price"],
      discount: json["discount"],
      quantity: json["quantity"],
      id: json["_id"],
    );
  }

}

class Product {
  Product({
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
    required this.v,
  });

  final String? id;
  final List<Image> images;
  final ProductAuthor? author;
  final String? name;
  final String? details;
  final Category? category;
  final double? price;
  final int? totalSell;
  final int? stock;
  final String? expiredAt;
  final int? discount;
  final bool? isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory Product.fromJson(Map<String, dynamic> json){
    return Product(
      id: json["_id"],
      images: json["images"] == null ? [] : List<Image>.from(json["images"]!.map((x) => Image.fromJson(x))),
      author: json["author"] == null ? null : ProductAuthor.fromJson(json["author"]),
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
      v: json["__v"],
    );
  }

}

class ProductAuthor {
  ProductAuthor({
    required this.id,
    required this.name,
    required this.shop,
    required this.email,
    required this.phoneNumber,
    required this.profile,
  });

  final String? id;
  final String? name;
  final PurpleShop? shop;
  final String? email;
  final String? phoneNumber;
  final String? profile;

  factory ProductAuthor.fromJson(Map<String, dynamic> json){
    return ProductAuthor(
      id: json["_id"],
      name: json["name"],
      shop: json["shop"] == null ? null : PurpleShop.fromJson(json["shop"]),
      email: json["email"],
      phoneNumber: json["phoneNumber"],
      profile: json["profile"],
    );
  }

}

class PurpleShop {
  PurpleShop({
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
  final String? description;
  final String? address;
  final String? openingHours;
  final String? openingDays;
  final String? logo;
  final String? banner;
  final String? document;
  final String? author;
  final bool? isDeleted;
  final String? bannerColor;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory PurpleShop.fromJson(Map<String, dynamic> json){
    return PurpleShop(
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
