
import 'package:get_it/get_it.dart';
import 'package:wirtz/models/model.dart';
import 'package:wirtz/services/api.dart';


GetIt locator = GetIt();

void setupLocator() {
  locator.registerLazySingleton(() => Api('markers'));
  locator.registerLazySingleton(() => Model()) ;
}