import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:claude_app_demo/cubit/auth_cubit.dart';
import 'package:claude_app_demo/cubit/auth_state.dart';
import 'package:claude_app_demo/screens/register_screen.dart';

class MockAuthCubit extends MockCubit<AuthState> implements AuthCubit {}

Widget _buildSubject() {
  final cubit = MockAuthCubit();
  when(() => cubit.state).thenReturn(AuthInitial());
  when(() => cubit.stream).thenAnswer((_) => const Stream.empty());
  return MaterialApp(
    home: BlocProvider<AuthCubit>(
      create: (_) => cubit,
      child: const RegisterScreen(),
    ),
  );
}

void main() {
  group('RegisterScreen — new design', () {
    testWidgets('shows compass explore icon', (tester) async {
      await tester.pumpWidget(_buildSubject());
      expect(find.byIcon(Icons.explore), findsOneWidget);
    });

    testWidgets('shows Vietnam Travel heading', (tester) async {
      await tester.pumpWidget(_buildSubject());
      expect(find.text('Vietnam Travel'), findsOneWidget);
    });

    testWidgets('shows journey subtitle', (tester) async {
      await tester.pumpWidget(_buildSubject());
      expect(find.text('Bắt đầu hành trình của bạn'), findsOneWidget);
    });

    testWidgets('primary button text is Tao tai khoan', (tester) async {
      await tester.pumpWidget(_buildSubject());
      expect(find.text('Tạo tài khoản'), findsOneWidget);
    });

    testWidgets('uses shield icon for confirm password field', (tester) async {
      await tester.pumpWidget(_buildSubject());
      expect(find.byIcon(Icons.shield_outlined), findsOneWidget);
    });

    testWidgets('login link uses TextButton not ElevatedButton', (tester) async {
      await tester.pumpWidget(_buildSubject());
      final textButtons = tester.widgetList<TextButton>(find.byType(TextButton));
      expect(
        textButtons.any((b) {
          final child = b.child;
          return child is Text && child.data == 'Đăng nhập';
        }),
        isTrue,
      );
    });

    testWidgets('social buttons are icon-only (no Google/Facebook text)', (tester) async {
      await tester.pumpWidget(_buildSubject());
      expect(find.text('Google'), findsNothing);
      expect(find.text('Facebook'), findsNothing);
    });
  });
}
