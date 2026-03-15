import 'package:get/get.dart';

import 'package:expiry_deals/app/modules/auth/controllers/vendor_request_controller.dart';

import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VendorRequestController>(
      () => VendorRequestController(),
    );
    Get.lazyPut<AuthController>(
      () => AuthController(),
    );
  }
}
