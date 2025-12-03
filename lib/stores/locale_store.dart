import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'locale_store.g.dart';

class LocaleStore = _LocaleStore with _$LocaleStore;

abstract class _LocaleStore with Store {
  static const String _localeKey = 'app_locale';

  @observable
  Locale currentLocale = const Locale('mn'); // Default to Mongolian

  @action
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocaleCode = prefs.getString(_localeKey);

    if (savedLocaleCode != null) {
      currentLocale = Locale(savedLocaleCode);
    }
  }

  @action
  Future<void> changeLocale(Locale locale) async {
    currentLocale = locale;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }

  @action
  Future<void> toggleLocale() async {
    final newLocale = currentLocale.languageCode == 'mn'
        ? const Locale('en')
        : const Locale('mn');
    await changeLocale(newLocale);
  }

  @computed
  bool get isEnglish => currentLocale.languageCode == 'en';

  @computed
  bool get isMongolian => currentLocale.languageCode == 'mn';
}

final GetIt _localeGetIt = GetIt.instance;

LocaleStore get localeStore => _localeGetIt<LocaleStore>();
