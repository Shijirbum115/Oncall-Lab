// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeStore on _HomeStore, Store {
  late final _$testTypesAtom =
      Atom(name: '_HomeStore.testTypes', context: context);

  @override
  ObservableList<Map<String, dynamic>> get testTypes {
    _$testTypesAtom.reportRead();
    return super.testTypes;
  }

  @override
  set testTypes(ObservableList<Map<String, dynamic>> value) {
    _$testTypesAtom.reportWrite(value, super.testTypes, () {
      super.testTypes = value;
    });
  }

  late final _$availableDoctorsAtom =
      Atom(name: '_HomeStore.availableDoctors', context: context);

  @override
  ObservableList<Map<String, dynamic>> get availableDoctors {
    _$availableDoctorsAtom.reportRead();
    return super.availableDoctors;
  }

  @override
  set availableDoctors(ObservableList<Map<String, dynamic>> value) {
    _$availableDoctorsAtom.reportWrite(value, super.availableDoctors, () {
      super.availableDoctors = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_HomeStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: '_HomeStore.errorMessage', context: context);

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$loadHomeDataAsyncAction =
      AsyncAction('_HomeStore.loadHomeData', context: context);

  @override
  Future<void> loadHomeData() {
    return _$loadHomeDataAsyncAction.run(() => super.loadHomeData());
  }

  @override
  String toString() {
    return '''
testTypes: ${testTypes},
availableDoctors: ${availableDoctors},
isLoading: ${isLoading},
errorMessage: ${errorMessage}
    ''';
  }
}
