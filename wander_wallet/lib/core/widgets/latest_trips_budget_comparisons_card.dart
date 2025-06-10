import 'package:flutter/material.dart';
import 'package:percent_indicator/flutter_percent_indicator.dart';
import 'package:wander_wallet/core/models/success.dart';
import 'package:wander_wallet/core/widgets/trip_summary_card.dart';

class LatestTripsBudgetComparisonsCard extends StatelessWidget {
  final List<BudgetComparison> tripsData;
  const LatestTripsBudgetComparisonsCard({super.key, required this.tripsData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Latest Trips', style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary)),
            Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: tripsData.map((tripData) {
                return TripSummaryCard(
                  id: tripData.tripId,
                  name: tripData.name,
                  budget: tripData.budget,
                  expenditure: tripData.expenditure,
                );
              }).toList(),
            )
          ]
        )
      )
    );
  }
}