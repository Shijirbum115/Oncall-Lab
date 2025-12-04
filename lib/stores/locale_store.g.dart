// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LocaleStore on _LocaleStore, Store {
  Computed<bool>? _$isEnglishComputed;

  @override
  bool get isEnglish => (_$isEnglishComputed ??=
          Computed<bool>(() => super.isEnglish, name: '_LocaleStore.isEnglish'))
      .value;
  Computed<bool>? _$isMongolianComputed;

  @override
  bool get isMongolian =>
      (_$isMongolianComputed ??= Computed<bool>(() => super.isMongolian,
              name: '_LocaleStore.isMongolian'))
          .value;

  late final _$currentLocaleAtom =
      Atom(name: '_LocaleStore.currentLocale', context: context);

  @override
  Locale get currentLocale {
    _$currentLocaleAtom.reportRead();
    return super.currentLocale;
  }

  @override
  set currentLocale(Locale value) {
    _$currentLocaleAtom.reportWrite(value, super.currentLocale, () {
      super.currentLocale = value;
    });
  }

  late final _$initializeAsyncAction =
      AsyncAction('_LocaleStore.initialize', context: context);

  @override
  Future<void> initialize() {
    return _$initializeAsyncAction.run(() => super.initialize());
  }

  late final _$changeLocaleAsyncAction =
      AsyncAction('_LocaleStore.changeLocale', context: context);

  @override
  Future<void> changeLocale(Locale locale) {
    return _$changeLocaleAsyncAction.run(() => super.changeLocale(locale));
  }

  late final _$toggleLocaleAsyncAction =
      AsyncAction('_LocaleStore.toggleLocale', context: context);

  @override
  Future<void> toggleLocale() {
    return _$toggleLocaleAsyncAction.run(() => super.toggleLocale());
  }

  @override
  String toString() {
    return '''
currentLocale: ${currentLocale},
isEnglish: ${isEnglish},
isMongolian: ${isMongolian}
    ''';
  }
}
