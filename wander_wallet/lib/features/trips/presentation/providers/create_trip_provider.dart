import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wander_wallet/core/di/providers.dart';
import 'package:wander_wallet/core/models/error.dart';
import 'package:wander_wallet/core/models/payload.dart';
import 'package:wander_wallet/core/models/result.dart';

sealed class CreateTripScreenState {
  CreateTripScreenState();
}

class CreateTripWaiting extends CreateTripScreenState {
  CreateTripWaiting();
}

class CreateTripLoading extends CreateTripScreenState {
  CreateTripLoading();
}

class CreateTripSuccess extends CreateTripScreenState {
  final TripPayload tripPayload;

  CreateTripSuccess(this.tripPayload);
}

class CreateTripError extends CreateTripScreenState {
  final TripError error;
  final bool loggedOut;

  CreateTripError(this.error, this.loggedOut);
}

class CreateTripScreenNotifier extends AsyncNotifier<CreateTripScreenState> {
  CreateTripScreenNotifier();

  @override
  Future<CreateTripScreenState> build() async {
    return CreateTripWaiting();
  }

  Future<void> createTrip(String name, String destination, num budget, DateTime startDate, DateTime endDate, File? tripImage) async {
    final tripsRepository = ref.read(tripsRepositoryProvider);
    state = AsyncValue.loading();
    final res = await tripsRepository.createTrip(name, destination, budget, startDate, endDate, tripImage);

    if (res is Success) {
      state = AsyncValue.data(CreateTripSuccess((res as Success).data));
    } else {
      state = AsyncValue.error(
        CreateTripError((res as Error).error, (res as Error).loggedOut),
        StackTrace.current,
      );
    }
  }
}

final createTripProvider = AsyncNotifierProvider<CreateTripScreenNotifier, CreateTripScreenState>(
  CreateTripScreenNotifier.new
);
