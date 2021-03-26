
import 'package:get_it/get_it.dart';
import 'package:my_special_days/service/hive_local_db_service.dart';


GetIt getIt = GetIt.asNewInstance();

void setup() {
  getIt.registerLazySingleton(() => HiveLocalDbService());
}