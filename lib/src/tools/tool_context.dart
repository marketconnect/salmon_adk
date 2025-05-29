import '../agents/callback_context.dart';
import '../agents/invocation_context.dart';
import '../events/event_actions.dart';

/// Provides context for tool execution.
class ToolContext extends CallbackContext {
  /// The ID of the function call that this tool context is associated with.
  /// This ID is used to map the tool's response back to the specific function call
  /// requested by the LLM.
  final String? functionCallId;

  /// Creates a [ToolContext].
  ///
  /// [invocationContext] is the core context of the agent's current run.
  /// [functionCallId] is optional and identifies the specific function call if applicable.
  /// [eventActions] can be provided if this context needs to build upon existing actions.
  ToolContext({
    required InvocationContext invocationContext,
    this.functionCallId,
    EventActions? eventActions,
  }) : super(invocationContext, eventActions: eventActions);

  // Specific methods for tool interactions (e.g., artifact handling, memory search) can be added here.
}
