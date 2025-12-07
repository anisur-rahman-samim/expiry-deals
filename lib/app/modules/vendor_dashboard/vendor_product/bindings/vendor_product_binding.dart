import 'package:get/get.dart';

import '../controllers/vendor_product_controller.dart';

class VendorProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VendorProductController>(
      () => VendorProductController(),
    );
  }
}
