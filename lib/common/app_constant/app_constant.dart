class AppConstant {
  /// Same key as in `AndroidManifest.xml`, `AppDelegate.swift`, and `web/index.html`.
  /// Used for Places Autocomplete / Details from Dart. Enable **Places API** on this key.
  static const googleMapsApiKey =
      'AIzaSyD8GADkzFXVuxGPtVU4-6vjfXIkc-06gFY';

  ///user id
  static const userId = 'userId';
  static const token = 'token';
  static const teamId = 'teamId';
  static const role = 'role';
  static const email = 'email';
  static const roleApi = 'roleApi';
  static const signUpToken = 'signUpToken';
  static const forgotToken = 'forgotToken';
  static const otpToken = 'otpToken';
  static const fcmToken = 'fcmToken';
  static const onboarding = 'onboarding';

  /// Local list of favorited product ids (GetStorage).
  static const favoriteProductIds = 'favoriteProductIds';

  /// Miles — shop search radius (Near me, Browse, map). Synced with API `radiusMiles`.
  static const searchRadiusMiles = 'searchRadiusMiles';

  /// Browse tab: when true, list stores from all locations (no radius). When false, nearby only.
  static const browseEverywhereMode = 'browseEverywhereMode';

}