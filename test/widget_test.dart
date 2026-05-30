import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:claude_app_demo/cubit/auth_cubit.dart';
import 'package:claude_app_demo/cubit/home_cubit.dart';
import 'package:claude_app_demo/domain/usecases/auto_login_usecase.dart';
import 'package:claude_app_demo/domain/usecases/complete_profile_usecase.dart';
import 'package:claude_app_demo/domain/usecases/get_featured_locations_usecase.dart';
import 'package:claude_app_demo/domain/usecases/login_usecase.dart';
import 'package:claude_app_demo/domain/usecases/logout_usecase.dart';
import 'package:claude_app_demo/domain/usecases/register_usecase.dart';
import 'package:claude_app_demo/domain/usecases/social_login_usecase.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockRegisterUseCase extends Mock implements RegisterUseCase {}
class MockAutoLoginUseCase extends Mock implements AutoLoginUseCase {}
class MockLogoutUseCase extends Mock implements LogoutUseCase {}
class MockSocialLoginUseCase extends Mock implements SocialLoginUseCase {}
class MockCompleteProfileUseCase extends Mock implements CompleteProfileUseCase {}
class MockGetFeaturedLocationsUseCase extends Mock
    implements GetFeaturedLocationsUseCase {}

void main() {
  testWidgets('App smoke test — BlocProviders mount without error', (WidgetTester tester) async {
    final autoLogin = MockAutoLoginUseCase();
    when(() => autoLogin()).thenAnswer((_) async => null);

    final locations = MockGetFeaturedLocationsUseCase();
    when(() => locations(region: any(named: 'region')))
        .thenAnswer((_) async => []);

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthCubit(
              loginUseCase: MockLoginUseCase(),
              registerUseCase: MockRegisterUseCase(),
              autoLoginUseCase: autoLogin,
              logoutUseCase: MockLogoutUseCase(),
              socialLoginUseCase: MockSocialLoginUseCase(),
              completeProfileUseCase: MockCompleteProfileUseCase(),
            ),
          ),
          BlocProvider(create: (_) => HomeCubit(locations)),
        ],
        child: const MaterialApp(
          home: Scaffold(body: SizedBox.shrink()),
        ),
      ),
    );
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
