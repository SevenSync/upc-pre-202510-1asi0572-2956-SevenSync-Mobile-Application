import 'package:get_it/get_it.dart';
import 'package:macetech_mobile_app/profiles_and_preferences/application/usecases/change_password_usecase.dart';
import 'package:macetech_mobile_app/profiles_and_preferences/application/usecases/delete_account_usecase.dart';
import 'package:macetech_mobile_app/profiles_and_preferences/application/usecases/get_profile_usecase.dart';
import 'package:macetech_mobile_app/profiles_and_preferences/application/usecases/sign_out_usecase.dart';
import 'package:macetech_mobile_app/profiles_and_preferences/application/usecases/update_profile_usecase.dart';
import 'package:macetech_mobile_app/profiles_and_preferences/domain/interfaces/profile_repository.dart';
import 'package:macetech_mobile_app/profiles_and_preferences/infrastructure/implementations/profile_repository_impl.dart';
import 'package:macetech_mobile_app/profiles_and_preferences/infrastructure/services/profile_api_service.dart';


final getIt = GetIt.instance;


void setupLocator() {

  getIt.registerLazySingleton(() => ProfileApiService());

  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(getIt<ProfileApiService>()),
  );

  getIt.registerLazySingleton(() => GetProfileUseCase(getIt<ProfileRepository>()));
  getIt.registerLazySingleton(() => SignOutUseCase(getIt<ProfileRepository>()));
  getIt.registerLazySingleton(() => DeleteAccountUseCase(getIt<ProfileRepository>()));
  getIt.registerLazySingleton(() => UpdateProfileUseCase(getIt<ProfileRepository>()));
  getIt.registerLazySingleton(() => ChangePasswordUseCase(getIt<ProfileRepository>()));
}