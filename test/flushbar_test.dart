import 'package:test/test.dart';
import 'package:flushbar/flushbar.dart';

void main() {
  test('adds one to input values', () {
    final calculator = new Flushbar("Test", "This is a test");
    expect(calculator.duration, null);
  });
}
