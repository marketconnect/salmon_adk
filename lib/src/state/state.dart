/// A state management class that maintains a current value and a delta of changes.
/// This is analogous to the State class in the Python ADK, used for tracking
/// changes within contexts like `CallbackContext`.
class State {
  /// Prefix for keys related to application-level state.
  static const String APP_PREFIX = "app:";

  /// Prefix for keys related to user-level state.
  static const String USER_PREFIX = "user:";

  /// Prefix for keys related to temporary or transient state.
  static const String TEMP_PREFIX = "temp:";

  final Map<String, dynamic> _value;
  final Map<String, dynamic> _delta;

  /// Creates a [State] object.
  ///
  /// [initialValue] is the starting state. Defaults to an empty map.
  /// [initialDelta] is the starting delta. Defaults to an empty map.
  State(
      {Map<String, dynamic>? initialValue, Map<String, dynamic>? initialDelta})
      : _value = initialValue ?? {},
        _delta = initialDelta ?? {};

  /// Retrieves a value from the state by [key].
  /// It first checks the delta, then the base value.
  /// Returns `null` if the key is not found or if the stored value is not of type [T].
  T? get<T>(String key) {
    if (_delta.containsKey(key)) {
      return _delta[key] as T?;
    }
    return _value[key] as T?;
  }

  /// Sets a [value] in the state for a given [key].
  /// This updates both the base value and the delta, similar to Python's `State.__setitem__`.
  void set<T>(String key, T value) {
    _value[key] = value;
    _delta[key] = value;
  }

  /// Checks if the state (either base value or delta) contains the [key].
  bool containsKey(String key) {
    return _delta.containsKey(key) || _value.containsKey(key);
  }

  /// Returns `true` if there are pending changes in the delta.
  bool hasDelta() {
    return _delta.isNotEmpty;
  }

  /// Returns an unmodifiable view of the base state values.
  Map<String, dynamic> get value => Map.unmodifiable(_value);

  /// Returns an unmodifiable view of the delta (pending changes).
  Map<String, dynamic> get delta => Map.unmodifiable(_delta);

  /// Returns a new map representing the merged state (base values overridden by delta).
  Map<String, dynamic> toMap() {
    return {..._value, ..._delta};
  }
}
