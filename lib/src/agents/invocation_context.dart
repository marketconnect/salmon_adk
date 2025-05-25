import '../sessions/session.dart';
import 'agent.dart';

/// Represents the context for a single invocation of an agent.
class InvocationContext {
  /// A unique identifier for this specific invocation.
  final String invocationId;

  /// The agent currently being invoked.
  final BaseAgent agent;

  /// The current session.
  final Session session;

  /// The user input or content that triggered this invocation.
  /// Represented as a flexible map.
  final Map<String, dynamic> userContent;

  // TODO: Add services like SessionService, ArtifactService, MemoryService if needed by flows/tools

  /// Creates an [InvocationContext].
  ///
  /// All parameters are required.
  InvocationContext({
    required this.invocationId,
    required this.agent,
    required this.session,
    required this.userContent,
  });
}
