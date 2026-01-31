// import 'dart:convert';
// import 'package:expiry_deals/app/modules/cart/model/add_to_cart_model.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:expiry_deals/app/data/api.dart';
// import 'package:expiry_deals/app/data/base_client.dart';
// import 'package:expiry_deals/common/helper/local_store.dart';
// import 'package:expiry_deals/common/app_constant/app_constant.dart';
//
// import '../../../../common/helper/current_location.dart';
//
// class AddToCartController extends GetxController {
//   var isLoading = false.obs;
//   var addToCart = <AddToCart>[].obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchAddToCart();  // Fetch products when the controller is initialized
//   }
//
//   // Fetch products from the server
//
//   Future<void> fetchAddToCart() async {
//     try {
//       isLoading(true);
//
//       var token = LocalStorage.getData(key: AppConstant.token);
//       if (token == null || token.isEmpty) {
//         Get.snackbar('Error', 'Authentication token is missing.');
//         return;
//       }
//
//
//       var headers = {
//         'Authorization': 'Bearer $token',
//       };
//
//       dynamic response = await BaseClient.handleResponse(
//         await BaseClient.getRequest(
//           api: Api.cart,
//           headers: headers,
//         ),
//       );
//
//       if (response != null && response['success'] == true) {
//         // Map the API response to the ProductModel and assign it to the product list
//         addToCart.assignAll(AddToCartModel.fromJson(response).data?.data ?? []);
//       } else {
//         Get.snackbar('Error', 'Failed to fetch addToCart.');
//       }
//     } catch (e) {
//       Get.snackbar('Error', e.toString());
//     } finally {
//       isLoading(false);
//     }
//   }
// }
