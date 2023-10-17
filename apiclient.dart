import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  // Assume you have methods like these to retrieve tokens from secure storage
  Future<String?> getJwtToken() async {
    // Implement your logic to retrieve the JWT token
  }

  Future<String?> getRefreshToken() async {
    // Implement your logic to retrieve the refreshToken
  }

  bool isJwtTokenExpired(String? jwtToken) {
    // Implement your logic to check if the JWT token is expired
    return false;
  }

  bool isRefreshTokenExpired(String? refreshToken) {
    // Implement your logic to check if the refreshToken is expired
    return false;
  }

  Future<void> refreshJwtToken(String refreshToken) async {
    // Implement your logic to refresh the JWT token
  }

  Future<void> makeAuthenticatedRequest(String url, Map<String, dynamic> body) async {
    final jwtToken = await getJwtToken();

    if (jwtToken != null && !isJwtTokenExpired(jwtToken)) {
      // JWT token is valid, attach it to the request header
      final headers = {'Authorization': 'Bearer $jwtToken'};

      try {
        // Make the API request
        final response = await http.post(Uri.parse(url), headers: headers, body: jsonEncode(body));

        if (response.statusCode == 200) {
          // Handle the successful response
          print('Response: ${response.body}');
        } else if (response.statusCode == 401) {
          // JWT token expired, attempt to refresh
          await handleTokenExpiration();
        } else {
          // Handle other status codes
          print('Error: ${response.statusCode}');
        }
      } catch (e) {
        // Handle network or other errors
        print('Error: $e');
      }
    } else {
      final refreshToken = await getRefreshToken();

      if (refreshToken != null && !isRefreshTokenExpired(refreshToken)) {
        // Refresh the JWT token
        await refreshJwtToken(refreshToken);
        // Retry the API request with the new JWT token
        await makeAuthenticatedRequest(url, body);
      } else {
        // Both tokens are expired, redirect to the login page
        // or show a login prompt
        print('Both tokens are expired, redirect to login');
      }
    }
  }

  Future<void> handleTokenExpiration() async {
    final refreshToken = await getRefreshToken();

    if (refreshToken != null && !isRefreshTokenExpired(refreshToken)) {
      // Refresh the JWT token
      await refreshJwtToken(refreshToken);
      // Retry the original API request after token refresh
    } else {
      // Both tokens are expired, redirect to the login page
      // or show a login prompt
      print('Both tokens are expired, redirect to login');
    }
  }
}

void main() async {
  final apiClient = ApiClient();

  // Example API endpoint to get courses
  final coursesEndpoint = 'https://your-api.com/api/courses';

  // Example request body (if required)
  final requestBody = {'param1': 'value1', 'param2': 'value2'};

  // Make an authenticated request to get courses
  await apiClient.makeAuthenticatedRequest(coursesEndpoint, requestBody);
}
