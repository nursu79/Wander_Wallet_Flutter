import 'package:flutter_test/flutter_test.dart';
import 'package:wander_wallet/core/models/error.dart';

void main() {
  group('UserError', () {
    test('fromJson and toJson work correctly', () {
      final json = {
        "username": "Username is required",
        "email": "Email is invalid",
        "password": "Password too short",
        "message": "Validation failed"
      };

      final error = UserError.fromJson(json);

      expect(error.username, "Username is required");
      expect(error.email, "Email is invalid");
      expect(error.password, "Password too short");
      expect(error.message, "Validation failed");

      final toJson = error.toJson();
      expect(toJson['username'], "Username is required");
    });
  });

  group('TripError', () {
    test('fromJson and toJson work correctly', () {
      final json = {
        "name": "Trip name missing",
        "destination": "Destination invalid",
        "budget": "Budget must be a number",
        "startDate": "Start date required",
        "endDate": "End date required",
        "message": "Trip validation failed"
      };

      final error = TripError.fromJson(json);

      expect(error.name, "Trip name missing");
      expect(error.destination, "Destination invalid");
      expect(error.budget, "Budget must be a number");
      expect(error.startDate, "Start date required");
      expect(error.endDate, "End date required");
      expect(error.message, "Trip validation failed");

      final toJson = error.toJson();
      expect(toJson['budget'], "Budget must be a number");
    });
  });

  group('ExpenseError', () {
    test('fromJson and toJson work correctly', () {
      final json = {
        "name": "Name is missing",
        "amount": "Invalid amount",
        "category": "Invalid category",
        "date": "Date is required",
        "message": "Expense validation failed"
      };

      final error = ExpenseError.fromJson(json);

      expect(error.name, "Name is missing");
      expect(error.amount, "Invalid amount");
      expect(error.category, "Invalid category");
      expect(error.date, "Date is required");
      expect(error.message, "Expense validation failed");

      final toJson = error.toJson();
      expect(toJson['category'], "Invalid category");
    });
  });

  group('MessageError', () {
    test('fromJson and toJson work correctly', () {
      final json = {
        "message": "Something went wrong"
      };

      final error = MessageError.fromJson(json);

      expect(error.message, "Something went wrong");

      final toJson = error.toJson();
      expect(toJson['message'], "Something went wrong");
    });
  });
}
