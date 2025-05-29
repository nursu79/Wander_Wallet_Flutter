import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wander_wallet/core/di/providers.dart';
import 'package:wander_wallet/core/models/error.dart';
import 'package:wander_wallet/core/models/payload.dart';
import 'package:wander_wallet/core/models/result.dart';
import 'package:wander_wallet/features/trips/domain/trips_repository.dart';

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

class TripDetailsScreenNotifier extends FamilyAsyncNotifier<TripDetailsScreenState, String> {
  late final TripsRepository tripsRepository;

  TripDetailsScreenNotifier();
  @override
  Future<TripDetailsScreenState> build(String id) async {
    tripsRepository = ref.read(tripsRepositoryProvider);
    state = AsyncValue.loading();
    final res = await tripsRepository.getTrip(arg);
    if (res is Success) {
      return TripDetailsSuccess((res as Success).data);
    } else {
      return TripDetailsError((res as Error).error, (res as Error).loggedOut);
    }
  }

  Future<void> deleteTrip() async {
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
    .family<TripDetailsScreenNotifier, TripDetailsScreenState, String>(
  TripDetailsScreenNotifier.new
);
