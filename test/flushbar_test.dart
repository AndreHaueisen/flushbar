import 'package:test/test.dart';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void main() {
  test('adds one to input values', () {
    final calculator = new Flushbar(new Container(), "Test", "This is a test");
    expect(calculator.duration, null);
  });
}
