import 'package:test/test.dart';
import 'package:flushbar/flushbar.dart';

void main() {
  test('adds one to input values', () {
    final flushbar = new Flushbar(title: "Test", message: "This is a test");
    expect(flushbar.title, isNotNull);
    expect(flushbar.message, isNotNull);
    expect(flushbar.duration, null);
  });
}
