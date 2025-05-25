import 'dart:async';

import '../agents/invocation_context.dart';

import '../events/event.dart';
import '../events/event_actions.dart';
import '../models/llm_request.dart';

import '../tools/tool_context.dart';
import 'base_llm_flow.dart';

/// SingleFlow is a basic LLM flow that handles a single turn of interaction
/// with the LLM, including potential tool calls.
class SingleFlow extends BaseLlmFlow {
  SingleFlow(super.agent);

  @override
  Stream<Event> runAsync(InvocationContext context) async* {
    // 1. Prepare LlmRequest
    final history = context.session.events
        .where((event) => event.author == 'user' || event.author == agent.name)
        .toList(); // Simplified history

    final llmRequest = LlmRequest(
      modelName: agent.model.modelName,
      instruction: agent.instruction,
      history: history,
      tools: agent.tools,
      userContent: context.userContent,
    );

    // 2. Call LLM
    await for (final llmResponse
        in agent.model.generateContentAsync(llmRequest)) {
      // 3. Process LlmResponse
      if (llmResponse.functionCalls != null &&
          llmResponse.functionCalls!.isNotEmpty) {
        // Handle function calls
        for (final funcCall in llmResponse.functionCalls!) {
          final tool = agent.tools.firstWhere(
            (t) => t.declaration.name == funcCall.name,
            orElse: () => throw Exception('Tool ${funcCall.name} not found'),
          );

          // Yield the function call event
          yield Event(
            author: agent.name,
            invocationId: context.invocationId,
            content: {
              'function_call': {
                'name': funcCall.name,
                'arguments': funcCall.args,
              }
            },
          );

          final toolContext = ToolContext(invocationContext: context);
          final toolResult = await tool.run(funcCall.args, toolContext);

          // Yield the function response event
          final functionResponseEvent = Event(
            author: agent.name, // Or a special "tool" author
            invocationId: context.invocationId,
            content: {
              'function_response': {
                'name': funcCall.name,
                'response': toolResult,
              }
            },
            actions: toolContext.actions,
          );
          yield functionResponseEvent;

          // Potentially make another LLM call with the tool result
          // This part is simplified; a real flow would construct a new history.
          final subsequentLlmRequest = LlmRequest(
            modelName: agent.model.modelName,
            instruction: agent.instruction,
            history: [
              ...history,
              functionResponseEvent
            ], // Add tool response to history
            tools: agent.tools,
            userContent: {}, // No direct user content for this follow-up
          );

          // Recursive call or loop for summarization / next step
          yield* agent.model
              .generateContentAsync(subsequentLlmRequest)
              .asyncMap((finalLlmResponse) {
            return Event(
              author: agent.name,
              invocationId: context.invocationId,
              content: finalLlmResponse.content ??
                  {'text': 'Error or empty response from LLM after tool call.'},
              actions: EventActions(stateDelta: finalLlmResponse.stateDelta),
            );
          });
        }
      } else if (llmResponse.content != null) {
        // Handle text response
        yield Event(
            author: agent.name,
            invocationId: context.invocationId,
            content: llmResponse.content!,
            actions: EventActions(stateDelta: llmResponse.stateDelta));
      }
    }
  }
}
