import 'package:get_it/get_it.dart';
import 'package:scrumboard/api/scrum_card_datahandler.dart';
import 'package:scrumboard/api/scrum_card_datahandler_local.dart';

GetIt locator = GetIt.instance;

void setupLocator() async {
  locator.registerLazySingleton(() => ScrumCardDataHandler());
  locator.registerLazySingleton(() => ScrumCardLocalDataHandler());
}