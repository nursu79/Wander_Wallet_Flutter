import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:wander_wallet/core/models/success.dart';
import 'package:wander_wallet/core/utils/util_funcs.dart';

class SpendingByMonthCard extends StatelessWidget {
  final List<Map<String, num>> monthsData;
  const SpendingByMonthCard({super.key, required this.monthsData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Spending By Month', style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary)),
            SizedBox(height: 20),
            SizedBox(
              height: 240,
              child: LineChart(
                LineChartData(
                  minY: 0,
                  lineBarsData: [
                    LineChartBarData(
                      spots: getFlSpots(monthsData),
                      color: theme.colorScheme.primary,
                      barWidth: 3,
                      isCurved: true
                    )
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 40)
                    ),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        getTitlesWidget: (value, _) {
                          if (value.round() == 0) {
                            return Text('');
                          }

                          return Text(monthsData[value.round() - 1].keys.first.substring(0, 3));
                        },
                        showTitles: true
                      )
                    )
                  )
                ),
              ),
            ),
          ],
        )
      )
    );
  }
}