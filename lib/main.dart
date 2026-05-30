import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/injection_container.dart' as di;
import 'core/di/injection_container.dart';
import 'services/notification_service.dart';
import 'core/routes/app_routes.dart';
import 'cubit/auth_cubit.dart';
import 'cubit/home_cubit.dart';
import 'screens/chat_screen.dart';
import 'screens/journey_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/register_screen.dart';
import 'screens/saved_screen.dart';
import 'screens/search_results_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/select_gender_screen.dart';
import 'screens/select_language_screen.dart';
import 'screens/setup_profile_screen.dart';
import 'screens/upload_avatar_screen.dart';
import 'screens/verify_email_screen.dart';
import 'widgets/app_bottom_nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  await sl<NotificationService>().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthCubit>()),
        BlocProvider(create: (_) => sl<HomeCubit>()),
      ],
      child: MaterialApp(
        title: 'Vietnam Explore',
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.splash,
        routes: {
          AppRoutes.splash: (_) => const SplashScreen(),
          AppRoutes.onboarding: (_) => const OnboardingScreen(),
          AppRoutes.login: (_) => const LoginScreen(),
          AppRoutes.register: (_) => const RegisterScreen(),
          AppRoutes.verifyEmail: (_) => const VerifyEmailScreen(),
          AppRoutes.setupProfile: (_) => const SetupProfileScreen(),
          AppRoutes.selectLanguage: (_) => const SelectLanguageScreen(),
          AppRoutes.uploadAvatar: (_) => const UploadAvatarScreen(),
          AppRoutes.selectGender: (_) => const SelectGenderScreen(),
          AppRoutes.searchResults: (_) => const SearchResultsScreen(),
          AppRoutes.home: (_) => const MainScreen(),
        },
      ),
    );
  }
}


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          HomeScreen(),
          ChatScreen(),
          JourneyScreen(),
          SavedScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}
