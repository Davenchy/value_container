# ValueContainer

ValueContainer is a package that will help you to separate values and validate each value on its own

## Usage

Use `ValueContainer` class on its own

This validator will always return `Value must be true` error message if value is not __true__

```dart
final container = ValueContainer<bool, String>(
    name: 'AlwaysTrue',
    value: false,
    validator: (value) => value == true ? null : 'Value must be true',
  );

  print(container);
```

results:

```text
AlwaysTrue(value: false, isValid: false, error: Value must be true)
```

____

### Extend ValueContainer

You can create your own value container too

```dart
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
```

now lets create an invalid instance of it

```dart
  final emailAddress = EmailAddress('my_email_address');
  print(emailAddress);

```

results:

```text
EmailAddress(value: my_email_address, isValid: false, error: Email address must contain @)
```

now lets crate a valid instance of it

```dart
  final emailAddress = EmailAddress('john_doe@example.com');
  print(emailAddress);

```

results:

```text
EmailAddress(value: john_doe@example.com, isValid: true, error: null)
```

____

### Typed Errors ValueContainer

Lets define an __Abstract Class__ called `PasswordError` and use it as error type

```dart
class PasswordError {
  final String message;

  const PasswordError(this.message);

  @override
  toString() => 'PasswordError($message)';
}
```

Lets create our error classes

```dart
class RequiredPasswordError extends PasswordError {
  const RequiredPasswordError() : super('Password is required');
}

class MinimumLengthPasswordError extends PasswordError {
  const MinimumLengthPasswordError({int length = 6})
      : super('Password must be at least $length characters');
}
```

lets create our custom __ValueContainer__

```dart
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
```

____

Now lets use our custom value container

```dart
final pass = Password();
  print(pass);

  final pass2 = Password('123456');
  print(pass2);

  final pass3 = Password('12345678');
  print(pass3);

  if (pass.hasErrorOf<RequiredPasswordError>()) {
    print('Pass: Password is required');
  }
  // or //
  pass2.onErrorOf<MinimumLengthPasswordError>((password, error) {
    print('pass2: Password is too short');
  });
```

results:

```text
Password(value: null, isValid: false, error: PasswordError(Password is required))
Password(value: 123456, isValid: false, error: PasswordError(Password must be at least 8 characters))
Password(value: 12345678, isValid: true, error: null)

Pass: Password is required
pass2: Password is too short
```
