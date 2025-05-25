import 'dart:async';
import 'dart:math';

import '../events/event.dart';
import '../state/state.dart';
import 'session.dart';

String _generateRandomSessionId() {
  final random = Random();
  return 'session_${random.nextInt(999999).toString().padLeft(6, '0')}';
}

/// Abstract base class for session services.
/// Defines the contract for managing agent sessions.
abstract class BaseSessionService {
  /// Creates a new session.
  Future<Session> createSession({
    required String appName,
    required String userId,
    String? sessionId,
    Map<String, dynamic>? initialState,
  });

  /// Retrieves an existing session by its ID.
  Future<Session?> getSession({
    required String appName,
    required String userId,
    required String sessionId,
  });

  /// Appends an event to a session and updates its state.
  Future<Session> appendEvent({
    required Session session,
    required Event event,
  });
}

/// An in-memory implementation of [BaseSessionService].
/// Suitable for development, testing, or simple applications.
class InMemorySessionService implements BaseSessionService {
  // Structure: {appName: {userId: {sessionId: Session}}}
  final Map<String, Map<String, Map<String, Session>>> _sessions = {};

  @override
  Future<Session> createSession({
    required String appName,
    required String userId,
    String? sessionId,
    Map<String, dynamic>? initialState,
  }) async {
    final newSessionId = sessionId ?? _generateRandomSessionId();
    final session = Session(
      id: newSessionId,
      appName: appName,
      userId: userId,
      initialState: initialState,
      lastUpdateTime: DateTime.now(),
    );

    _sessions.putIfAbsent(appName, () => {});
    _sessions[appName]!.putIfAbsent(userId, () => {});
    _sessions[appName]![userId]![newSessionId] = session;

    return Future.value(session);
  }

  @override
  Future<Session?> getSession({
    required String appName,
    required String userId,
    required String sessionId,
  }) async {
    return Future.value(_sessions[appName]?[userId]?[sessionId]);
  }

  @override
  Future<Session> appendEvent({
    required Session session,
    required Event event,
  }) async {
    final storedSession =
        _sessions[session.appName]?[session.userId]?[session.id];

    if (storedSession == null) {
      throw Exception(
          'Session not found: ${session.id} for app ${session.appName} and user ${session.userId}');
    }

    // Apply state delta from event actions
    if (event.actions?.stateDelta != null) {
      event.actions!.stateDelta!.forEach((key, value) {
        // In a more complex system, you might distinguish between app, user, and session state prefixes.
        // For this minimalist version, we directly update the session's state.
        if (!key.startsWith(State.TEMP_PREFIX)) {
          storedSession.state[key] = value;
        }
      });
    }

    storedSession.events.add(event);
    final updatedSession = Session(
        id: storedSession.id,
        appName: storedSession.appName,
        userId: storedSession.userId,
        initialState: Map.from(storedSession.state), // Create a copy
        initialEvents: List.from(storedSession.events), // Create a copy
        lastUpdateTime: DateTime.now());

    _sessions[session.appName]![session.userId]![session.id] = updatedSession;
    return Future.value(updatedSession);
  }
}
