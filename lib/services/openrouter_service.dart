import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_keys.dart';

class OpenRouterService {
  static const String _url =
      'https://openrouter.ai/api/v1/chat/completions';

  Future<String> sendMessage(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {
          'Authorization': 'Bearer ${ApiKeys.openRouterApiKey}',
          'Content-Type': 'application/json',
          'HTTP-Referer': 'https://academicassistant.app',
          'X-Title': 'Academic Assistant',
        },
        body: jsonEncode({
          'model': 'openrouter/free',
          'messages': [
            {
              'role': 'user',
              'content': prompt,
            }
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final text =
        data['choices'][0]['message']['content'];

        return text;
      } else {
        return 'Error: ${response.statusCode}\n${response.body}';
      }
    } catch (e) {
      return 'Something went wrong: $e';
    }
  }
}