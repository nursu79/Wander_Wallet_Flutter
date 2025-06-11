import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wander_wallet/core/di/providers.dart';
import 'package:wander_wallet/core/models/error.dart';
import 'package:wander_wallet/core/models/misc.dart';
import 'package:wander_wallet/core/models/payload.dart';
import 'package:wander_wallet/core/models/result.dart';

sealed class TripsScreenState {
  TripsScreenState();
}

class TripsLoading extends TripsScreenState {
  TripsLoading();
}

class TripsSuccess extends TripsScreenState {
  final TripsPayload trips;

  TripsSuccess(this.trips);
}

class TripsError extends TripsScreenState {
  final MessageError messageError;
  final bool loggedOut;

  TripsError(this.messageError, this.loggedOut);
}

class TripsScreenNotifier extends AsyncNotifier<TripsScreenState> {
  TripsScreenNotifier();
  @override
  Future<TripsScreenState> build() async {
    final tripsRepository = ref.read(tripsRepositoryProvider);
    state = AsyncValue.loading();
    final res = await tripsRepository.getCurrentTrips();

    if (res is Success) {
      return TripsSuccess((res as Success).data);
    } else {
      throw TripsError((res as Error).error, (res as Error).loggedOut);
    }
  }

  Future<void> getTrips(TabType currentTab) async {
    final tripsRepository = ref.read(tripsRepositoryProvider);
    state = const AsyncValue.loading();
    Result res;

    switch (currentTab) {
      case TabType.past:
        res = await tripsRepository.getPastTrips();
      case TabType.current:
        res = await tripsRepository.getCurrentTrips();
      case TabType.pending:
        res = await tripsRepository.getPendingTrips();
    }

    if (res is Success) {
      state = AsyncValue.data(TripsSuccess(res.data));
    } else {
      state = AsyncValue.error(
        TripsError((res as Error).error, res.loggedOut),
        StackTrace.current,
      );
    }
  }
}

final tripsProvider = AsyncNotifierProvider<TripsScreenNotifier, TripsScreenState>(
  TripsScreenNotifier.new
);
