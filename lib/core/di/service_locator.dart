import 'package:get_it/get_it.dart';
import 'package:oncall_lab/data/repositories/auth_repository.dart';
import 'package:oncall_lab/data/repositories/doctor_repository.dart';
import 'package:oncall_lab/data/repositories/laboratory_repository.dart';
import 'package:oncall_lab/data/repositories/service_repository.dart';
import 'package:oncall_lab/data/repositories/test_request_repository.dart';
import 'package:oncall_lab/stores/auth_store.dart';
import 'package:oncall_lab/stores/doctor_request_store.dart';
import 'package:oncall_lab/stores/home_store.dart';
import 'package:oncall_lab/stores/locale_store.dart';
import 'package:oncall_lab/stores/service_store.dart';
import 'package:oncall_lab/stores/test_request_store.dart';

final GetIt locator = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Repositories
  locator.registerLazySingleton<AuthRepository>(() => AuthRepository());
  locator.registerLazySingleton<ServiceRepository>(() => ServiceRepository());
  locator.registerLazySingleton<TestRequestRepository>(
    () => TestRequestRepository(),
  );
  locator.registerLazySingleton<DoctorRepository>(() => DoctorRepository());
  locator.registerLazySingleton<LaboratoryRepository>(
    () => LaboratoryRepository(),
  );

  // Stores
  locator.registerLazySingleton<LocaleStore>(() => LocaleStore());
  locator.registerLazySingleton<AuthStore>(
    () => AuthStore(locator<AuthRepository>()),
  );
  locator.registerLazySingleton<HomeStore>(
    () => HomeStore(
      locator<ServiceRepository>(),
      locator<DoctorRepository>(),
    ),
  );
  locator.registerLazySingleton<ServiceStore>(
    () => ServiceStore(locator<ServiceRepository>()),
  );
  locator.registerLazySingleton<TestRequestStore>(
    () => TestRequestStore(locator<TestRequestRepository>()),
  );
  locator.registerLazySingleton<DoctorRequestStore>(
    () => DoctorRequestStore(locator<TestRequestRepository>()),
  );
}
