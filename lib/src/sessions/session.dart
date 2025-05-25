import '../events/event.dart';

/// Represents a series of interactions between a user and agents.
class Session {
  /// A unique identifier for the session.
  final String id;

  /// The name of the application this session belongs to.
  final String appName;

  /// The identifier for the user associated with this session.
  final String userId;

  /// The current state of the session, stored as a key-value map.
  final Map<String, dynamic> state;

  /// A list of events that have occurred in this session, in chronological order.
  final List<Event> events;

  /// The timestamp of the last update to this session.
  final DateTime lastUpdateTime;

  /// Creates a [Session].
  ///
  /// [id], [appName], and [userId] are required.
  /// [initialState] defaults to an empty map.
  /// [initialEvents] defaults to an empty list.
  /// [lastUpdateTime] defaults to `DateTime.now()`.
  Session({
    required this.id,
    required this.appName,
    required this.userId,
    Map<String, dynamic>? initialState,
    List<Event>? initialEvents,
    DateTime? lastUpdateTime,
  })  : state = initialState ?? {},
        events = initialEvents ?? [],
        lastUpdateTime = lastUpdateTime ?? DateTime.now();
}
