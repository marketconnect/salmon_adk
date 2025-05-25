import 'dart:async';
import 'tool_context.dart';

/// Represents the schema for a tool's parameters.
class ParameterSchema {
  final String type; // e.g., "object", "string", "number"
  final Map<String, ParameterSchema>? properties; // For object type
  final List<String>? required; // For object type
  final String? description;

  ParameterSchema({
    required this.type,
    this.properties,
    this.required,
    this.description,
  });
}

/// Represents the declaration of a function tool for an LLM.
class FunctionDeclaration {
  final String name;
  final String description;
  final ParameterSchema parameters;

  FunctionDeclaration(
      {required this.name,
      required this.description,
      required this.parameters});
}

/// Abstract base class for all tools.
abstract class BaseTool {
  FunctionDeclaration get declaration;

  Future<Map<String, dynamic>> run(
      Map<String, dynamic> args, ToolContext toolContext);
}
