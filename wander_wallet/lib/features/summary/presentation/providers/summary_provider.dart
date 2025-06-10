import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wander_wallet/core/di/providers.dart';
import 'package:wander_wallet/core/models/error.dart';
import 'package:wander_wallet/core/models/result.dart';
import 'package:wander_wallet/core/models/success.dart';

sealed class SummaryScreenState {
  SummaryScreenState();
}

class SummarySuccess extends SummaryScreenState {
  final AllStats allStats;

  SummarySuccess(this.allStats);
}

class SummaryError extends SummaryScreenState {
  final MessageError messageError;
  final bool loggedOut;

  SummaryError(this.messageError, this.loggedOut);
}

class SummaryScreenNotifier extends AsyncNotifier<SummaryScreenState> {
  @override
  Future<SummaryScreenState> build() async {
    final summaryRepository = ref.read(summaryRepositoryProvider);
    state = AsyncValue.loading();
    final res = await summaryRepository.getAllStats();

    if (res is Success<AllStats, MessageError>) {
      return SummarySuccess(res.data);
    } else {
      throw SummaryError((res as Error).error, (res as Error).loggedOut);
    }
  }

  Future<void> refresh() async {
    final summaryRepository = ref.read(summaryRepositoryProvider);
    state = AsyncValue.loading();
    final res = await summaryRepository.getAllStats();

    if (res is Success<AllStats, MessageError>) {
      state = AsyncValue.data(SummarySuccess(res.data));
    } else {
      state = AsyncValue.error(
        SummaryError((res as Error).error, (res as Error).loggedOut),
        StackTrace.current
      );
    }
  }
}

final summaryProvider = AsyncNotifierProvider<SummaryScreenNotifier, SummaryScreenState>(
  SummaryScreenNotifier.new
);
