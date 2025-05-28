class ApiConstants {
  // Auth endpoints
  static const String login = '/login';
  static const String register = '/register';
  static const String profile = '/profile';
  static const String refreshToken = '/token';
  static const String logout = '/logout';
  static const String notifications = '/notifications';

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
}
