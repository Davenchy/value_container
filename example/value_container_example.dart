import 'package:value_container/value_container.dart';

void main() {
  // ----------------- ValueContainer ----------------- //
  final container = ValueContainer<bool, String>(
    name: 'AlwaysTrue',
    value: false,
    validator: (value) => value == true ? null : 'Value must be true',
  );

  // AlwaysTrue(value: false, isValid: false, error: Value must be true)
  print(container);

  // ----------------- EmailAddress ----------------- //

  final emailAddress = EmailAddress('my_email_address');
  // EmailAddress(value: my_email_address, isValid: false, error: Email address must contain @)
  print(emailAddress);

  final emailAddress2 = EmailAddress('john_doe@example.com');
  // EmailAddress(value: john_doe@example.com, isValid: true, error: null)
  print(emailAddress2);

  // ----------------- Password ----------------- //
  final pass = Password();
  // Password(value: null, isValid: false, error: PasswordError(Password is required))
  print(pass);

  final pass2 = Password('123456');
  // Password(value: 123456, isValid: false, error: PasswordError(Password must be at least 8 characters))
  print(pass2);

  final pass3 = Password('12345678');
  // Password(value: 12345678, isValid: true, error: null)
  print(pass3);

  if (pass.hasErrorOf<RequiredPasswordError>()) {
    print('Pass: Password is required');
  }
  // or //
  pass2.onErrorOf<MinimumLengthPasswordError>((password, error) {
    print('pass2: Password is too short');
  });
}

class EmailAddress extends ValueContainer<String, String> {
  EmailAddress([String? email])
      : super(
          name: 'EmailAddress',
          value: email,
          validator: validator,
        );

  static String? validator(String? value) {
    if (value == null || value.isEmpty) return 'Email address is required';

    if (!value.contains('@')) return 'Email address must contain @';

    return null;
  }
}

class PasswordError {
  final String message;

  const PasswordError(this.message);

  @override
  toString() => 'PasswordError($message)';
}

class RequiredPasswordError extends PasswordError {
  const RequiredPasswordError() : super('Password is required');
}

class MinimumLengthPasswordError extends PasswordError {
  const MinimumLengthPasswordError({int length = 6})
      : super('Password must be at least $length characters');
}

class Password extends ValueContainer<String, PasswordError> {
  Password([String? password])
      : super(
          name: 'Password',
          value: password,
          validator: validator,
        );

  static PasswordError? validator(String? value) {
    if (value == null || value.isEmpty) return RequiredPasswordError();

    if (value.length < 8) return MinimumLengthPasswordError(length: 8);

    return null;
  }
}
