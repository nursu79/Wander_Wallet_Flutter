import 'package:flutter/material.dart';

class AverageSpendingCard extends StatelessWidget {
  final num avgSpendingPerTrip;
  final num avgSpendingPerDay;

  const AverageSpendingCard({super.key, required this.avgSpendingPerTrip, required this.avgSpendingPerDay});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Average Spending', style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary)),
            SizedBox(height: 24,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Per Trip', style: theme.textTheme.bodyLarge,),
                Text("\$${avgSpendingPerTrip.toStringAsFixed(2)}", style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.primary))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Per Day', style: theme.textTheme.bodyLarge),
                Text("\$${avgSpendingPerDay.toStringAsFixed(2)}", style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.primary))
              ],
            )
          ],
        )
      )
    );
  }
}