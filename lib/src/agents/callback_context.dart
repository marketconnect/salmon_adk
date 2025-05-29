import '../events/event_actions.dart';
import '../state/state.dart';
import 'invocation_context.dart';
import 'readonly_context.dart';

/// The context of various callbacks within an agent run.
/// It provides access to the invocation context and allows for modifications
/// to event actions and session state.
class CallbackContext extends ReadOnlyContext {
  /// Actions to be associated with the event generated from this callback.
  final EventActions _eventActions;

  /// The delta-aware state of the current session.
  /// Mutations to this state object will be recorded in `_eventActions.stateDelta`.
  final State _state;

  /// Creates a [CallbackContext].
  ///
  /// [invocationContext] is the underlying context for the current agent invocation.
  /// [eventActions] can be optionally provided if extending existing actions.
  CallbackContext(InvocationContext invocationContext,
      {EventActions? eventActions})
      : _eventActions = eventActions ?? EventActions(),
        _state = State(
          initialValue: Map.from(invocationContext
              .session.state), // Start with current session state
          initialDelta: (eventActions ?? EventActions()).stateDelta ??
              {}, // Track changes here
        ),
        super(invocationContext);

  /// The delta-aware state of the current session.
  /// For any state change, you can mutate this object directly,
  /// e.g., `ctx.state.set('foo', 'bar')`. Changes are tracked in `_eventActions`.
  @override
  State get state => _state;

  EventActions get eventActions => _eventActions;
}
