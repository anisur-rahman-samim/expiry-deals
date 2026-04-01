import 'dart:convert';

import 'package:expiry_deals/common/app_constant/app_constant.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

/// Suggestion row from Places Autocomplete.
class PlaceSuggestion {
  PlaceSuggestion({required this.description, required this.placeId});

  final String description;
  final String placeId;
}

/// Calls Google Places REST APIs (Autocomplete + Place Details).
///
/// Enable in Google Cloud Console for your key:
/// - Places API
/// - (Optional) Geocoding API if you use server geocoding elsewhere
///
/// The key must match the one in AndroidManifest / AppDelegate / web/index.html.
class GooglePlacesClient {
  GooglePlacesClient._();

  static const _autocompleteUrl =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json';
  static const _detailsUrl =
      'https://maps.googleapis.com/maps/api/place/details/json';

  static String get _key => AppConstant.googleMapsApiKey;

  /// Returns up to [limit] address suggestions for [input].
  static Future<List<PlaceSuggestion>> autocomplete({
    required String input,
    int limit = 8,
  }) async {
    final q = input.trim();
    if (q.length < 2) return [];

    // Omit `types` so users can match street addresses, businesses, POIs, etc.
    final uri = Uri.parse(_autocompleteUrl).replace(queryParameters: {
      'input': q,
      'key': _key,
    });

    final res = await http.get(uri);
    if (res.statusCode != 200) {
      debugPrint('Places autocomplete HTTP ${res.statusCode}');
      return [];
    }

    final map = jsonDecode(res.body) as Map<String, dynamic>?;
    final status = map?['status'] as String?;
    if (status != 'OK' && status != 'ZERO_RESULTS') {
      debugPrint('Places autocomplete status: $status body: ${res.body}');
      return [];
    }

    final preds = map?['predictions'] as List<dynamic>? ?? [];
    final out = <PlaceSuggestion>[];
    for (final p in preds) {
      if (p is! Map<String, dynamic>) continue;
      final desc = p['description'] as String?;
      final id = p['place_id'] as String?;
      if (desc == null || id == null) continue;
      out.add(PlaceSuggestion(description: desc, placeId: id));
      if (out.length >= limit) break;
    }
    return out;
  }

  /// Resolves [placeId] to a coordinate (and formatted address if available).
  static Future<({LatLng latLng, String? formattedAddress})?> placeDetails({
    required String placeId,
  }) async {
    final uri = Uri.parse(_detailsUrl).replace(queryParameters: {
      'place_id': placeId,
      'fields': 'geometry,formatted_address',
      'key': _key,
    });

    final res = await http.get(uri);
    if (res.statusCode != 200) return null;

    final map = jsonDecode(res.body) as Map<String, dynamic>?;
    final status = map?['status'] as String?;
    if (status != 'OK') {
      debugPrint('Place details status: $status');
      return null;
    }

    final result = map?['result'] as Map<String, dynamic>?;
    final geom = result?['geometry'] as Map<String, dynamic>?;
    final loc = geom?['location'] as Map<String, dynamic>?;
    final lat = (loc?['lat'] as num?)?.toDouble();
    final lng = (loc?['lng'] as num?)?.toDouble();
    if (lat == null || lng == null) return null;

    final formatted = result?['formatted_address'] as String?;
    return (latLng: LatLng(lat, lng), formattedAddress: formatted);
  }
}
