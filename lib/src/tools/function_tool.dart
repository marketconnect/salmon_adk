import 'dart:async';
import 'base_tool.dart';
import 'tool_context.dart';

typedef ToolFunction = Future<Map<String, dynamic>> Function(
    Map<String, dynamic> args, ToolContext toolContext);

/// A tool that wraps a Dart function.
class FunctionTool extends BaseTool {
  @override
  final FunctionDeclaration declaration;
  final ToolFunction _function;

  FunctionTool({
    required String name,
    required String description,
    required ParameterSchema parameters,
    required ToolFunction function,
  })  : declaration = FunctionDeclaration(
            name: name, description: description, parameters: parameters),
        _function = function;

  @override
  Future<Map<String, dynamic>> run(
      Map<String, dynamic> args, ToolContext toolContext) {
    return _function(args, toolContext);
  }
}
