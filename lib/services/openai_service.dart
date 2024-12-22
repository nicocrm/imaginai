import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../core/result.dart';

class OpenAIService {
  final String apiKey;
  final String endpoint = 'https://api.openai.com/v1/images/generations';

  OpenAIService() : apiKey = dotenv.env['OPENAI_API_KEY'] ?? '' {
    if (apiKey.isEmpty) {
      throw Exception('OpenAI API Key is not set. Please check your .env file.');
    }
  }

  Future<Result<String>> generateImage(String prompt) async {
    try {
      return Result.success("https://picsum.photos/1024/1024");
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
        final imageUrl = data['data'][0]['url'];
        return Result.success(imageUrl);
      } else {
        debugPrint('Failed to generate image: ${response.body}');
        return Result.failure('Failed to generate image: ${response.body}');
      }
    } catch (e) {
      FlutterError.reportError(FlutterErrorDetails(
        exception: e,
        context: ErrorSummary('error generating image'),
      ));
      return Result.failure('Error generating image: $e');
    }
  }
}