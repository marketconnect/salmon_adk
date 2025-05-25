import 'dart:async';
import 'dart:math';

import 'base_llm.dart';
import 'llm_request.dart';
import 'llm_response.dart';

/// A simulated LLM for testing and development purposes.
/// It does not make actual API calls.
class SimulatedLlm extends BaseLlm {
  SimulatedLlm({required super.modelName});

  @override
  Stream<LlmResponse> generateContentAsync(LlmRequest request) async* {
    await Future.delayed(Duration(
        milliseconds: 100 + Random().nextInt(400))); // Simulate latency

    final userInputText =
        request.userContent['text'] as String? ?? 'no specific user input';

    // Simple logic: if tools are available and user input mentions "weather", simulate a tool call.
    if (request.tools
            .any((tool) => tool.declaration.name.contains('weather')) &&
        userInputText.toLowerCase().contains('weather')) {
      yield LlmResponse(
        functionCalls: [
          FunctionCall(
              name: 'get_weather', args: {'location': 'San Francisco'}),
        ],
      );
      // Simulate a follow-up after tool call
      await Future.delayed(Duration(milliseconds: 50 + Random().nextInt(150)));
      yield LlmResponse(
        content: {
          'text': 'After checking, the weather in San Francisco is sunny.'
        },
        stateDelta: {'last_weather_checked': 'San Francisco'},
      );
    } else {
      // Otherwise, generate a simple text response.
      final responseText =
          'Simulated response from $modelName for instruction "${request.instruction}" and input "$userInputText".';
      yield LlmResponse(
        content: {'text': responseText},
        stateDelta: {'last_simulated_query': userInputText},
      );
    }
  }
}
