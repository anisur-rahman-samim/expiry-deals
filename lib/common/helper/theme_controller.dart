// lib/controllers/theme_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'local_store.dart';

class ThemeController extends GetxController {
  var isDarkMode = false.obs;
  final _darkModeKey = 'isDarkMode';

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = _loadThemeFromStorage();
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    _saveThemeToStorage(isDarkMode.value);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  bool _loadThemeFromStorage() {
    return LocalStorage.getData(key: _darkModeKey) ?? false;
  }

  void _saveThemeToStorage(bool isDarkMode) {
    LocalStorage.saveData(key: _darkModeKey, data: isDarkMode);
  }
}
