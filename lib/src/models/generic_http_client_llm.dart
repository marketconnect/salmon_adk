import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'base_llm.dart';
import 'llm_request.dart';
import 'llm_response.dart';

/// An LLM implementation that interacts with a generic HTTP-based LLM service.
/// This class is a basic example and may need customization for specific LLM APIs.
class GenericHttpClientLlm extends BaseLlm {
  final String apiUrl;
  final String apiKey;
  final Map<String, String>? additionalHeaders;

  GenericHttpClientLlm({
    required super.modelName,
    required this.apiUrl,
    required this.apiKey,
    this.additionalHeaders,
  });

  @override
  Stream<LlmResponse> generateContentAsync(LlmRequest request) async* {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey', // Common pattern, adjust if needed
      ...?additionalHeaders,
    };

    String constructedPrompt = request.instruction;
    if (request.history.isNotEmpty) {
      constructedPrompt += '\n\nConversation History:';
      for (final event in request.history) {
        final author = event.author;
        final textContent = event.content['text'] as String?;
        if (textContent != null) {
          constructedPrompt += '\n$author: $textContent';
        }
      }
    }
    final userInputText = request.userContent['text'] as String? ?? '';
    if (userInputText.isNotEmpty) {
      constructedPrompt += '\n\nUser: $userInputText';
    }
    constructedPrompt += '\n\nAssistant:';

    // Basic payload structure, may need significant adjustment for specific LLMs.
    // This example loosely follows OpenAI's chat completion structure for messages.
    final payload = {
      'model': request.modelName,
      'messages': [
        {'role': 'system', 'content': request.instruction},
        // Simplified history mapping
        ...request.history.map((e) => {
              'role': e.author == 'user' ? 'user' : 'assistant',
              'content': e.content['text'] ?? ''
            }),
        {'role': 'user', 'content': request.userContent['text'] ?? ''}
      ],
      // Tools would be formatted here according to the specific LLM API
      // 'tools': request.tools.map((t) => t.declaration.toJson()).toList(),
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        // Parse responseBody according to your LLM's API structure.
        // This is a very simplified example.
        final textContent =
            responseBody['choices']?[0]?['message']?['content'] as String?;
        // final functionCalls = parseFunctionCalls(responseBody); // Implement this

        yield LlmResponse(
          content: textContent != null ? {'text': textContent} : null,
          // functionCalls: functionCalls,
        );
      } else {
        yield LlmResponse(content: {
          'error': 'API Error: ${response.statusCode} ${response.body}'
        });
      }
    } catch (e) {
      yield LlmResponse(content: {'error': 'Exception: ${e.toString()}'});
    }
  }
}
