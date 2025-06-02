import 'package:flutter/material.dart';
import 'package:wander_wallet/core/models/success.dart';
import 'package:wander_wallet/core/utils/util_funcs.dart';

class ExpenseByCategoryCard extends StatelessWidget {
  final ExpenseByCategory category;
  final List<Expense> expenses;
  const ExpenseByCategoryCard({super.key, required this.category, required this.expenses});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () {
          _showCategoryExpenses(context, category.category);
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 8,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Icon(getIconForCategory(category.category), color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  Column(
                    spacing: 4,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${category.category.name[0]}${category.category.name.toLowerCase().substring(1)}", style: Theme.of(context).textTheme.bodyLarge),
                      Text('Total Expense')
                    ],
                  )
                ],
              ),
              Text('\$${category.sum.amount}', style: Theme.of(context).textTheme.bodyLarge)
            ],
          ),
        )
      )
    );
  }

  void _showCategoryExpenses(BuildContext context, Category category) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            spacing: 20,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Icon(getIconForCategory(category), color: Theme.of(context).colorScheme.onPrimary),
                  ),
                  Text("${category.name[0]}${category.name.toLowerCase().substring(1)}", style: Theme.of(context).textTheme.bodyLarge)
                ],
              ),
              Column(
                spacing: 12,
                children: getExpensesByCategory(expenses, category).map((expense) {
                  return Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed('/expenseDetails', arguments: { 'tripId': expense.tripId, 'id': expense.id });
                      },
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(expense.name, style: Theme.of(context).textTheme.bodyLarge),
                                Text('\$${expense.amount}', style: Theme.of(context).textTheme.bodyLarge)
                              ],
                            ),
                            Divider()
                          ]
                        )
                      ),
                    )
                  );
                }).toList(),
              )
            ],
          ),
        );
      }
    );
  }
}
