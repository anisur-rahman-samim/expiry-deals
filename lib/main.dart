import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/modules/favorites/controllers/favorites_controller.dart';
import 'common/helper/search_radius_miles.dart';
import 'app/routes/app_pages.dart';
import 'common/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await SearchRadiusMiles.migrateLegacyUnrealisticRadius();
  Get.put(FavoritesController(), permanent: true);
  runApp(
    GetMaterialApp(
      title: 'Expiry Deals',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 320),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
