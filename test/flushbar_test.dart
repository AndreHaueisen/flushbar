
import 'package:flushbar/flushbar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';


void main() {
  test('test flushbar inicialization', () {
    final flushbar = new Flushbar(title: "Test", message: "This is a test");
    expect(flushbar.title, isNotNull);
    expect(flushbar.message, isNotNull);
    expect(flushbar.duration, null);
    expect(flushbar.backgroundColor, isNotNull);
  });

}
