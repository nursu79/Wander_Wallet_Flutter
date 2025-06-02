import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wander_wallet/core/di/providers.dart';
import 'package:wander_wallet/core/models/error.dart';
import 'package:wander_wallet/core/models/payload.dart';
import 'package:wander_wallet/core/models/result.dart';

sealed class TripDetailsScreenState {
  TripDetailsScreenState();
}

class TripDetailsLoading extends TripDetailsScreenState {
  TripDetailsLoading();
}

class TripDetailsSuccess extends TripDetailsScreenState {
  final TripPayload tripPayload;

  TripDetailsSuccess(this.tripPayload);
}

class TripDetailsDeleteSuccess extends TripDetailsScreenState {
  final MessagePayload messagePayload;

  TripDetailsDeleteSuccess(this.messagePayload);
}

class TripDetailsError extends TripDetailsScreenState {
  final MessageError error;
  final bool loggedOut;

  TripDetailsError(this.error, this.loggedOut);
}

class TripDetailsScreenNotifier extends AutoDisposeFamilyAsyncNotifier<TripDetailsScreenState, String> {

  TripDetailsScreenNotifier();
  @override
  Future<TripDetailsScreenState> build(String id) async {
    final tripsRepository = ref.read(tripsRepositoryProvider);
    state = AsyncValue.loading();
    final res = await tripsRepository.getTrip(arg);
    if (res is Success) {
      return TripDetailsSuccess((res as Success).data);
    } else {
      throw TripDetailsError((res as Error).error, (res as Error).loggedOut);
    }
  }

  Future<void> deleteTrip() async {
    final tripsRepository = ref.read(tripsRepositoryProvider);

    state = AsyncValue.loading();
    final res = await tripsRepository.deleteTrip(arg);
    if (res is Success) {
      state = AsyncValue.data(TripDetailsDeleteSuccess((res as Success).data));
    } else {
      state = AsyncValue.error(
          TripDetailsError((res as Error).error, (res as Error).loggedOut),
          StackTrace.current
      );
    }
  }

  Future<void> refresh() async {
    final tripsRepository = ref.read(tripsRepositoryProvider);

    state = AsyncValue.loading();
    final res = await tripsRepository.getTrip(arg);
    if (res is Success) {
      state =  AsyncValue.data(TripDetailsSuccess((res as Success).data));
    } else {
      state = AsyncValue.error(
          TripDetailsError((res as Error).error, (res as Error).loggedOut),
          StackTrace.current
      );
    }
  }
}

final tripDetailsProvider = AsyncNotifierProvider
    .family
    .autoDispose<TripDetailsScreenNotifier, TripDetailsScreenState, String>(
  TripDetailsScreenNotifier.new
);
