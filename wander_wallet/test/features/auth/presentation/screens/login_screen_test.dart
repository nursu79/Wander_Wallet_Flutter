import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:wander_wallet/core/models/error.dart';
import 'package:wander_wallet/core/models/payload.dart';
import 'package:wander_wallet/core/models/result.dart';
import 'package:wander_wallet/core/models/success.dart';
import 'package:wander_wallet/features/auth/domain/auth_repository.dart';
import 'package:wander_wallet/features/auth/presentation/providers/login_provider.dart';
import 'package:wander_wallet/features/auth/presentation/screens/login_screen.dart';

import './login_screen_test.mocks.dart';

@GenerateMocks([NavigatorObserver])
void main() {
  late MockNavigatorObserver mockObserver;
  final testUser = User(id: 'user123', username: 'testuser', email: 'test@example.com', role: 'USER', createdAt: DateTime.now(), updatedAt: DateTime.now());
  final testAccessToken = 'abc123';
  final testRefreshToken = 'def456';
  final testLoginPayload = LoginPayload(accessToken: testAccessToken, refreshToken: testRefreshToken, user: testUser);

  setUp(() {
    mockObserver = MockNavigatorObserver();
    when(mockObserver.navigator).thenReturn(null);
  });

  Future<void> pumpLoginScreen(
    WidgetTester tester,
    LoginScreenState state
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          loginProvider.overrideWith((ref) => FakeLoginState(state))
        ],
        child: MaterialApp(
          navigatorObservers: [mockObserver],
          routes: {
            '/signup': (context) {
              return const Scaffold(body: Text('Register'),);
            },
            '/user_dashboard': (context) => const Scaffold(body: Text('User Dashboard'),)
          },
          home: const LoginScreen(),
        ),
      )
    );
  }

  group('Login screen widget tests', () {
    testWidgets('navigates to register screen when button clicked', (tester) async {
      await pumpLoginScreen(tester, LoginWaiting());
      await tester.pumpAndSettle();
      final registerButton = find.text('Don\'t have an account? Sign Up');

      await tester.tap(registerButton);
      await tester.pumpAndSettle();
      expect(find.text('Register'), findsOneWidget);
    });

    testWidgets('navigates to user dashboard screen on successful login', (tester) async {
      await pumpLoginScreen(tester, LoginSuccess(testLoginPayload));
      await tester.pumpAndSettle();

      expect(find.text('User Dashboard'), findsOneWidget);
    });

    testWidgets('displays error on login attempt without email', (tester) async {
      await pumpLoginScreen(tester, LoginWaiting());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sign In'));
      await tester.pump();

      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });
  });
}

class FakeLoginState extends LoginState {
  FakeLoginState(LoginScreenState initialState)
      : super(FakeAuthRepository()) {
    state = initialState;
  }
}

class FakeAuthRepository implements AuthRepository {
  @override
  Future<Result<LoginPayload, UserError>> login(String email, String password) {
    // Just throw because you won't call it in these widget tests
    throw UnimplementedError();
  }

  @override
  Future<Result<UserPayload, MessageError>> getProfile() {
    // TODO: implement getProfile
    throw UnimplementedError();
  }

  @override
  Future<Result<UserPayload, UserError>> promoteToAdmin(String userId) {
    // TODO: implement promoteToAdmin
    throw UnimplementedError();
  }

  @override
  Future<Result<LoginPayload, UserError>> register(String username, String email, String password, File? avatar) {
    // TODO: implement register
    throw UnimplementedError();
  }

  // You can stub other methods too if needed
}
