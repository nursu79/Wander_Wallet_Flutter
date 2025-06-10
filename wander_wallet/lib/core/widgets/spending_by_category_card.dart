import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:wander_wallet/core/models/success.dart';
import 'package:wander_wallet/core/utils/util_funcs.dart';

class SpendingByCategoryCard extends StatelessWidget {
  final List<CategorySpending> categories;
  const SpendingByCategoryCard({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Map<Category, Color> categoryColorMap = {
      Category.FOOD: theme.colorScheme.primary,
      Category.ACCOMMODATION: theme.colorScheme.tertiary,
      Category.ENTERTAINMENT: Colors.red,
      Category.SHOPPING: Colors.amber,
      Category.TRANSPORTATION: Colors.cyan,
      Category.OTHER: theme.colorScheme.outline
    };
  
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Spending By Category', style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary)),
            SizedBox(height: 20),
            SizedBox(
              height: 240,
              child: BarChart(
                BarChartData(
                  borderData: FlBorderData(
                    show: false,
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) => Text(categories[value.toInt()].category.name.substring(0, 3)),
                        reservedSize: 50,
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40
                      ),
                    ),
                  ),
                  barGroups: categories.mapIndexed((index, category) {
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: category.amount.toDouble(),
                          color: categoryColorMap[category.category],
                          width: 20
                        )
                      ]
                    );
                  }).toList()
                )
              ),
            ),
            SizedBox(height: 20),
            // SizedBox(
            //   height: 240,
            //   child: LineChart(
            //     LineChartData(
            //       minY: 0,
            //       lineBarsData: [
            //         LineChartBarData(
            //           spots: getFlSpots(categories),
            //           color: theme.colorScheme.tertiary,
            //           barWidth: 3,
            //           isCurved: true
            //         )
            //       ],
            //       titlesData: FlTitlesData(
            //         leftTitles: AxisTitles(
            //           axisNameWidget: Text('Amount'),
            //           sideTitles: SideTitles(showTitles: true)
            //         ),
            //         rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            //         topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            //         bottomTitles: AxisTitles(
            //           axisNameWidget: Text('Category'),
            //           sideTitles: SideTitles(
            //             getTitlesWidget: (value, _) {
            //               if (value.round() == 0) {
            //                 return Text('');
            //               }

            //               return Text(categories[value.round() - 1].category.name.substring(0, 3));
            //             },
            //             showTitles: true
            //           )
            //         )
            //       )
            //     ),
            //   ),
            // ),
            SizedBox(
              height: 240,
              child: PieChart(
                PieChartData(
                  sections: categories.map((category) {
                    return PieChartSectionData(
                      value: category.amount.toDouble(),
                      title: category.category.name,
                      showTitle: true,
                      radius: 30,
                      color: categoryColorMap[category.category]
                    );
                  }).toList()
                )
              ),
            )
            // LineChart(
            //   LineChartData(
            //     minY: 0,
            //     lineBarsData: [
            //       LineChartBarData(
            //         spots: getFlSpots(categories),
            //         color: theme.colorScheme.tertiary,
            //         barWidth: 6,
            //         isCurved: true
            //       )
            //     ],
            //     titlesData: FlTitlesData(
            //       leftTitles: AxisTitles(
            //         axisNameWidget: Text('Amount'),
            //         sideTitles: SideTitles(showTitles: true)
            //       ),
            //       bottomTitles: AxisTitles(
            //         axisNameWidget: Text('Category'),
            //         sideTitles: SideTitles(
            //           getTitlesWidget: (value, meta) {
            //             return Text(categories[value.toInt()].category.name);
            //           },
            //         )
            //       )
            //     )
            //   ),
            // ),
            // PieChart(
            //   PieChartData(
            //     sections: categories.map((category) {
            //       return PieChartSectionData(
            //         value: category.amount.toDouble(),
            //         title: category.category.name,
            //         showTitle: true,
            //         radius: 70,
            //         color: categoryColorMap[category.category]
            //       );
            //     }).toList()
            //   )
            // )
          ],
        )
      )
    );
  }
}