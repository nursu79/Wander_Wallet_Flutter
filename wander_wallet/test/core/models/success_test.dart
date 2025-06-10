import 'package:flutter_test/flutter_test.dart';
import 'package:wander_wallet/core/models/payload.dart';
import 'package:wander_wallet/core/models/success.dart';

void main() {
  group('User', () {
    test('fromJson and toJson should work correctly', () {
      final json = {
        "id": "123",
        "username": "test_user",
        "email": "test@example.com",
        "role": "USER",
        "avatarUrl": null,
        "createdAt": "2024-01-01T00:00:00.000Z",
        "updatedAt": "2024-01-01T00:00:00.000Z",
      };

      final user = User.fromJson(json);
      expect(user.id, "123");
      expect(user.username, "test_user");
      expect(user.email, "test@example.com");

      final toJson = user.toJson();
      expect(toJson["id"], "123");
    });
  });

  group('Trip', () {
    test('fromJson and toJson should work correctly', () {
      final json = {
        "id": "t1",
        "name": "Trip to Japan",
        "destination": "Tokyo",
        "budget": 2500,
        "startDate": "2025-03-01T00:00:00.000Z",
        "endDate": "2025-04-10T00:00:00.000Z",
        "userId": "u1",
        "imgUrl": null,
        "expenses": []
      };

      final trip = Trip.fromJson(json);
      expect(trip.name, "Trip to Japan");
      expect(trip.destination, "Tokyo");
      expect(trip.budget, 2500);
      expect(trip.startDate.toIso8601String(), "2025-03-01T00:00:00.000Z");
      expect(trip.endDate.toIso8601String(), "2025-04-10T00:00:00.000Z");
      expect(trip.imgUrl, null);

      final toJson = trip.toJson();
      expect(toJson["budget"], 2500);
    });
  });

  group('Category enum', () {
    test('should contain all expected values', () {
      expect(Category.values.length, 6);
      expect(Category.values.contains(Category.FOOD), true);
      expect(Category.values.contains(Category.ACCOMMODATION), true);
      expect(Category.values.contains(Category.TRANSPORTATION), true);
      expect(Category.values.contains(Category.ENTERTAINMENT), true);
      expect(Category.values.contains(Category.SHOPPING), true);
      expect(Category.values.contains(Category.OTHER), true);
    });
  });

  group('Expense', () {
    test('fromJson and toJson should work correctly', () {
      final json = {
        "id": "e1",
        "name": "Sushi",
        "amount": 45.5,
        "category": "FOOD",
        "date": "2024-03-02T00:00:00.000Z",
        "tripId": "t1",
        "notes": "Dinner"
      };

      final expense = Expense.fromJson(json);
      expect(expense.name, "Sushi");

      // Test that the factory method handles the category enum conversion correctly
      expect(expense.category, Category.FOOD);
      expect(expense.amount, 45.5);

      expect(expense.notes, 'Dinner');

      final toJson = expense.toJson();
      expect(toJson["amount"], 45.5);
    });

    test('fromJson rejects an invalid category', () {
      final json = {
        "id": "e1",
        "name": "Sushi",
        "amount": 45.5,
        "category": "INVALID",
        "date": "2024-03-02T00:00:00.000Z",
        "tripId": "t1",
        "notes": "Dinner"
      };

      expect(() => Expense.fromJson(json), throwsArgumentError);
    });
  });

  group('AllStats', () {
    test('should assign and access fields properly', () {
      final stats = AllStats(
        totalSpending: 1000,
        totalBudget: 2000,
        avgSpendingPerTrip: 500,
        avgSpendingPerDay: 100,
        spendingByCategory: [
          CategorySpending(category: Category.FOOD, amount: 400),
          CategorySpending(category: Category.TRANSPORTATION, amount: 600),
        ],
        monthlySpending: [
          {"Jan": 800},
          {"Feb": 200},
        ],
        budgetComparisons: [
          BudgetComparison(
            tripId: "t1",
            name: "Trip 1",
            budget: 1000,
            expenditure: 900,
          )
        ],
        mostExpensiveTrip: ConciseTripPayload(
          trip: ConciseTrip(
            id: "t1",
            name: "Trip 1",
            budget: 1000,
          ),
          totalExpenditure: 100
        ),
        leastExpensiveTrip: ConciseTripPayload(
          trip: ConciseTrip(
            id: "t2",
            name: "Trip 2",
            budget: 200,
          ),
          totalExpenditure: 100
        ),
      );

      expect(stats.totalSpending, 1000);
      expect(stats.spendingByCategory.first.category, Category.FOOD);
      expect(stats.monthlySpending[0]["Jan"], 800);
    });
  });
}