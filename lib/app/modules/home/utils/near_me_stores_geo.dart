import 'package:expiry_deals/app/modules/home/model/near_me_stores_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

extension NearMeStoresGeo on NearMeStores {
  /// GeoJSON Point uses [longitude, latitude].
  LatLng? get storeLatLng {
    final c = location?.coordinates;
    if (c == null || c.length < 2) return null;
    return LatLng(c[1], c[0]);
  }
}
