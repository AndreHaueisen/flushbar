import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

/// This is just a suggestion of a helper class. Fell free  to to use your own.
/// Notice that [null] is used when we need to deactivate a feature.
/// Don't forget to call commitChanges() outside this class.
class FlushbarMorph {
  /// Morph flushbar into a success notification.
  static Flushbar morphIntoSuccess(Flushbar flushbar,
      {@required String title, @required String message, Duration duration = const Duration(seconds: 3)}) {
    return flushbar
      ..title = title
      ..message = message
      ..icon = Icon(
        Icons.check_circle,
        size: 28.0,
        color: Colors.green,
      )
      ..duration = duration
      ..mainButton = null
      ..linearProgressIndicator = null
      ..userInputForm = null;
  }

  /// Morph flushbar into a information notification.
  static Flushbar morphIntoInfo(Flushbar flushbar,
      {@required String title, @required String message, Duration duration = const Duration(seconds: 3)}) {
    return flushbar
      ..title = title
      ..message = message
      ..icon = Icon(
        Icons.info_outline,
        size: 28.0,
        color: Colors.blue,
      )
      ..duration = duration
      ..mainButton = null
      ..linearProgressIndicator = null
      ..userInputForm = null;
  }

  /// Morph flushbar into a error notification.
  static Flushbar morphIntoError(Flushbar flushbar,
      {@required String title, @required String message, Duration duration = const Duration(seconds: 3)}) {
    return flushbar
      ..title = title
      ..message = message
      ..icon = Icon(
        Icons.warning,
        size: 28.0,
        color: Colors.red,
      )
      ..duration = duration
      ..mainButton = null
      ..linearProgressIndicator = null
      ..userInputForm = null;
  }

  /// Morph flushbar into a notification that can receive a user action through a button.
  static Flushbar morphIntoAction(Flushbar flushbar,
      {@required String title,
        @required String message,
        @required FlatButton button,
        Duration duration = const Duration(seconds: 3)}) {
    return flushbar
      ..title = title
      ..message = message
      ..icon = null
      ..duration = duration
      ..mainButton = button
      ..linearProgressIndicator = null
      ..userInputForm = null;
  }

  /// Morph flushbar into a notification that shows the progress of a async computation.
  static Flushbar morphIntoLoading(Flushbar flushbar,
      {@required String title,
        @required String message,
        @required LinearProgressIndicator linearProgressIndicator,
        Duration duration = const Duration(seconds: 3)}) {
    return flushbar
      ..title = title
      ..message = message
      ..icon = Icon(
        Icons.cloud_upload,
        size: 28.0,
        color: Colors.blue,
      )
      ..duration = duration
      ..mainButton = null
      ..linearProgressIndicator = linearProgressIndicator
      ..userInputForm = null;
  }
}
