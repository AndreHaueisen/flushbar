import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class FlushbarHelper {

   /// Get a success notification flushbar.
  static Flushbar createSuccess({@required String title, @required String message, Duration duration = const Duration(seconds: 3)}){
    return  Flushbar()
            ..title = title
            ..message = message
            ..icon = Icon(
              Icons.check_circle,
              color: Colors.green[300],
            )
            ..duration = duration
            ..mainButton = null
            ..userInputForm = null
            ..linearProgressIndicator = null;
  }

  /// Get an information notification flushbar
  static Flushbar createInformation(
      {@required String title, @required String message, Duration duration = const Duration(seconds: 3)}) {
    return Flushbar()
      ..title = title
      ..message = message
      ..icon = Icon(
        Icons.info_outline,
        size: 28.0,
        color: Colors.blue[300],
      )
      ..duration = duration
      ..mainButton = null
      ..userInputForm = null
      ..linearProgressIndicator = null;
  }

  /// Get a error notification flushbar
  static Flushbar createError(
      {@required String title, @required String message, Duration duration = const Duration(seconds: 3)}) {
    return Flushbar()
      ..title = title
      ..message = message
      ..icon = Icon(
        Icons.warning,
        size: 28.0,
        color: Colors.red[300],
      )
      ..duration = duration
      ..mainButton = null
      ..userInputForm = null
      ..linearProgressIndicator = null;
  }

  /// Get a flushbar that can receive a user action through a button.
  static Flushbar createAction(
      {@required String title, @required String message, @required FlatButton button, Duration duration = const Duration(seconds: 3)}) {
    return Flushbar()
      ..title = title
      ..message = message
      ..icon = null
      ..duration = duration
      ..mainButton = button
      ..userInputForm = null
      ..linearProgressIndicator = null;
  }

  /// Get a flushbar that shows the progress of a async computation.
  static Flushbar createLoading(
      {@required String title,
      @required String message,
      @required LinearProgressIndicator linearProgressIndicator,
      Duration duration = const Duration(seconds: 3)}) {
    return Flushbar()
      ..title = title
      ..message = message
      ..icon = Icon(
        Icons.cloud_upload,
        color: Colors.blue[300],
      )
      ..duration = duration
      ..mainButton = null
      ..userInputForm = null
      ..linearProgressIndicator = linearProgressIndicator;
  }

  /// Get a flushbar that shows an user input form.
  static Flushbar getInputFlushbar({@required Form textForm}) {
    return Flushbar()
      ..duration = null
      ..userInputForm = textForm;
  }
}
