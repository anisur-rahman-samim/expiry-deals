import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:expiry_deals/common/helper/local_store.dart';

/// Client-side favorites (no server sync). Persists with [LocalStorage].
class FavoritesService {
  FavoritesService._();

  static List<String> loadIds() {
    final v = LocalStorage.getData(key: AppConstant.favoriteProductIds);
    if (v is List) {
      return v.map((e) => e.toString()).where((s) => s.isNotEmpty).toList();
    }
    return [];
  }

  static Future<void> saveIds(List<String> ids) async {
    await LocalStorage.saveData(
      key: AppConstant.favoriteProductIds,
      data: ids,
    );
  }

  static Future<void> toggle(String productId) async {
    if (productId.isEmpty) return;
    final ids = List<String>.from(loadIds());
    if (ids.contains(productId)) {
      ids.remove(productId);
    } else {
      ids.add(productId);
    }
    await saveIds(ids);
  }

  static bool contains(String productId) =>
      productId.isNotEmpty && loadIds().contains(productId);
}
