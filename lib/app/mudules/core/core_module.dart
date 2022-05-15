import 'package:cuidapet_mobile/app/core/local_storage/flutter_secure_storage/local_storage_flutter_secure_storage_impl.dart';
import 'package:cuidapet_mobile/app/core/local_storage/local_storage.dart';
import 'package:cuidapet_mobile/app/core/local_storage/shered_preferences/shered_preferences_local_storage_impl.dart';
import 'package:cuidapet_mobile/app/core/logger/app_logger.dart';
import 'package:cuidapet_mobile/app/core/logger/logger_app_logger_impl.dart';
import 'package:cuidapet_mobile/app/core/rest_client/dio/dio_rest_client.dart';
import 'package:cuidapet_mobile/app/core/rest_client/rest_client.dart';

import 'package:cuidapet_mobile/app/mudules/core/auth/auth_store.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CoreModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton<AppLogger>((i) => LoggerAppLoggerImpl(), export: true),
    Bind.lazySingleton<LocalStorage>((i) => SheredPreferencesLocalStorageImpl(),
        export: true),
    Bind.lazySingleton<LocalSecureStorage>(
        (i) => LocalStorageFlutterSecureStorageImpl(),
        export: true),
    Bind.lazySingleton(
        (i) => AuthStore(
              localStorage: i(),
            ),
        export: true),
    Bind.lazySingleton<RestClient>(
        (i) => DioRestClient(
              localStorage: i(),
              log: i(),
              authStore: i(),
            ),
        export: true),
  ];
}
