/// Represents a function call requested by the LLM.
class FunctionCall {
  final String name;
  final Map<String, dynamic> args;

  FunctionCall({required this.name, required this.args});
}

/// Represents a response from an LLM.
class LlmResponse {
  /// The main content of the response (e.g., text).
  final Map<String, dynamic>? content;

  /// A list of function calls requested by the LLM.
  final List<FunctionCall>? functionCalls;

  /// Potential state changes suggested by the LLM or resulting from its processing.
  final Map<String, dynamic>? stateDelta;

  /// Indicates if the response is partial (for streaming).
  final bool isPartial;

  LlmResponse({
    this.content,
    this.functionCalls,
    this.stateDelta,
    this.isPartial = false,
  });
}
