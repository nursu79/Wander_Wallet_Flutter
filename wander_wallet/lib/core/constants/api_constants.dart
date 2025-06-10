class ApiConstants {
  // Auth endpoints
  static const String login = '/login';
  static const String register = '/register';
  static const String profile = '/profile';
  static const String refreshToken = '/token';
  static const String logout = '/logout';

  // Admin endpoints
  static const String admin = '/admin';

  // Trip endpoints
  static const String createTrip = '/trips';
  static const String allTrips = '/trips';
  static const String pastTrips = '/pastTrips';
  static const String currentTrips = '/currentTrips';
  static const String pendingTrips = '/pendingTrips';
  static String getTripPath(String id) {
    return '/trips/$id';
  }

  // Expense endpoints
  static String getExpensePath(String id) {
    return '/expenses/$id';
  }
  static String getTripExpensePath(String tripId) {
    return '/trips/$tripId/expenses';
  }

  // Notifications endpoints
  static const String notifications = '/notifications';
  static String getNotificationPath(String id) {
    return '/notifications/$id';
  }

  // Summary endpoints
  static const String getTotalSpending = '/stats/totalSpending';
  static const String getAvgSpendingPerTrip = '/stats/avgSpendingPerTrip';
  static const String getAvgSpendingPerDay = '/stats/avgSpendingPerDay';
  static const String getSpendingByCategory = '/stats/spendingByCategory';
  static const String getSpendingByMonth = '/stats/spendingByMonth';
  static const String getBudgetComparison = '/stats/budgetComparison';
  static const String getMostExpensiveTrip = '/stats/mostExpensiveTrip';
  static const String getLeastExpensiveTrip = '/stats/leastExpensiveTrip';
}
