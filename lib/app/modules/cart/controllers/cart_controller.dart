import 'package:expiry_deals/app/modules/cart/model/add_to_cart_model.dart';
import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:get/get.dart';
import 'package:expiry_deals/app/data/api.dart';
import 'package:expiry_deals/app/data/base_client.dart';
import 'package:expiry_deals/common/helper/local_store.dart';

class CartController extends GetxController {
  var cartItems = <AddToCart>[].obs;
  var subtotal = 0.0.obs;
  var total = 0.0.obs;

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAddToCart();  // Fetch products when the controller is initialized
    calculateTotal();
  }



  void toggleItemSelection(String id) {final item = cartItems.firstWhere((e) => e.id == id);
    item.isSelected = !item.isSelected;
    cartItems.refresh();
    calculateTotal();
  }

  void removeFromCart(String id) {
    cartItems.removeWhere((e) => e.id == id);
    calculateTotal(); // Fixed the typo
  }

  void calculateTotal() {
    double sum = 0;
    for (var item in cartItems) {
      if (item.isSelected) {
        final price = item.product?.price ?? 0;
        final qty = item.quantity ?? 1;
        sum += price * qty;
      }
    }
    subtotal.value = sum;
    total.value = sum + 9.99; // shipping
  }

 // List<AddToCart> get selectedItems => cartItems.where((e) => e.isSelected).toList();

  String? getCartAuthorId() {
    if (cartItems.isEmpty) return null;

    return cartItems.first.product?.author?.id;
  }

  /// Fetches cart from API. Use [silent]=true during add-to-cart so the full
  /// cart screen does not show a global loading flicker.
  Future<void> fetchAddToCart({bool silent = false}) async {
    try {
      if (!silent) {
        isLoading(true);
      }

      var token = LocalStorage.getData(key: AppConstant.token);
      if (token == null || token.isEmpty) {
        Get.snackbar('Error', 'Authentication token is missing.');
        return;
      }

      var headers = {
        'Authorization': 'Bearer $token',
      };

      dynamic response = await BaseClient.handleResponse(
        await BaseClient.getRequest(
          api: Api.cart,
          headers: headers,
        ),
      );

      if (response != null && response['success'] == true) {
        // Map the API response to the ProductModel and assign it to the product list
        cartItems.assignAll(AddToCartModel.fromJson(response).data?.data ?? []);
        calculateTotal();
      } else {
        Get.snackbar('Error', 'Failed to load cart.');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      if (!silent) {
        isLoading(false);
      }
    }
  }

  Future<void> deleteAddToCart({required String cartId}) async {
    try {
      isLoading(true);

      var token = LocalStorage.getData(key: AppConstant.token);
      if (token == null || token.isEmpty) {
        Get.snackbar('Error', 'Authentication token is missing.');
        return;
      }

      dynamic response = await BaseClient.handleResponse(
        await BaseClient.deleteRequest(
          api: Api.deleteCart(cartId: cartId),

        ),
      );

      if (response != null && response['success'] == true) {
        await fetchAddToCart();
      } else {
        Get.snackbar('Error', 'Failed to remove item from cart.');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
  /// Clears the server cart. If [refreshCartAfter] is false, only local state is
  /// cleared after success (avoids an extra GET — use when you will refetch once
  /// after adding a new item).
  Future<void> cartEmpty({bool refreshCartAfter = true}) async {
    try {
      isLoading(true);

      var token = LocalStorage.getData(key: AppConstant.token);
      if (token == null || token.isEmpty) {
        Get.snackbar('Error', 'Authentication token is missing.');
        return;
      }

      dynamic response = await BaseClient.handleResponse(
        await BaseClient.deleteRequest(
          api: Api.cartEmpty

        ),
      );

      if (response != null && response['success'] == true) {
        if (refreshCartAfter) {
          await fetchAddToCart();
        } else {
          cartItems.clear();
          calculateTotal();
        }
      } else {
        Get.snackbar('Error', 'Failed to empty cart.');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
