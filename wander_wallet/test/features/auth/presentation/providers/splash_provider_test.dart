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
import 'package:wander_wallet/features/auth/presentation/providers/splash_provider.dart';

import 'splash_provider_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late ProviderContainer container;
  late MockAuthRepository mockAuthRepository;
  late SplashNotifier notifier;

  final testUser = User(id: 'user123', username: 'testuser', email: 'test@example.com', role: 'USER', createdAt: DateTime.now(), updatedAt: DateTime.now());
  final testUserPayload = UserPayload(user: testUser);
  final testMessageError = MessageError(message: 'Test error');

  setUpAll(() {
    provideDummy<Result<UserPayload, MessageError>>(
      Success(testUserPayload)
    );
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
      ],
    );
    notifier = container.read(splashProvider.notifier);
  });

  tearDown(() {
    container.dispose();
  });

  group('build', () {
    test('should return SplashSuccess when getProfile succeeds', () async {
      // Arrange
      when(mockAuthRepository.getProfile()).thenAnswer(
        (_) async => Success(testUserPayload),
      );

      // Act
      final result = await notifier.build();

      // Assert
      expect(result, isA<SplashSuccess>());
      expect((result as SplashSuccess).userPayload, testUserPayload);
      expect(result.isAuthenticated, isTrue);
    });

    test('should throw SplashError when getProfile fails', () async {
      // Arrange
      when(mockAuthRepository.getProfile()).thenAnswer(
        (_) async => Error(error: testMessageError, loggedOut: true),
      );

      // Act & Assert
      expect(
        notifier.build(),
        throwsA(isA<SplashError>()),
      );
    });
  });

  group('refresh', () {
    test('should update state to SplashSuccess when refresh succeeds', () async {
      // Arrange
      when(mockAuthRepository.getProfile()).thenAnswer(
        (_) async => Success(testUserPayload),
      );

      // Act
      await notifier.refresh();

      // Assert
      expect(notifier.state.value, isA<SplashSuccess>());
      expect((notifier.state.value as SplashSuccess).userPayload, testUserPayload);

      // getProfile called first on build then on refresh
      verify(mockAuthRepository.getProfile()).called(2);
    });

    test('should update state to error with SplashError when refresh fails', () async {
      // Arrange
      when(mockAuthRepository.getProfile()).thenAnswer(
        (_) async => Error(error: testMessageError, loggedOut: false),
      );

      // Act
      await notifier.refresh();

      // Assert
      expect(notifier.state.hasError, isTrue);
      expect(notifier.state.error, isA<SplashError>());
      final error = notifier.state.error as SplashError;
      expect(error.messageError, testMessageError);
      expect(error.loggedOut, isFalse);
    });

    test('should set loading state before refreshing', () async {
      // Arrange
      when(mockAuthRepository.getProfile()).thenAnswer(
        (_) async => Success(testUserPayload),
      );

      // Track state changes
      final states = <AsyncValue<SplashState>>[];
      final sub = container.listen(splashProvider, (_, state) => states.add(state));

      // Act
      await notifier.refresh();

      // Assert
      expect(states.length, 2);
      expect(states[0].isLoading, isTrue);
      expect(states[1].hasValue, isTrue);
      sub.close();
    });
  });

  group('splashProvider', () {
    test('should provide SplashNotifier', () {
      final providerNotifier = container.read(splashProvider.notifier);
      expect(providerNotifier, isA<SplashNotifier>());
    });
  });
}