import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class FlushbarHelper {
  /// Get a success notification flushbar.
  static Flushbar createSuccess(
      {@required String message,
      String title,
      Duration duration = const Duration(seconds: 3)}) {
    return Flushbar(
      title: title,
      message: message,
      icon: Icon(
        Icons.check_circle,
        color: Colors.green[300],
      ),
      leftBarIndicatorColor: Colors.green[300],
      duration: duration,
    );
  }

  /// Get an information notification flushbar
  static Flushbar createInformation(
      {@required String message,
      String title,
      Duration duration = const Duration(seconds: 3)}) {
    return Flushbar(
      title: title,
      message: message,
      icon: Icon(
        Icons.info_outline,
        size: 28.0,
        color: Colors.blue[300],
      ),
      leftBarIndicatorColor: Colors.blue[300],
      duration: duration,
    );
  }

  /// Get a error notification flushbar
  static Flushbar createError(
      {@required String message,
      String title,
      Duration duration = const Duration(seconds: 3)}) {
    return Flushbar(
      title: title,
      message: message,
      icon: Icon(
        Icons.warning,
        size: 28.0,
        color: Colors.red[300],
      ),
      leftBarIndicatorColor: Colors.red[300],
      duration: duration,
    );
  }

  /// Get a flushbar that can receive a user action through a button.
  static Flushbar createAction(
      {@required String message,
      @required FlatButton button,
      String title,
      Duration duration = const Duration(seconds: 3)}) {
    return Flushbar(
      title: title,
      message: message,
      duration: duration,
      mainButton: button,
    );
  }

  // Get a flushbar that shows the progress of a async computation.
  static Flushbar createLoading(
      {@required String message,
      @required LinearProgressIndicator linearProgressIndicator,
      String title,
      Duration duration = const Duration(seconds: 3),
      AnimationController progressIndicatorController,
      Color progressIndicatorBackgroundColor}) {
    return Flushbar(
      title: title,
      message: message,
      icon: Icon(
        Icons.cloud_upload,
        color: Colors.blue[300],
      ),
      duration: duration,
      showProgressIndicator: true,
      progressIndicatorController: progressIndicatorController,
      progressIndicatorBackgroundColor: progressIndicatorBackgroundColor,
    );
  }

  /// Get a flushbar that shows an user input form.
  static Flushbar createInputFlushbar({@required Form textForm}) {
    return Flushbar(
      duration: null,
      userInputForm: textForm,
    );
  }
}
