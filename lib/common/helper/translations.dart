import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AppTranslations extends Translations {
  static Map<String, String> enUS = {};
  static Map<String, String> frFR = {};
  static Map<String, String> arAE = {};
  static Map<String, String> deDE = {};
  static Map<String, String> bnBD = {};
  static Map<String, String> ruRU = {};
  static Map<String, String> itIT = {};
  static Map<String, String> zhCN = {};
  static Map<String, String> esES = {};
  static Map<String, String> ptPT = {};
  static Map<String, String> koKR = {};
  static Map<String, String> jaJP = {};

  static Future<void> load() async {
    enUS = await loadTranslations('assets/langs/en_US.json');
    frFR = await loadTranslations('assets/langs/fr_FR.json');
    arAE = await loadTranslations('assets/langs/ar_AE.json');
    deDE = await loadTranslations('assets/langs/de_DE.json');
    bnBD = await loadTranslations('assets/langs/bn_BD.json');
    ruRU = await loadTranslations('assets/langs/ru_RU.json');
    itIT = await loadTranslations('assets/langs/it_IT.json');
    zhCN = await loadTranslations('assets/langs/zh_CN.json');
    esES = await loadTranslations('assets/langs/es_ES.json');
    ptPT = await loadTranslations('assets/langs/pt_PT.json');
    koKR = await loadTranslations('assets/langs/ko_KR.json');
    jaJP = await loadTranslations('assets/langs/ja_JP.json');
    // Add more languages here
  }

  static Future<Map<String, String>> loadTranslations(String path) async {
    try {
      final data = await rootBundle.loadString(path);
      if (data.isEmpty) {
        throw Exception("Empty JSON file: $path");
      }
      return Map<String, String>.from(jsonDecode(data));
    } catch (e) {
      print("Error loading translations from $path: $e");
      return {};
    }
  }

  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS,
    'fr_FR': frFR,
    'ar_AE': arAE,
    'de_DE': deDE,
    'bn_BD': bnBD,
    'ru_RU': ruRU,
    'it_IT': itIT,
    'zh_CN': zhCN,
    'es_ES': esES,
    'pt_PT': ptPT,
    'ko_KR': koKR,
    'ja_JP': jaJP,
    // Add more languages here
  };
}
