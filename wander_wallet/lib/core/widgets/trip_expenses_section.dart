import 'package:flutter/material.dart';
import 'package:wander_wallet/core/models/success.dart';
import 'package:wander_wallet/core/widgets/expense_by_category_card.dart';

class TripExpensesSection extends StatelessWidget {
  final Trip trip;
  final List<ExpenseByCategory> categories;
  const TripExpensesSection({super.key, required this.trip, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Expenses', style: Theme.of(context).textTheme.titleLarge),
        if (categories.isEmpty)
          Center(child: Text('No expenses yet.'))
        else
          Column(
            children: categories.map((category) => ExpenseByCategoryCard(category: category, expenses: trip.expenses!)).toList()
          )
      ],
    );
  }
}
