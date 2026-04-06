import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:expiry_deals/common/helper/local_store.dart';

/// User preference: how far from the current location to search for shops (miles).
/// Used for Home "Near me", Browse, and map — matches backend `radiusMiles` query param.
class SearchRadiusMiles {
  SearchRadiusMiles._();

  /// Local marketplace default (~10–15 mi); users can raise in settings.
  static const double defaultMiles = 12;

  /// One-time cap: stored radii above this (e.g. accidental 300+ mi) reset to [defaultMiles].
  static const double _legacyAbsurdMilesThreshold = 100;

  /// Call after storage init (e.g. from `main`). Safe to call every launch.
  static Future<void> migrateLegacyUnrealisticRadius() async {
    final v = LocalStorage.getData(key: AppConstant.searchRadiusMiles);
    double? parsed;
    if (v is num) {
      parsed = v.toDouble();
    } else if (v is String) {
      parsed = double.tryParse(v);
    }
    if (parsed == null) return;
    if (parsed > _legacyAbsurdMilesThreshold) {
      await set(defaultMiles);
    }
  }
  static const double minMiles = 1;
  /// Upper bound for search radius (miles). Kept in sync with API clamp.
  static const double maxMiles = 500;

  static double get() {
    final v = LocalStorage.getData(key: AppConstant.searchRadiusMiles);
    if (v is num) {
      return v.toDouble().clamp(minMiles, maxMiles);
    }
    if (v is String) {
      final parsed = double.tryParse(v);
      if (parsed != null) return parsed.clamp(minMiles, maxMiles);
    }
    return defaultMiles;
  }

  static Future<void> set(double miles) async {
    final clamped = miles.clamp(minMiles, maxMiles);
    await LocalStorage.saveData(
      key: AppConstant.searchRadiusMiles,
      data: clamped,
    );
  }
}
