import 'dart:math';

import 'event_actions.dart';

String _generateRandomId(int length) {
  const chars =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final random = Random();
  return String.fromCharCodes(Iterable.generate(
      length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
}

/// Represents an event in a conversation or agent interaction.
class Event {
  /// Unique identifier for the event.
  final String id;

  /// Identifier for the invocation that this event is part of. Optional.
  final String? invocationId;

  /// The author of the event (e.g., "user", agent name).
  final String author;

  /// Timestamp of when the event occurred.
  final DateTime timestamp;

  /// The content of the event, represented as a flexible map.
  /// This could include text, function calls, tool responses, etc.
  final Map<String, dynamic> content;

  /// Actions associated with this event, like state changes.
  final EventActions? actions;

  /// Creates an [Event].
  ///
  /// [id] is auto-generated if not provided.
  /// [author] and [content] are required.
  /// [timestamp] defaults to `DateTime.now()` if not provided.
  Event({
    String? id,
    this.invocationId,
    required this.author,
    required this.content,
    DateTime? timestamp,
    this.actions,
  })  : id = id ?? _generateRandomId(8),
        timestamp = timestamp ?? DateTime.now();
}
