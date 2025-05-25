import '../events/event.dart';
import 'invocation_context.dart';

/// Base class for all agents in the Salmon ADK.
class BaseAgent {
  /// A descriptive name for the agent.
  /// Agent name should ideally be unique within an agent system.
  final String name;

  /// Description about the agent's capability.
  /// This can be used by models or dispatchers to determine agent suitability.
  final String description;

  /// Creates a [BaseAgent].
  ///
  /// [name] is required.
  /// [description] is optional and defaults to an empty string.
  BaseAgent({required this.name, this.description = ''});

  /// Executes the agent's logic asynchronously based on the given [context].
  /// This is typically for text-based or non-real-time interactions.
  Stream<Event> runAsync(InvocationContext context) {
    throw UnimplementedError('runAsync() has not been implemented by $name');
  }

  /// Executes the agent's logic in a live, streaming manner based on the given [context].
  /// This is typically for audio/video or real-time interactions.
  Stream<Event> runLive(InvocationContext context) {
    throw UnimplementedError('runLive() has not been implemented by $name');
  }
}
