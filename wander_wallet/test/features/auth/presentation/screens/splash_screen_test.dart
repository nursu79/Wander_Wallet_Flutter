import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:wander_wallet/core/models/error.dart';
import 'package:wander_wallet/core/models/payload.dart';
import 'package:wander_wallet/core/models/success.dart';
import 'package:wander_wallet/features/auth/presentation/providers/splash_provider.dart';
import 'package:wander_wallet/features/auth/presentation/screens/splash_screen.dart';
import './splash_screen_test.mocks.dart';

@GenerateMocks([NavigatorObserver])
void main() {
  late MockNavigatorObserver mockObserver;
  final testUser = User(id: 'user123', username: 'testuser', email: 'test@example.com', role: 'USER', createdAt: DateTime.now(), updatedAt: DateTime.now());
  final testUserPayload = UserPayload(user: testUser);

  setUp(() {
    mockObserver = MockNavigatorObserver();
    when(mockObserver.navigator).thenReturn(null);
  });

  Future<void> pumpSplashScreen(
    WidgetTester tester,
    AsyncValue<SplashState> splashState
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          splashProvider.overrideWith(() => FakeSplashNotifier(
            splashState
          ))
        ],
        child: MaterialApp(
          navigatorObservers: [mockObserver],
          routes: {
            '/welcome': (context) => const Scaffold(body: Text('Welcome')),
            '/user_dashboard': (context) {
              return Scaffold(body: Text('User Dashboard'));
            },
            '/admin_dashboard': (context) => const Scaffold(body: Text('Admin Dashboard')),
          },
          home: const SplashScreen(),
        ),
      )
    );
  }

  group('Splash screen widget tests', () {
    testWidgets('navigates to user dashboard if authenticated user', (tester) async {
      final splashState = AsyncValue.data(
        SplashSuccess(testUserPayload)
      );

      await pumpSplashScreen(tester, splashState);
      await tester.pumpAndSettle();

      expect(find.text('User Dashboard'), findsOneWidget);
    });

    testWidgets('navigates to welcome screen if not authenticated', (tester) async {
      final splashState = AsyncValue<SplashState>.error(
        SplashError(MessageError(message: ""), true),
        StackTrace.current
      );

      await pumpSplashScreen(tester, splashState);
      await tester.pumpAndSettle();

      expect(find.text('Welcome'), findsOneWidget);
    });

    testWidgets('displays retry button on error', (tester) async {
      final splashState = AsyncValue<SplashState>.error(
        SplashError(MessageError(message: ""), false),
        StackTrace.current
      );

      await pumpSplashScreen(tester, splashState);
      await tester.pumpAndSettle();
      await tester.pump();

      expect(find.text('Retry'), findsOneWidget);
    });
  });
}

class FakeSplashNotifier extends SplashNotifier {
  final AsyncValue<SplashState> splashValue;

  FakeSplashNotifier(this.splashValue);

  @override
  Future<SplashState> build() async {
    state = splashValue;
    return splashValue.value!;
  }
}
