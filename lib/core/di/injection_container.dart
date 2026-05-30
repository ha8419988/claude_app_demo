import 'package:get_it/get_it.dart';

import '../../cubit/auth_cubit.dart';
import '../../cubit/chat_cubit.dart';
import '../../cubit/home_cubit.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/chat_remote_datasource.dart';
import '../../data/datasources/location_remote_datasource.dart';
import '../../data/remote/auth_api.dart';
import '../../data/remote/chat_api.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../data/repositories/location_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/usecases/auto_login_usecase.dart';
import '../../domain/usecases/complete_profile_usecase.dart';
import '../../domain/usecases/get_featured_locations_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/social_login_usecase.dart';
import '../network/dio_client.dart';
import '../../services/notification_service.dart';
import '../../services/pusher_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ── Core ──────────────────────────────────────────────
  sl.registerLazySingleton(() => DioClient.create());
  sl.registerLazySingleton(() => PusherService());
  sl.registerLazySingleton(() => NotificationService());

  // ── Data Sources ─────────────────────────────────────
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(AuthApi(sl())),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<LocationRemoteDataSource>(
    () => LocationRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(ChatApi(sl()), sl(), sl()),
  );

  // ── Repositories ──────────────────────────────────────
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remote: sl(), local: sl()),
  );
  sl.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(sl()),
  );

  // ── Use Cases ─────────────────────────────────────────
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => AutoLoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => SocialLoginUseCase(sl()));
  sl.registerLazySingleton(() => CompleteProfileUseCase(sl()));
  sl.registerLazySingleton(() => GetFeaturedLocationsUseCase(sl()));

  // ── Cubits ────────────────────────────────────────────
  sl.registerFactory(() => ChatCubit(sl(), sl(), sl()));
  sl.registerFactory(() => AuthCubit(
        loginUseCase: sl(),
        registerUseCase: sl(),
        autoLoginUseCase: sl(),
        logoutUseCase: sl(),
        socialLoginUseCase: sl(),
        completeProfileUseCase: sl(),
      ));
  sl.registerFactory(() => HomeCubit(sl()));
}
