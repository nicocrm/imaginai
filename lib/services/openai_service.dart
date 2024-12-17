import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OpenAIService {
  final String apiKey = 'YOUR_OPENAI_API_KEY';
  final String endpoint = 'https://api.openai.com/v1/images/generations';

  Future<String?> generateImage(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'prompt': prompt,
          'n': 1,
          'size': '1024x1024',
          'response_format': 'url',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Return the URL of the generated image
        return data['data'][0]['url'];
      } else {
        debugPrint('Failed to generate image: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Error: $e');
      return null;
    }
  }
}
