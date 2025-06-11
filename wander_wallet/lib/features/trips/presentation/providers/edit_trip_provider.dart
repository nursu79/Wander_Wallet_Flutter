import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wander_wallet/core/di/providers.dart';
import 'package:wander_wallet/core/models/error.dart';
import 'package:wander_wallet/core/models/payload.dart';
import 'package:wander_wallet/core/models/result.dart';

sealed class EditTripScreenState {
  EditTripScreenState();
}

class EditTripLoading extends EditTripScreenState {
  EditTripLoading();
}

class EditTripGetSuccess extends EditTripScreenState {
  final TripPayload tripPayload;

  EditTripGetSuccess(this.tripPayload);
}

class EditTripUpdateSuccess extends EditTripScreenState {
  final TripPayload tripPayload;

  EditTripUpdateSuccess(this.tripPayload);
}

class EditTripGetError extends EditTripScreenState {
  final MessageError error;
  final bool loggedOut;

  EditTripGetError(this.error, this.loggedOut);
}

class EditTripUpdateError extends EditTripScreenState {
  final TripError error;
  final bool loggedOut;

  EditTripUpdateError(this.error, this.loggedOut);
}

class EditTripScreenNotifier extends FamilyAsyncNotifier<EditTripScreenState, String> {
  EditTripScreenNotifier();

  @override
  Future<EditTripScreenState> build(String id) async {
    final tripsRepository = ref.read(tripsRepositoryProvider);
    state = AsyncValue.loading();
    final res = await tripsRepository.getTrip(arg);
    if (res is Success) {
      return EditTripGetSuccess((res as Success).data);
    } else {
      throw EditTripGetError((res as Error).error, (res as Error).loggedOut);
    }
  }

  Future<void> updateTrip(String name, String destination, num budget, DateTime startDate, DateTime endDate, File? tripImage) async {
    final tripsRepository = ref.read(tripsRepositoryProvider);
    state = AsyncValue.loading();
    final res = await tripsRepository.updateTrip(arg, name, destination, budget, startDate, endDate, tripImage);
    if (res is Success) {
      state = AsyncValue.data(EditTripUpdateSuccess((res as Success).data));
    } else {
      state = AsyncValue.error(
        EditTripUpdateError((res as Error).error, (res as Error).loggedOut),
        StackTrace.current,
      );
    }
  }
} 

final editTripProvider = AsyncNotifierProvider.family<EditTripScreenNotifier, EditTripScreenState, String>(
  EditTripScreenNotifier.new
);
