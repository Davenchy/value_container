typedef ValueValidator<T, E> = E? Function(T? value);

/// Separate values and validate them
/// Ease error validation
class ValueContainer<T, E> {
  ValueContainer({
    this.name = 'ValueContainer',
    T? value,
    required ValueValidator<T, E> validator,
  }) {
    _value = value;
    _error = validator(value);
  }

  /// the current container name
  late final String name;

  /// the current container value
  late final T? _value;

  late final E? _error;

  /// returns true if error is null
  bool get isValid => _error == null;

  /// returns true is error is not null
  bool get hasError => !isValid;

  /// returns true if error is null
  bool get hasValue => isValid;

  /// returns the current value
  T get value => _value!;

  /// returns the current error
  E get error => _error!;

  /// returns true if [hasError] and [error] type is [ET]
  bool hasErrorOf<ET>() => hasError && error is ET;

  /// call [callback] if [hasError] and [error] type is [ET]
  void onErrorOf<ET>(void Function(T? value, ET error) callback) {
    if (hasErrorOf<ET>()) callback(value, error as ET);
  }

  /// returns generic value [Type] ([T])
  Type get valueType => T;

  /// returns current [value] runtime type
  Type? get currentValueType => _value?.runtimeType;

  /// returns generic error [Type] ([E])
  Type get errorType => E;

  /// returns current [error] runtime type
  Type? get currentErrorType => _error?.runtimeType;

  @override
  String toString() =>
      '$name(value: $_value, isValid: $isValid, error: $_error)';
}
