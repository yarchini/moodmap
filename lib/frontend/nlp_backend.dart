import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> detectEmotion(String userInput) async {
  final url = Uri.parse("http://your-server-ip:8000/predict/");
  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"text": userInput}),
  );

  if (response.statusCode == 200) {
    final result = jsonDecode(response.body);
    return result["emotion"];
  } else {
    return "Error detecting emotion";
  }
}
