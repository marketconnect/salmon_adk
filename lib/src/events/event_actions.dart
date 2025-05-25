/// Represents actions associated with an [Event].
class EventActions {
  /// A map representing changes to be applied to the session state.
  /// Keys are state variable names, and values are their new values.
  final Map<String, dynamic>? stateDelta;

  /// If set, the event transfers to the specified agent.
  final String? transferToAgent;

  // Other potential actions can be added here, e.g.:
  // final bool? escalate;

  /// Creates an [EventActions] instance.
  ///
  /// [stateDelta] is optional and represents changes to the session state.
  EventActions({
    this.stateDelta,
    this.transferToAgent,
  });
}
