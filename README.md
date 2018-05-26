# Flushbar

This is a flutter widget inspired by [Flashbar](https://github.com/aritraroy/Flashbar). Use this package if you need
more customization when notifying your user. For Android developers, it is made to substitute
toasts and snackbars.
Development of Flushbar and [Flashbar](https://github.com/aritraroy/Flashbar) are totally separate.
Although they look like each other, they work very differently. See the examples bellow.

## Getting Started

Since Flushbar is an offscreen widget, I made it to be wrapped 
in a [Stack](https://docs.flutter.io/flutter/widgets/Stack-class.html).
Make sure Flushbar is the last child in the Stack.

### A basic Flushbar

The most basic Flushbar needs a title and a message. Keep a reference to
the it. You are going to need it latter.

```dart
class YourAwesomeApp extends StatelessWidget {

  Flushbar flushbar = new Flushbar(
    "Hey Ninja", //title
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", //message
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YourAwesomeApp',
      home: new Scaffold(
        body: Stack(
          children: <Widget>[YourMainScreenWidget(), flushbar],
        ),
      ),
    );
  }
}
```
![Basic Example](https://github.com/AndreHaueisen/flushbar/blob/master/readme_resources/basic_bar.png)


### Customize your text

If you need a more fancy text, you can create a [Text](https://docs.flutter.io/flutter/widgets/Text-class.html)
and pass it to the `titleText` or `messageText` variables.
* Note that `title` will be ignored if `titleText` is used
* Note that `message` will be ignored if `messageText` is used

```dart
Flushbar flushbar = new Flushbar(
    "Hey Ninja", //title
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry", //message
    titleText: new Text(
      "Hello Hero",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16.0,
        color: Colors.yellow[600],
        fontFamily: "Raleway"),
    ),
    messageText: new Text(
      "Dummy text just because I have zero creativity going on right now",
      style: TextStyle(
        color: Colors.green[600],
        fontFamily: "Raleway"),
    ),
  );
```

If you already have a Flushbar instance, you can use `changeTitleText` and `changeMessageText`.
* Remember to call `commitChanges()` after you finish making changes.

```dart
flushbar
  .changeTitleText(titleText)
  .changeMessageText(messageText)
  .commitChanges();
```

![Customized Text](https://github.com/AndreHaueisen/flushbar/blob/master/readme_resources/text_bar.png)

### Customize background and shadow

You can paint the background with any color you want. The same goes for shadows.
`shadow` won't show by default. You will only see a shadow if you specify a color.

```dart
Flushbar flushbar = new Flushbar(
    "Hey Ninja", //title
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
    backgroundColor: Colors.red,
    shadowColor: Colors.red[800],
  );
```

Want a gradient in the background? No problem.
* Note that `backgroundColor` will be ignored while `backgroundGradient` is not null

```dart
Flushbar flushbar = new Flushbar(
  "Hey Ninja", //title
  "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
  backgroundGradient: new LinearGradient(colors: [Colors.blue, Colors.teal]),
  backgroundColor: Colors.red,
  shadowColor: Colors.blue[800],
  );
```

![Background and Shadow](https://github.com/AndreHaueisen/flushbar/blob/master/readme_resources/background_color_bar.png)

You can also change these properties using `changeBackgroundColor()`,
`changeShadowColor()`, and `changeBackgroundGradient()`

```dart
flushbar
  .changeBackgroundColor(backgroundColor)
  .changeBackgroundGradient(backgroundGradient)
  .changeShadowColor(shadowColor)
  .commitChanges();
```

![Background Gradient](https://github.com/AndreHaueisen/flushbar/blob/master/readme_resources/gradient_bar.png)

### Icon and button action

Lets put a Icon that has a `PulseAnimation`. Icons have this animation by default
and cannot be changed as of this moment.
* You can use `changeMainButton()` and `changeIcon()` once you have an instance.

```dart
Flushbar flushbar = new Flushbar(
  "Hey Ninja", //title
  "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
  icon: Icon(
    Icons.info_outline,
    color: Colors.blue,
  ),
  mainButton: FlatButton(
    onPressed: () {},
    child: Text("ADD", style: TextStyle(color: Colors.amber),),
  ),
);
```

![Icon and Button](https://github.com/AndreHaueisen/flushbar/blob/master/readme_resources/icon_and_button_bar.png)

Icon can be at the `IconPosition.START` or at the `IconPosition.END` of the bar. Use `iconPosition`.

```dart
Flushbar flushbar = new Flushbar(
  "Hey Ninja", //title
  "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
  iconPosition: IconPosition.END,
  icon: Icon(
    Icons.info_outline,
    color: Colors.blue,
  ),
  mainButton: FlatButton(
    onPressed: () {},
    child: Text("ADD", style: TextStyle(color: Colors.amber),),
  ),
);
```

![Icon position](https://github.com/AndreHaueisen/flushbar/blob/master/readme_resources/icon_position_bar.png)

### Flushbar position

Flushbar can be at `FlushbarPosition.BOTTOM` or `FlushbarPosition.TOP`.
* This variable is immutable and can not be changed after the bar is created.

```dart
Flushbar flushbar = new Flushbar(
  "Hey Ninja", //title
  "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
  flushbarPosition: FlushbarPosition.TOP,
);
```

![Bar position](https://github.com/AndreHaueisen/flushbar/blob/master/readme_resources/position_bar.png)

### Duration and dismiss policy

By default, Flushbar is infinite. To set a duration, use `duration` or `changeDuration()`.
By default, Flushbar is dismissible by the user. A right or left scroll will dismiss it.
Use `isDismissible` or `changeIsDismissible()` to change it.

```dart
Flushbar flushbar = new Flushbar(
  "Hey Ninja", //title
  "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
  duration: Duration(seconds: 3),
  isDismissible: false,
);
```

### Progress Indicator

If you are loading something, use a [LinearProgressIndicator](https://docs.flutter.io/flutter/material/LinearProgressIndicator-class.html)

```dart
Flushbar flushbar = new Flushbar(
  "Hey Ninja", //title
  "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
  linearProgressIndicator: new LinearProgressIndicator(backgroundColor: Colors.grey[800],),
);
```

//TODO add gif

### Show and dismiss animation curves

You can set custom animation curves using `forwardAnimationCurve` and `reverseAnimationCurve`.
* These properties are immutable

```dart
Flushbar flushbar = new Flushbar(
  "Hey Ninja", //title
  "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
  forwardAnimationCurve: Curves.decelerate,
  reverseAnimationCurve: Curves.easeOut,
);
```

//TODO add gif

### Listen to status updates

You can listen to status update using `onStatusChanged`. If you need to reconfigure the listener,
use the `changeStatusListener()` method.
* Note that when you pass a new listener using `changeStatusListener()`, it will activate immediately
so you can check in what state the Flushbar is.

```dart
Flushbar flushbar = new Flushbar(
  "Hey Ninja", //title
  "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
  onStatusChanged: (FlushbarStatus status){
    if(status == FlushbarStatus.DISMISSED){
      doSomething();
    }
  },
);
```

## Usage Sample

Since you are probably going to control your Flushbar from `YourMainScreenWidget()`, pass it as an argument.
For consistency, use methods to alternate between you flushbar status.

```dart
class YourAwesomeApp extends StatelessWidget {

  Flushbar flushbar = new Flushbar(
    "Hey Ninja", //title
    "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", //message
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YourAwesomeApp',
      home: new Scaffold(
        body: Stack(
          children: <Widget>[YourMainScreenWidget(flushbar), flushbar],
        ),
      ),
    );
  }
}
```

```dart

class YourMainScreenWidget extends StatelessWdiget {
  
  YourMainScreenWidget(this.flushbar);
  
  Flushbar flushbar;
  
  void changeToInfoFlushbar(String title, String message) {
      flushbar
          .changeTitle(title)
          .changeMessage(message)
          .changeDuration(Duration(seconds: 3))
          .changeIcon(Icon(
            Icons.info_outline,
            color: Colors.amber,
          ))
          .changeStatusListener(
            (FlushbarStatus status) {
              talkLikeAFox();
            },
         ).commitChanges();
  }
  
  void changeToConfirmFlushbar(String title, String message) {
      flushbar
          .changeTitle(title)
          .changeMessage(message)
          .changeDuration(Duration(seconds: 3))
          .changeIcon(Icon(
            Icons.check,
            color: Colors.green,
          ))
          .changeStatusListener(
        (FlushbarStatus status) {
          if (status == FlushbarStatus.DISMISSED) {
            runLikeASnail();
          }
        },
      ).commitChanges();
  }
  
  void changeToErrorFlushbar(String title, String message) {
      flushbar
          .changeTitle(title)
          .changeMessage(message)
          .changeDuration(Duration(seconds: 3))
          .changeIcon(Icon(
            Icons.error,
            color: Colors.red,
          ))
          .changeStatusListener(null)
          .commitChanges();
    }
  
  void changeToLoadingFlushbar(String title, String message) {
      flushbar
          .changeTitle(title)
          .changeMessage(message)
          .changeDuration(null)
          .changeIcon(Icon(
            Icons.cloud_upload,
            color: Colors.orange,
            ),
          )
          .changeLinearProgressIndicator(new LinearProgressIndicator(
            backgroundColor: Color(0xFF303030),
          ),
            )
          .commitChanges();
  }
}
```