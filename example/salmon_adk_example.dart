import 'package:salmon_adk/salmon_adk.dart';

Future<void> main() async {
  // 1. Initialize the Session Service
  final sessionService = InMemorySessionService();

  // 2. Create or get a session
  final appName = 'my_llm_app';
  final userId = 'user123';
  var session = await sessionService.createSession(
    appName: appName,
    userId: userId,
    initialState: {'greeting': 'Initial Greeting!'},
  );
  print('Initial Session ID: ${session.id}');
  print('Initial Session State: ${session.state}');

  // 3. Instantiate a real LLM (using GenericHttpClientLlm as an example) and an Agent
  // IMPORTANT: Replace with your actual API URL and Key.
  // The request/response format in GenericHttpClientLlm is a basic example
  // and might need adjustments for your specific LLM provider.
  // For this example, we'll revert to SimulatedLlm as API keys shouldn't be in source.
  // final llm = GenericHttpClientLlm(
  //   modelName: 'your-model-name',
  //   apiUrl: 'YOUR_LLM_API_ENDPOINT_URL',
  //   apiKey: 'YOUR_API_KEY',
  // );
  final llm = GenericHttpClientLlm(
    modelName: 'simulated-model', // Using simulated for example
    apiUrl: 'http://localhost/simulated', // Dummy URL
    apiKey: 'SIMULATED_API_KEY', // Dummy key
  );
  final agent = LlmAgent(
    name: 'RealAssistant',
    instruction: 'You are a helpful assistant. Always be polite and concise.',
    model: llm,
    // Example of how tools might be added in the future
    // tools: [
    //   FunctionTool(name: 'get_weather', description: 'Gets the current weather', function: (args, context) async => {'temperature': '22C'})
    // ],
  );

  // 4. Simulate a user input and create an InvocationContext
  final userInput = <String, dynamic>{
    'text': 'What is the capital of France? Answer in russian',
    'invocationId': 'inv_001',
  };

  // User event
  final userEvent = Event(
      author: 'user',
      content: userInput,
      invocationId: userInput['invocationId'] as String?);
  session =
      await sessionService.appendEvent(session: session, event: userEvent);

  final invocationContext = InvocationContext(
    invocationId: userInput['invocationId'] as String,
    agent: agent,
    session: session, // Pass the whole session
    userContent: userInput,
  );

  // 5. Run the agent
  print('\nRunning ${agent.name}...');
  await for (final agentEvent in agent.runAsync(invocationContext)) {
    print('Agent event from ${agentEvent.author}: ${agentEvent.content}');

    // 6. Append agent events to the session (this will also update session state)
    session =
        await sessionService.appendEvent(session: session, event: agentEvent);
  }

  // 7. Check the updated session
  final updatedSession = await sessionService.getSession(
      appName: appName, userId: userId, sessionId: session.id);
  print('\nUpdated Session State: ${updatedSession?.state}');
  print('All Session Events:');
  updatedSession?.events.forEach((e) => print(
      '  - [${e.author} at ${e.timestamp}]: ${e.content} (Actions: ${e.actions?.stateDelta})'));
}
