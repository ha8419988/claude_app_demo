import 'package:flutter_test/flutter_test.dart';
import 'package:claude_app_demo/models/user.dart';

void main() {
  group('User', () {
    const json = {'id': '1', 'name': 'Test User', 'email': 'test@test.com'};

    test('fromJson parses correctly', () {
      final user = User.fromJson(json);
      expect(user.id, '1');
      expect(user.name, 'Test User');
      expect(user.email, 'test@test.com');
    });

    test('toJson returns correct map', () {
      const user = User(id: '1', name: 'Test User', email: 'test@test.com');
      expect(user.toJson(), json);
    });
  });
}
