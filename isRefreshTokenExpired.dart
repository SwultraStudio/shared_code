bool isRefreshTokenExpired() {
  // Assume 'refreshTokenExpiration' is a string representation of DateTime
  String refreshTokenExpirationString = secure_storage.read(key: 'refreshTokenExpiration') as String;

  // Parse the stored string to DateTime
  DateTime refreshTokenExpiration = DateTime.parse(refreshTokenExpirationString);

  // Get the current time in UTC
  DateTime currentTime = DateTime.now().toUtc();

  // Compare the stored expiration time with the current time
  return refreshTokenExpiration.isBefore(currentTime);
}
