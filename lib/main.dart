import 'package:claude_app_demo/core/network/dio_client.dart';
import 'package:claude_app_demo/cubit/auth_cubit.dart';
import 'package:claude_app_demo/cubit/home_cubit.dart';
import 'package:claude_app_demo/data/remote/auth_api.dart';
import 'package:claude_app_demo/screens/explore_screen.dart';
import 'package:claude_app_demo/screens/home_screen.dart';
import 'package:claude_app_demo/screens/login_screen.dart';
import 'package:claude_app_demo/screens/onboarding_screen.dart';
import 'package:claude_app_demo/screens/splash_screen.dart';
import 'package:claude_app_demo/screens/profile_screen.dart';
import 'package:claude_app_demo/screens/register_screen.dart';
import 'package:claude_app_demo/screens/saved_screen.dart';
import 'package:claude_app_demo/services/auth_service.dart';
import 'package:claude_app_demo/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/app_bottom_nav_bar.dart';

void main() {
  final dio = DioClient.create();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit(AuthService(AuthApi(dio)))),
        BlocProvider(create: (_) => HomeCubit(LocationService(dio))),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vietnam Explore',
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (_) => const SplashScreen(),
        '/onboarding': (_) => const OnboardingScreen(),
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/home': (_) => const MainScreen(),
      },
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
          ExploreScreen(),
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
