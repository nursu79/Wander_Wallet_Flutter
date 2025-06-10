import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TotalSpendingCard extends StatelessWidget {
  final num totalSpending;
  final num totalBudget;
  const TotalSpendingCard({super.key, required this.totalSpending, required this.totalBudget});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percent = totalSpending / totalBudget;
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Total Spending', style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary)),
            SizedBox(height: 16),
            Center(
              child: CircularPercentIndicator(
                radius: 80,
                percent: percent,
                lineWidth: 10,
                center: Text("${(percent * 100).toInt().toString()}%"),
                progressColor: theme.colorScheme.primary,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Spent', style: theme.textTheme.bodyLarge,),
                Text("\$${totalSpending.toStringAsFixed(2)}", style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.error))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Budget', style: theme.textTheme.bodyLarge),
                Text("\$${totalBudget.toStringAsFixed(2)}", style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.primary))
              ],
            )
          ],
        ),
      )
    );
  }
}