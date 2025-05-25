import '../events/event.dart';
import '../tools/base_tool.dart';

/// Represents a request to be sent to an LLM.
class LlmRequest {
  /// The name of the model to use.
  final String modelName;

  /// The system instruction or prompt.
  final String instruction;

  /// The conversation history.
  final List<Event> history;

  /// Tools available for the LLM to use.
  final List<BaseTool> tools;

  /// The current user content for this turn.
  final Map<String, dynamic> userContent;

  LlmRequest({
    required this.modelName,
    required this.instruction,
    this.history = const [],
    this.tools = const [],
    this.userContent = const {},
  });
}
