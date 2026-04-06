// controllers/dashboard_controller.dart
import 'package:get/get.dart';

class DashboardController extends GetxController {
  var currentIndex = 0.obs;

  /// Tabs that have been opened at least once. Home (0) is pre-seeded so only
  /// Home mounts on cold start; Browse/Cart/Profile build on first tap.
  final Set<int> visitedTabs = {0};

  void changePage(int index) {
    visitedTabs.add(index);
    currentIndex.value = index;
  }
}