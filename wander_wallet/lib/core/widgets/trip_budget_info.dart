import 'package:flutter/material.dart';

class TripBudgetInfo extends StatelessWidget {
  final num budget;
  final num expenditure;
  const TripBudgetInfo({super.key, required this.budget, required this.expenditure});

  @override
  Widget build(BuildContext context) {
    final progress = (expenditure / budget);
    return Column(
      spacing: 16,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total Budget', style: Theme.of(context).textTheme.bodyLarge),
            Text('\$$budget', style: Theme.of(context).textTheme.bodyLarge)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total Expenses', style: Theme.of(context).textTheme.bodyLarge),
            Text('\$$expenditure', style: Theme.of(context).textTheme.bodyLarge)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Budget Progress', style: Theme.of(context).textTheme.bodyLarge),
            Text('${(progress * 100).toInt()}%', style: Theme.of(context).textTheme.bodyLarge)
          ],
        ),
        LinearProgressIndicator(
          value: progress,
          color: Theme.of(context).colorScheme.surface,
          valueColor: AlwaysStoppedAnimation(Theme.of(context).colorScheme.primary),
        )
      ],
    );
  }
}
