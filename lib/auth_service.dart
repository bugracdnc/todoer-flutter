import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String apiUrl = 'http://192.168.0.107:8654/api/v1/todoer/login';

  Future<String?> login() async {
    try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json; // Assuming your API returns a token here
    } else {
      // Handle errors
      return null;
    }
    } catch (e) {
      return 'failed';
    }
  }
}
