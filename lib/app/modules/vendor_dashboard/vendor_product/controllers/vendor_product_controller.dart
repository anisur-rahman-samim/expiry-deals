// vendor_product_controller.dart

import 'package:get/get.dart';

class VendorProductController extends GetxController {
  var isLoading = true.obs;
  var products = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void fetchProducts() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1)); // Simulate API

    // Dummy data
    products.assignAll([
    Product(
    name: 'Men\'s Slim Fit Denim Jacket',
    price: 89.99,
    imageUrl: 'https://images.unsplash.com/photo-1551537482-37a5f5c1f3b9?w=800',
    ),
    Product(
    name: 'Women\'s Oversized Hoodie',
    price: 64.99,
    imageUrl: 'https://images.unsplash.com/photo-1556821840-8e1a6e8d5c3f?w=800',
    ),

    Product(
    name: 'Classic White Sneakers',
    price: 79.99,
    imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800',
    ),
    Product(
    name: 'Leather Crossbody Bag',
    price: 120.00,
    imageUrl: 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=800',
    ),
    Product(
    name: 'Floral Summer Maxi Dress',
    price: 74.99,
    imageUrl: 'https://images.unsplash.com/photo-1595777457583-4bac71eaf301?w=800',
    ),
    Product(
    name: 'Men\'s Chino Pants - Beige',
    price: 59.99,
    imageUrl: 'https://images.unsplash.com/photo-1591195853828-11db59a44f6b?w=800',
    ),
    Product(
    name: 'Knitted Cardigan Sweater',
    price: 69.99,
    imageUrl: 'https://images.unsplash.com/photo-1622445275576-721325763afe?w=800',
    ),
    Product(
    name: 'High-Waist Mom Jeans',
    price: 54.99,
    imageUrl: 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=800',
    ),
    Product(
    name: 'Unisex Baseball Cap',
    price: 29.99,
    imageUrl: 'https://images.unsplash.com/photo-1588854337236-6889d6319af9?w=800',
    ),
    Product(
    name: 'Striped Long Sleeve Shirt',
    price: 49.99,
    imageUrl: 'https://images.unsplash.com/photo-1604176354204-9268737828e4?w=800',
    ),
    Product(
    name: 'Women\'s Ankle Boots',
    price: 99.99,
    imageUrl: 'https://images.unsplash.com/photo-1605733513597-a8f8341080e6?w=800',
    ),
    Product(
    name: 'Minimalist Gold Watch',
    price: 149.99,
    imageUrl: 'https://images.unsplash.com/photo-1524592094714-0f0654e20314?w=800',
    ),
    Product(
    name: 'Cozy Knit Beanie',
    price: 24.99,
    imageUrl: 'https://images.unsplash.com/photo-1576871337632-b9aef4c17ab9?w=800',
    ),
    Product(
    name: 'Linen Button-Down Shirt',
    price: 69.99,
    imageUrl: 'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=800',
    ),
    Product(
    name: 'Elegant Silk Scarf',
    price: 44.99,
    imageUrl: 'https://images.unsplash.com/photo-1601924994987-69e26d50dc7f?w=800',
    ),
    ]);

    isLoading.value = false;
  }
}

class Product {
  final String? name;
  final double? price;
  final String? imageUrl;
  Product({this.name, this.price, this.imageUrl});
}