import 'package:get/get.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  int quantity;
  bool isSelected;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
    this.isSelected = true,
  });
}

class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;
  var subtotal = 0.0.obs;
  var total = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    // Sample data
    cartItems.addAll([
      CartItem(id: '1', title: 'Leather Jacket', price: 89.99, imageUrl: "https://i.pinimg.com/736x/af/38/16/af3816f775f479ab6fb7dfaf30d3e553.jpg"),
      CartItem(id: '2', title: 'Wireless Earbuds', price: 59.99, imageUrl: 'https://www.dhresource.com/webp/m/0x0/f2/albu/g21/M00/1F/F5/rBVaq2DCDRGABLbyAADQ8DkUmO8389.jpg'),
      CartItem(id: '3', title: 'Leather Jacket', price: 89.99, imageUrl: "https://i.pinimg.com/736x/af/38/16/af3816f775f479ab6fb7dfaf30d3e553.jpg"),
    ]);
    calculateTotal();
  }

  void incrementQty(String id) {
    final item = cartItems.firstWhere((e) => e.id == id);
    item.quantity++;
    cartItems.refresh();
    calculateTotal();
  }

  void decrementQty(String id) {
    final item = cartItems.firstWhere((e) => e.id == id);
    if (item.quantity > 1) {
      item.quantity--;
      cartItems.refresh();
      calculateTotal();
    }
  }

  void toggleItemSelection(String id) {
    final item = cartItems.firstWhere((e) => e.id == id);
    item.isSelected = !item.isSelected;
    cartItems.refresh();
    calculateTotal();
  }

  void removeFromCart(String id) {
    cartItems.removeWhere((e) => e.id == id);
    calculateTotal();
  }

  void calculateTotal() {
    double sum = 0;
    for (var item in cartItems) {
      if (item.isSelected) {
        sum += item.price * item.quantity;
      }
    }
    subtotal.value = sum;
    total.value = sum + 9.99; // shipping
  }

  List<CartItem> get selectedItems => cartItems.where((e) => e.isSelected).toList();
}