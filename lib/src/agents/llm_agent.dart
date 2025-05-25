import '../events/event.dart';
import '../flows/auto_flow.dart';
import '../flows/base_llm_flow.dart';
import '../flows/single_flow.dart';
import '../models/base_llm.dart';
import '../planners/base_planner.dart';
import '../tools/base_tool.dart';
import 'agent.dart';
import 'invocation_context.dart';

/// LLM-based Agent.
class LlmAgent extends BaseAgent {
  /// The system instruction or prompt for the LLM.
  final String instruction;

  /// The LLM to be used by this agent.
  final BaseLlm model;

  /// Tools available to this agent.
  final List<BaseTool> tools;

  /// Planner for this agent.
  final BasePlanner? planner;

  /// Sub-agents of this agent.
  final List<BaseAgent> subAgents;

  /// Disallows LLM-controlled transferring to the parent agent.
  final bool disallowTransferToParent;

  /// Disallows LLM-controlled transferring to the peer agents.
  final bool disallowTransferToPeers;

  /// Creates an [LlmAgent].
  ///
  /// [name] and [instruction] are required.
  /// [description] is optional.
  LlmAgent({
    required super.name,
    super.description,
    required this.instruction,
    required this.model,
    this.tools = const [],
    this.planner,
    this.subAgents = const [],
    this.disallowTransferToParent = false,
    this.disallowTransferToPeers = false,
  }) {
    for (var subAgent in subAgents) {
      // In a more complete system, parentAgent would be set here.
      // subAgent.parentAgent = this;
    }
  }

  BaseLlmFlow get _llmFlow {
    // Simplified logic from Python ADK:
    // If agent transfer is disallowed to parent and peers, and there are no sub-agents, use SingleFlow.
    // Otherwise, use AutoFlow (which would handle sub-agents and transfers).
    if (disallowTransferToParent &&
        disallowTransferToPeers &&
        subAgents.isEmpty) {
      return SingleFlow(this);
    }
    return AutoFlow(this);
  }

  @override
  Stream<Event> runAsync(InvocationContext context) {
    return _llmFlow.runAsync(context);
  }

  @override
  Stream<Event> runLive(InvocationContext context) {
    // For now, runLive can delegate to runAsync or use a specific live flow.
    // The Python ADK has a more complex distinction.
    // return _llmFlow.runLive(context); // If BaseLlmFlow had runLive
    return runAsync(context); // Simplified for now
  }
}
