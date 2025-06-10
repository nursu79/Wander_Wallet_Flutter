import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wander_wallet/core/widgets/average_spending_card.dart';
import 'package:wander_wallet/core/widgets/latest_trips_budget_comparisons_card.dart';
import 'package:wander_wallet/core/widgets/least_expensive_trip_card.dart';
import 'package:wander_wallet/core/widgets/most_expensive_trip_card.dart';
import 'package:wander_wallet/core/widgets/spending_by_category_card.dart';
import 'package:wander_wallet/core/widgets/spending_by_month_card.dart';
import 'package:wander_wallet/core/widgets/total_spending_card.dart';
import 'package:wander_wallet/features/summary/presentation/providers/summary_provider.dart';

class SummaryScreen extends ConsumerStatefulWidget {
  const SummaryScreen({ super.key });

  @override
  ConsumerState<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends ConsumerState<SummaryScreen> {
  @override
  Widget build(BuildContext context) {
    final summaryState = ref.watch(summaryProvider);

    return summaryState.when(
      data: (data) {
        final allStats = (data as SummarySuccess).allStats;

        return Padding(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TotalSpendingCard(
                  totalSpending: allStats.totalSpending,
                  totalBudget: allStats.totalBudget
                ),
                AverageSpendingCard(
                  avgSpendingPerTrip: allStats.avgSpendingPerTrip,
                  avgSpendingPerDay: allStats.avgSpendingPerDay,
                ),
                SpendingByCategoryCard(categories: allStats.spendingByCategory),
                SpendingByMonthCard(monthsData: allStats.monthlySpending.reversed.toList()),
                LatestTripsBudgetComparisonsCard(tripsData: allStats.budgetComparisons),
                MostExpensiveTripCard(tripData: allStats.mostExpensiveTrip),
                LeastExpensiveTripCard(tripData: allStats.leastExpensiveTrip)
              ],
            ),
          ),
        );
      },
      loading: () {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
      error: (error, _) {
        print(error);
        return Text('Error');
      }
    );
  }
}