import 'package:get_it/get_it.dart';
import 'package:bugamed/data/repositories/auth_repository.dart';
import 'package:bugamed/data/repositories/doctor_repository.dart';
import 'package:bugamed/data/repositories/laboratory_repository.dart';
import 'package:bugamed/data/repositories/service_repository.dart';
import 'package:bugamed/data/repositories/test_request_repository.dart';
import 'package:bugamed/data/repositories/notification_repository.dart';
import 'package:bugamed/data/repositories/payment_repository.dart';
import 'package:bugamed/stores/auth_store.dart';
import 'package:bugamed/stores/doctor_request_store.dart';
import 'package:bugamed/stores/home_store.dart';
import 'package:bugamed/stores/locale_store.dart';
import 'package:bugamed/stores/service_store.dart';
import 'package:bugamed/stores/test_request_store.dart';
import 'package:bugamed/stores/notification_store.dart';
import 'package:bugamed/stores/payment_store.dart';
import 'package:bugamed/core/services/push_notification_service.dart';
import 'package:bugamed/core/services/qpay_service.dart';

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
  locator.registerLazySingleton<NotificationRepository>(
    () => NotificationRepository(),
  );
  locator.registerLazySingleton<PaymentRepository>(
    () => PaymentRepository(),
  );

  // Services
  locator.registerLazySingleton<PushNotificationService>(
    () => PushNotificationService(),
  );
  locator.registerLazySingleton<QPayService>(
    () => QPayService(),
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
  locator.registerLazySingleton<NotificationStore>(
    () => NotificationStore(
      locator<NotificationRepository>(),
      locator<PushNotificationService>(),
    ),
  );
  locator.registerLazySingleton<PaymentStore>(
    () => PaymentStore(
      locator<QPayService>(),
      locator<PaymentRepository>(),
    ),
  );
}
