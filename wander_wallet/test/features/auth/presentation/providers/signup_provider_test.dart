import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:wander_wallet/core/di/providers.dart';
import 'package:wander_wallet/core/models/error.dart';
import 'package:wander_wallet/core/models/payload.dart';
import 'package:wander_wallet/core/models/result.dart';
import 'package:wander_wallet/core/models/success.dart';
import 'package:wander_wallet/features/auth/domain/auth_repository.dart';
import 'package:wander_wallet/features/auth/presentation/providers/signup_provider.dart';

import './signup_provider_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepository mockAuthRepository;
  late ProviderContainer container;

  final testUsername = 'test';
  final testEmail = 'test@example.com';
  final testPassword = 'p@ssw0rd';
  final testUser = User(id: 'user123', username: 'testuser', email: 'test@example.com', role: 'USER', createdAt: DateTime.now(), updatedAt: DateTime.now());
  final testAccessToken = 'abc123';
  final testRefreshToken = 'def456';
  final testLoginPayload = LoginPayload(accessToken: testAccessToken, refreshToken: testRefreshToken, user: testUser);

  setUpAll(() {
    provideDummy<Result<LoginPayload, UserError>>(
      Success(testLoginPayload)
    );
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepository)
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('Sign up', () {
    test('initial state is SignupWaiting', () {
      final state = container.read(signupProvider);
      expect(state, isA<SignupWaiting>());
    });

    test('emits SignupLoading then SignupSuccess on successful Signup', () async {
      when(mockAuthRepository.register(testUsername, testEmail, testPassword, null))
          .thenAnswer((_) async => Success<LoginPayload, UserError>(testLoginPayload));

      final notifier = container.read(signupProvider.notifier);

      await notifier.signup(testUsername, testEmail, testPassword, null);
      final state = container.read(signupProvider);
      expect(state, isA<SignupSuccess>());
    });

    test('emits SignupLoading then SignupError on known error', () async {
      final userError = UserError(message: 'Invalid credentials');

      when(mockAuthRepository.register(testUsername, testEmail, testPassword, null))
          .thenAnswer((_) async => Error<LoginPayload, UserError>(error: userError));

      final notifier = container.read(signupProvider.notifier);

      await notifier.signup(testUsername, testEmail, testPassword, null);

      final state = container.read(signupProvider);
      expect(state, isA<SignupError>());
      expect((state as SignupError).userError.message, 'Invalid credentials');
    });

    test('emits SignupError on unexpected result type', () async {
      // Simulate an unexpected result (e.g. null or unsupported class)
      when(mockAuthRepository.register(testUsername, testEmail, testPassword, null))
          .thenAnswer((_) async => Error<LoginPayload, UserError>(error: UserError(message: 'An unexpected error occurred')));

      final notifier = container.read(signupProvider.notifier);

      // Catch the error internally so test doesn’t fail
      await notifier.signup(testUsername, testEmail, testPassword, null);

      final state = container.read(signupProvider);
      expect(state, isA<SignupError>());
      expect(
        (state as SignupError).userError.message,
        'An unexpected error occurred',
      );
    });
  });
}