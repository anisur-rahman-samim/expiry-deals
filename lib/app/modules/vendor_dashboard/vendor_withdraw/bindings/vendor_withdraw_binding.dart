import 'package:get/get.dart';

import '../controllers/vendor_withdraw_controller.dart';

class VendorWithdrawBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VendorWithdrawController>(
      () => VendorWithdrawController(),
    );
  }
}
