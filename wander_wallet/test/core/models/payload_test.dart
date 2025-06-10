import 'package:flutter_test/flutter_test.dart';
import 'package:wander_wallet/core/models/payload.dart';
import 'package:wander_wallet/core/models/success.dart';

void main() {
  group('UserPayload', () {
    test('UserPayload fromJson and toJson work correctly', () {
      final json = {
        'user': {
          "id": "123",
          "username": "test",
          "email": "test@example.com",
          "role": "USER",
          "avatarUrl": null,
          "createdAt": "2024-01-01T00:00:00.000Z",
          "updatedAt": "2024-01-01T00:00:00.000Z",
        }
      };

      final payload = UserPayload.fromJson(json);
      expect(payload.user.username, 'test');
      expect(payload.user.email, 'test@example.com');

      final toJson = payload.toJson();
      expect(toJson['user']['username'], 'test');
    });
  });

  group('LoginPayload', () {
    test('LoginPayload fromJson and toJson work correctly', () {
      final json = {
        'accessToken': 'abc123',
        'refreshToken': 'def456',
        'user': {
          "id": "123",
          "username": "test_user",
          "email": "test@example.com",
          "role": "USER",
          "avatarUrl": null,
          "createdAt": "2024-01-01T00:00:00.000Z",
          "updatedAt": "2024-01-01T00:00:00.000Z"
        }
      };

      final payload = LoginPayload.fromJson(json);
      expect(payload.accessToken, 'abc123');
      expect(payload.refreshToken, 'def456');
      expect(payload.user?.email, 'test@example.com');

      final toJson = payload.toJson();
      expect(toJson['accessToken'], 'abc123');
    });
  });

  group('TripPayload', () {
    test('TripPayload fromJson and toJson work correctly', () {
      final json = {
        'trip': {
          "id": "t1",
          "name": "Trip to Japan",
          "destination": "Tokyo",
          "budget": 2500,
          "startDate": "2025-03-01T00:00:00.000Z",
          "endDate": "2025-04-10T00:00:00.000Z",
          "userId": "u1",
          "imgUrl": null,
          "expenses": [] 
        },
        'totalExpenditure': 1234.56,
        'expensesByCategory': [
          {'category': 'FOOD', '_sum': { 'amount': 100 }},
          {'category': 'TRANSPORTATION', '_sum': { 'amount': 200 }},
        ]
      };

      final payload = TripPayload.fromJson(json);
      expect(payload.trip.name, 'Trip to Japan');
      expect(payload.totalExpenditure, 1234.56);
      expect(payload.expensesByCategory?.length, 2);
      expect(payload.expensesByCategory?[0].category, Category.FOOD);

      final toJson = payload.toJson();
      expect(toJson['trip']['destination'], 'Tokyo');
    });
  });

  group('ConciseTripPayload', () {
    test('fromJson and toJson work correctly', () {
      final json = {
        'trip': {
          'id': 'trip2',
          'name': 'Winter Trip',
          'budget': 1000
        },
        'totalExpenditure': 789.0,
      };

      final payload = ConciseTripPayload.fromJson(json);
      expect(payload.trip.budget, 1000);
      expect(payload.totalExpenditure, 789.0);

      final toJson = payload.toJson();
      expect(toJson['trip']['name'], 'Winter Trip');
    });
  });

  group('TripsPayload', () {
    test('fromJson and toJson work correctly', () {
      final json = {
        'trips': [
          {
            "id": "t1",
            "name": "Trip to Japan",
            "destination": "Tokyo",
            "budget": 2500,
            "startDate": "2025-03-01T00:00:00.000Z",
            "endDate": "2025-04-10T00:00:00.000Z",
            "userId": "u1",
            "imgUrl": null,
            "expenses": []
          },
          {
            "id": "t1",
            "name": "Trip to Casablanca",
            "destination": "Morocco",
            "budget": 1500,
            "startDate": "2025-03-01T00:00:00.000Z",
            "endDate": "2025-04-10T00:00:00.000Z",
            "userId": "u1",
            "imgUrl": null,
            "expenses": []
          },
        ]
      };

      final payload = TripsPayload.fromJson(json);
      expect(payload.trips.length, 2);
      expect(payload.trips[1].destination, 'Morocco');

      final toJson = payload.toJson();
      expect(toJson['trips'][0]['name'], 'Trip to Japan');
    });
  });

  group('ExpensePayload', () {
    test('fromJson and toJson work correctly', () {
      final json = {
        'expense': {
          'id': 'exp1',
          'name': 'Lunch',
          'amount': 25.0,
          'category': 'FOOD',
          'date': '2025-06-10',
          'tripId': 'trip1'
        }
      };

      final payload = ExpensePayload.fromJson(json);
      expect(payload.expense.name, 'Lunch');
      expect(payload.expense.amount, 25.0);
      expect(payload.expense.category, Category.FOOD);

      final toJson = payload.toJson();
      expect(toJson['expense']['category'], 'FOOD');
    });
  });

  group('NotificationsPayload', () {
    test('fromJson and toJson work correctly', () {
      final json = {
        'notifications': [
          {
            'id': 'notif1',
            'tripId': 'trip1',
            'userId': 'user1',
            'surplus': 150
          }
        ]
      };

      final payload = NotificationsPayload.fromJson(json);
      expect(payload.notifications.length, 1);
      expect(payload.notifications.first.userId, 'user1');

      final toJson = payload.toJson();
      expect(toJson['notifications'][0]['tripId'], 'trip1');
    });
  });

  group('MessagePayload', () {
    test('fromJson and toJson work correctly', () {
      final json = {'message': 'Operation successful'};

      final payload = MessagePayload.fromJson(json);
      expect(payload.message, 'Operation successful');

      final toJson = payload.toJson();
      expect(toJson['message'], 'Operation successful');
    });
  });
}
