import '../agents/invocation_context.dart';
import '../events/event.dart';
import 'single_flow.dart';

/// AutoFlow is SingleFlow with potential agent transfer capability.
/// In a full implementation, this flow would handle routing to sub-agents
/// or parent/peer agents based on LLM decisions or tool outputs.
class AutoFlow extends SingleFlow {
  AutoFlow(super.agent);

  @override
  Stream<Event> runAsync(InvocationContext context) async* {
    // For now, AutoFlow behaves like SingleFlow.
    // A more complete implementation would:
    // 1. Potentially use tools that suggest agent transfer.
    // 2. If a transfer is suggested (e.g., via EventActions.transferToAgent),
    //    find the target agent and delegate `context.agent.runAsync(newContext)` to it.
    // 3. Handle the response from the delegated agent.

    yield* super.runAsync(context);
  }
}
