/// A minimalist Flutter package for agents, sessions, and state.
library salmon_adk;

export 'src/agents/agent.dart';
export 'src/agents/llm_agent.dart';
export 'src/agents/readonly_context.dart';
export 'src/agents/callback_context.dart';
export 'src/agents/invocation_context.dart';
export 'src/events/event_actions.dart';
export 'src/events/event.dart';
export 'src/sessions/session.dart';
export 'src/sessions/session_service.dart';
export 'src/state/state.dart';
export 'src/models/base_llm.dart';
export 'src/models/llm_request.dart';
export 'src/models/llm_response.dart';
export 'src/models/simulated_llm.dart';
export 'src/models/generic_http_client_llm.dart';
export 'src/flows/base_llm_flow.dart';
export 'src/tools/base_tool.dart';
export 'src/tools/function_tool.dart';

// TODO: Export any libraries intended for clients of this package.
