import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:claude_app_demo/cubit/auth_cubit.dart';
import 'package:claude_app_demo/main.dart';
import 'package:claude_app_demo/services/auth_service.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  testWidgets('App smoke test — renders without crashing', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final mockService = MockAuthService();
    when(() => mockService.getSavedSession()).thenAnswer((_) async => null);
    await tester.pumpWidget(
      BlocProvider(
        create: (_) => AuthCubit(mockService),
        child: const MyApp(),
      ),
    );
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
