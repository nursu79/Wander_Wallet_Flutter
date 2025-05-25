import 'package:flutter/material.dart';

import '../models/success.dart';

IconData getIconForCategory(Category category) {
  switch (category) {

    case Category.FOOD:
      return Icons.fastfood;
    case Category.TRANSPORTATION:
      return Icons.directions_car;
    case Category.ACCOMMODATION:
      return Icons.hotel;
    case Category.ENTERTAINMENT:
      return Icons.sports_esports;
    case Category.SHOPPING:
      return Icons.shopping_bag;
    case Category.OTHER:
      return Icons.more_horiz;
  }
}

List<Expense> getExpensesByCategory(List<Expense> expenses, Category category) {
  return expenses.where((expense) {
    return (expense.category == category);
  }).toList();
}
