import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:wander_wallet/core/models/success.dart';
import 'package:wander_wallet/core/utils/util_funcs.dart';

void main() {
  group('getIconForCategory', () {
    test('returns correct icons for each category', () {
      expect(getIconForCategory(Category.FOOD), Icons.fastfood);
      expect(getIconForCategory(Category.TRANSPORTATION), Icons.directions_car);
      expect(getIconForCategory(Category.ACCOMMODATION), Icons.hotel);
      expect(getIconForCategory(Category.ENTERTAINMENT), Icons.sports_esports);
      expect(getIconForCategory(Category.SHOPPING), Icons.shopping_bag);
      expect(getIconForCategory(Category.OTHER), Icons.more_horiz);
    });
  });

  group('getExpensesByCategory', () {
    final expenses = [
      Expense(id: '1', name: 'Burger', amount: 10, category: Category.FOOD, date: DateTime.now(), tripId: 'trip1'),
      Expense(id: '2', name: 'Taxi', amount: 15, category: Category.TRANSPORTATION, date: DateTime.now(), tripId: 'trip1'),
      Expense(id: '3', name: 'Pizza', amount: 12, category: Category.FOOD, date: DateTime.now(), tripId: 'trip1'),
    ];

    test('filters expenses by FOOD category', () {
      final foodExpenses = getExpensesByCategory(expenses, Category.FOOD);
      expect(foodExpenses.length, 2);
      expect(foodExpenses.every((e) => e.category == Category.FOOD), isTrue);
    });

    test('returns empty list when no match is found', () {
      final entertainmentExpenses = getExpensesByCategory(expenses, Category.ENTERTAINMENT);
      expect(entertainmentExpenses, isEmpty);
    });
  });

  group('getFlSpots', () {
    test('converts list of maps into FlSpot points correctly', () {
      final data = [
        {'Jan': 100},
        {'Feb': 150},
        {'Mar': 200},
      ];

      final spots = getFlSpots(data);

      // First item is always (0, 0) to add some space for the chart
      expect(spots.length, 4);
      expect(spots[0], const FlSpot(0, 0));
      expect(spots[1], const FlSpot(1, 100));
      expect(spots[2], const FlSpot(2, 150));
      expect(spots[3], const FlSpot(3, 200));
    });

    test('returns only FlSpot(0, 0) when input is empty', () {
      final spots = getFlSpots([]);
      expect(spots.length, 1);
      expect(spots[0], const FlSpot(0, 0));
    });
  });
}
