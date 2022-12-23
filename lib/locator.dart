import 'package:get_it/get_it.dart';
import 'package:thinkific_codetest/services/api_service.dart';
import 'package:thinkific_codetest/services/error_service.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  // SERVICES
  locator.registerLazySingleton(() => ApiService());
  locator.registerLazySingleton(() => ErrorService());

  await locator.allReady();
}
