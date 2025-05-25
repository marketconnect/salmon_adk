import '../agents/invocation_context.dart';
import '../events/event_actions.dart';
import '../state/state.dart';

/// Provides context for tool execution.
class ToolContext {
  final InvocationContext invocationContext;
  final EventActions actions = EventActions(); // Tools can suggest actions

  ToolContext({required this.invocationContext});

  /// Access to the session state.
  State get state =>
      State(initialValue: Map.from(invocationContext.session.state));

  // In a more complete version, this would provide methods like:
  // - requestCredential()
  // - saveArtifact() / loadArtifact()
  // - searchMemory()
}
