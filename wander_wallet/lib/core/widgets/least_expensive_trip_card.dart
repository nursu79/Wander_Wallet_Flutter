import 'package:flutter/material.dart';
import 'package:wander_wallet/core/models/payload.dart';
import 'package:wander_wallet/core/widgets/trip_summary_card.dart';

class LeastExpensiveTripCard extends StatelessWidget {
  final ConciseTripPayload tripData;
  const LeastExpensiveTripCard({super.key, required this.tripData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          spacing: 24,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Least Expensive Trip', style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary)),
            TripSummaryCard(
              id: tripData.trip.id,
              name: tripData.trip.name,
              budget: tripData.trip.budget,
              expenditure: tripData.totalExpenditure ?? 0,
            )
          ]
        )
      )
    );
  }
}