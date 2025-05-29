import '../state/state.dart';
import 'invocation_context.dart';

/// Provides read-only access to the invocation context.
/// This is typically used as a base for contexts passed to callbacks or tools
/// where direct mutation of the core invocation data is not intended.
class ReadOnlyContext {
  final InvocationContext _invocationContext;

  /// Creates a [ReadOnlyContext].
  ReadOnlyContext(this._invocationContext);

  /// The ID of the current invocation.
  String get invocationId => _invocationContext.invocationId;

  /// The name of the agent that is currently running.
  String get agentName => _invocationContext.agent.name;

  /// A read-only view of the current session state.
  /// To modify state, use `CallbackContext.state`.
  Map<String, dynamic> get sessionState =>
      Map.unmodifiable(_invocationContext.session.state);

  /// Provides access to the underlying [State] object for more complex state interactions
  /// if needed, but typically direct map access via `sessionState` is sufficient for read-only.
  State get state =>
      State(initialValue: Map.unmodifiable(_invocationContext.session.state));
}
