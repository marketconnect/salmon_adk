import 'llm_request.dart';
import 'llm_response.dart';

/// Abstract base class for Large Language Models (LLMs).
/// Defines the contract for interacting with an LLM.
abstract class BaseLlm {
  /// The name or identifier of the LLM model.
  final String modelName;

  BaseLlm({required this.modelName});

  /// Generates content from the LLM based on the given [request].
  /// This method should handle communication with the actual LLM API.
  Stream<LlmResponse> generateContentAsync(LlmRequest request);
}
