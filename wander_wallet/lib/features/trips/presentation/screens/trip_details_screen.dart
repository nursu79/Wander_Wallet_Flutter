import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wander_wallet/core/widgets/buttons.dart';
import 'package:wander_wallet/core/widgets/trip_budget_info.dart';
import 'package:wander_wallet/core/widgets/trip_expenses_section.dart';
import 'package:wander_wallet/features/trips/presentation/providers/trip_details_provider.dart';

class TripDetailsScreen extends ConsumerStatefulWidget {
  final String id;

  const TripDetailsScreen({ super.key, required this.id });
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends ConsumerState<TripDetailsScreen> {

  @override
  Widget build(BuildContext context) {
    final asyncValue = ref.watch(tripDetailsProvider(widget.id));

    return asyncValue.when(
        data: (data) {
          final tripPayload = (data as TripDetailsSuccess).tripPayload;

          return Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              spacing: 28,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TripBudgetInfo(budget: tripPayload.trip.budget, expenditure: tripPayload.totalExpenditure),
                TripExpensesSection(trip: tripPayload.trip, categories: tripPayload.expensesByCategory)
              ],
            ),
          );
        },
        error: (err, stack) {
          return Center(
            child: Column(
              spacing: 16,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text((err as TripDetailsError).error.message),
                RectangularButton(
                  onPressed: () {
                    ref.read(tripDetailsProvider(widget.id).notifier).refresh();
                  },
                  text: 'Retry',
                )
              ],
            ),
          );
        },
        loading: () => Center(child: CircularProgressIndicator(),)
    );
  }
}
