import '../agents/llm_agent.dart';
import '../agents/invocation_context.dart';
import '../events/event.dart';

/// Abstract base class for LLM interaction flows.
/// An LLM flow defines the sequence of operations for an LlmAgent
/// to process input, interact with an LLM (and potentially tools),
/// and produce output events.
abstract class BaseLlmFlow {
  final LlmAgent agent;

  BaseLlmFlow(this.agent);

  Stream<Event> runAsync(InvocationContext context);
}
