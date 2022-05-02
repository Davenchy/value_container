import 'package:value_container/value_container.dart';
import 'package:test/test.dart';

void main() {
  group('Invalid Value Container', () {
    final container = ValueContainer<bool, String>(
      name: 'AlwaysTrue',
      value: false,
      validator: (value) => value == true ? null : 'Value must be true',
    );
    print(container);

    test('should not be valid', () {
      expect(container.isValid, isFalse);
    });

    test('should has error', () {
      expect(container.hasError, isTrue);
    });

    test('should not has value', () {
      expect(container.hasValue, isFalse);
    });

    test('error should be String', () {
      expect(container.currentErrorType, String);
    });

    test('value should be bool', () {
      expect(container.currentValueType, bool);
    });
  });

  group('Valid Value Container', () {
    final container = ValueContainer<bool, String>(
      name: 'AlwaysTrue',
      value: true,
      validator: (value) => value == true ? null : 'Value must be true',
    );
    print(container);

    test('should be valid', () {
      expect(container.isValid, isTrue);
    });

    test('should not has error', () {
      expect(container.hasError, isFalse);
    });

    test('should has value', () {
      expect(container.hasValue, isTrue);
    });

    test('error should be Null', () {
      expect(container.currentErrorType, isNull);
    });

    test('value should be bool', () {
      expect(container.currentValueType, bool);
    });

    test('current value should be true', () {
      expect(container.value, isTrue);
    });
  });

  group('Typed Error Container Value (Error1)', () {
    final container = MyContainer();
    print(container);

    test('should not be valid', () {
      expect(container.isValid, isFalse);
    });

    test('should has error', () {
      expect(container.hasError, isTrue);
    });

    test('error generic type should be MyError', () {
      expect(container.errorType, MyError);
    });

    test('current error type should be Error1', () {
      expect(container.currentErrorType, Error1);
    });

    test('current value type should be null', () {
      expect(container.currentValueType, isNull);
    });
  });

  group('Typed Error Container Value (Error2)', () {
    final container = MyContainer(0);
    print(container);

    test('should not be valid', () {
      expect(container.isValid, isFalse);
    });

    test('should has error', () {
      expect(container.hasError, isTrue);
    });

    test('error generic type should be MyError', () {
      expect(container.errorType, MyError);
    });

    test('current error type should be Error2', () {
      expect(container.currentErrorType, Error2);
    });

    test('current value type should be null', () {
      expect(container.currentValueType, int);
    });
  });

  group('Typed Error Container Value [valid]', () {
    final container = MyContainer(1);
    print(container);

    test('should be valid', () {
      expect(container.isValid, isTrue);
    });

    test('should not has error', () {
      expect(container.hasError, isFalse);
    });

    test('current error type should be Null', () {
      expect(container.currentErrorType, isNull);
    });

    test('value should be int', () {
      expect(container.valueType, int);
    });

    test('current value type should be int', () {
      expect(container.currentValueType, int);
    });
  });
}

class MyContainer extends ValueContainer<int, MyError> {
  MyContainer([int? value])
      : super(
          name: 'MyContainer',
          value: value,
          validator: validator,
        );

  static MyError? validator(int? value) {
    if (value == null) return Error1();
    if (value <= 0) return Error2();
    return null;
  }
}

abstract class MyError {}

class Error1 extends MyError {}

class Error2 extends MyError {}
