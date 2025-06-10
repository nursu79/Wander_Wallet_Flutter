import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TripSummaryCard extends StatelessWidget {
  final String id;
  final String name;
  final num budget;
  final num expenditure;
  const TripSummaryCard({super.key, required this.id, required this.name, required this.budget, required this.expenditure});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percent = expenditure / budget;
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/tripDetails', arguments: id);
        },
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 20,
            children: [
              Text(name, style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary)),
              CircularPercentIndicator(
                radius: 60,
                percent: percent,
                center: Text("${(percent * 100).toInt()}%"),
                progressColor: theme.colorScheme.primary,
              )
            ],
          ),
        ),
      )
    );
  }
}