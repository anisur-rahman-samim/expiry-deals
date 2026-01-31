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
        sum += item.product?.price ?? 0 * item.quantity!; // Updated price access
      }
    }
    subtotal.value = sum;
    total.value = sum + 9.99; // shipping
  }

 // List<AddToCart> get selectedItems => cartItems.where((e) => e.isSelected).toList();

  // Fetch products from the server
  Future<void> fetchAddToCart() async {
    try {
      isLoading(true);

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
      } else {
        Get.snackbar('Error', 'Failed to fetch addToCart.');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
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

      var headers = {
        'Authorization': 'Bearer $token',
      };

      dynamic response = await BaseClient.handleResponse(
        await BaseClient.deleteRequest(
          api: Api.deleteCart(cartId: cartId),

        ),
      );

      if (response != null && response['success'] == true) {
        await fetchAddToCart();
      } else {
        Get.snackbar('Error', 'Failed to fetch addToCart.');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
