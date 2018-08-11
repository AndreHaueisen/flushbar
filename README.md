# Flushbar

Use this package if you need more customization when notifying your user. For Android developers, it is made to substitute
toasts and snackbars.

See the [install instructions](https://pub.dartlang.org/packages/flushbar#-installing-tab-).

This is a flutter widget inspired by [Flashbar](https://github.com/aritraroy/Flashbar). 
Development of Flushbar and Flashbar are totally separate.

## Getting Started

### A basic Flushbar

The most basic Flushbar uses only a message. Failing to provide it before you call `show()` will result in a runtime error.
`Duration`, if not provided, will create an infinite Flushbar, only dismissible by code, backbutton click, or a drag (case `isDismissible` is set to `true`).

```dart
class YourAwesomeApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YourAwesomeApp',
      home: new Scaffold(
        Container(
          child: Center(
            child: MaterialButton(
              onPressed: (){
                Flushbar()
                  ..title = "Hey Ninja"
                  ..message = "Lorem Ipsum is simply dummy text of the printing and typesetting industry"
                  ..duration = Duration(seconds: 3)
                  ..show(context);
              },
            ),
          ),
        ),
      ),
    );
  }
}
```

![Basic Example](https://github.com/AndreHaueisen/flushbar/blob/master/readme_resources/basic_bar.png)

### Lets get crazy Flushbar

Here is how customized things can get.

```dart
Flushbar(
  title: "Hey Ninja",
  message: "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
  flushbarPosition: FlushbarPosition.TOP, //Immutable
  reverseAnimationCurve: Curves.decelerate, //Immutable
  forwardAnimationCurve: Curves.elasticOut, //Immutable
  backgroundColor: Colors.red,
  shadowColor: Colors.blue[800],
  backgroundGradient: new LinearGradient(colors: [Colors.blu Colors.black]),
  isDismissible: false,
  duration: Duration(seconds: 4),
  icon: Icon(
    Icons.check,
    color: Colors.greenAccent,
  ),
  mainButton: FlatButton(
    onPressed: () {},
    child: Text(
      "CLAP",
      style: TextStyle(color: Colors.amber),
    ),
  ),
  linearProgressIndicator: LinearProgressIndicator(
    backgroundColor: Colors.blueGrey,
  ),
  titleText: new Text(
    "Hello Hero",
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: color: Colors.yellow[600], fontFamily: "ShadowsIntoLightTwo"),
  ),
  messageText: new Text(
    "You killed that giant monster in the city. Congratulations!",
    style: TextStyle(fontSize: 18.0, color: Colors.green[fontFamily: "ShadowsIntoLightTwo"),
  ),
);
```

![Complete Example](https://github.com/AndreHaueisen/flushbar/blob/master/readme_resources/complete_bar.png)

* Note that the properties `flushbarPosition`, `reverseAnimationCurve`, `forwardAnimationCurve` are immutable and have to be set at construction time.
* Don't forget to call `show()` or the bar will stay hidden.
* To deactivate any of those properties, pass `null` to it.

Here is a notation a like to use.

```dart
flushbar
      ..title = "Title"
      ..message = "Message"
      ..titleText = Text()
      ..messageText = Text()
      ..duration = Duration()
      ..icon = Icon()
      ..mainButton = FlatButton()
      ..backgroundColor = Color()
      ..backgroundGradient = LinearGradient()
      ..isDismissible = true
      ..shadowColor = Color()
      ..linearProgressIndicator = LinearProgressIndicator()
      ..onStatusChanged = (status) {}
      ..show(context);
```

### Left indicator bar
Flushbar has a lateral bar to better convey the humor of the notification. To use it, simple give `leftBarIndicatorColor` a color.
* Note that we do not use a `title` in this example as it is not mandatory after version 0.8

```dart
Flushbar()
  ..message = "Lorem Ipsum is simply dummy text of the printing and typesetting industry"
  ..icon = Icon(
    Icons.info_outline,
    size: 28.0,
    color: Colors.blue[300],
    )
  ..duration = Duration(seconds: 3)
  ..leftBarIndicatorColor = Colors.blue[300]
  ..show(context);
```

![Left indicator example](https://github.com/AndreHaueisen/flushbar/blob/master/readme_resources/left_bar_indicator.png)


### Customize your text

If you need a more fancy text, you can create a [Text](https://docs.flutter.io/flutter/widgets/Text-class.html)
and pass it to the `titleText` or `messageText` variables.
* Note that `title` will be ignored if `titleText` is not `null`
* Note that `message` will be ignored if `messageText` is not `null`

```dart
Flushbar()
  ..title = "Hey Ninja" //ignored since titleText != null
  ..message = "Lorem Ipsum is simply dummy text of the printing and typesetting industry" //ignored since messageText != null
  ..titleText = new Text("Hello Hero",
      style:
          TextStyle(fontWeight: FontWeight.bold, fontSize: color: Colors.yellow[600], fontFa"ShadowsIntoLightTwo"))
  ..messageText = new Text("You killed that giant monster in the city. Congratulations!",
      style: TextStyle(fontSize: 16.0, color: Colors.green[fontFamily: "ShadowsIntoLightTwo"))
  ..show(context);
```

![Customized Text](https://github.com/AndreHaueisen/flushbar/blob/master/readme_resources/text_bar.png)

### Customize background and shadow

You can paint the background with any color you want. The same goes for shadows.
`shadow` won't show by default. You will only see a shadow if you specify a color.

```dart
Flushbar()
  ..title = "Hey Ninja"
  ..message = "Lorem Ipsum is simply dummy text of the printing and typesetting industry"
  ..backgroundColor = Colors.red
  ..shadowColor = Colors.red[800]
  ..show(context);
```

![Background and Shadow](https://github.com/AndreHaueisen/flushbar/blob/master/readme_resources/background_color_bar.png)

Want a gradient in the background? No problem.
* Note that `backgroundColor` will be ignored while `backgroundGradient` is not `null`

```dart
Flushbar()
  ..title = "Hey Ninja"
  ..message = "Lorem Ipsum is simply dummy text of the printing and typesetting industry"
  ..backgroundGradient = new LinearGradient(colors: [Colors.Colors.teal])
  ..backgroundColor = Colors.red
  ..shadowColor = Colors.blue[800]
  ..show(context);
```

![Background Gradient](https://github.com/AndreHaueisen/flushbar/blob/master/readme_resources/gradient_bar.png)

### Icon and button action

Let us put a Icon that has a `PulseAnimation`. Icons have this animation by default and cannot be changed as of this moment.
Also, let us put a button. Have you noticed that `show()` returns a `Future`?
This Future will yield a value when you call `dismiss([T result])`.
I recomment that you specify the `result` generic type if you intend to collect an user input.

```dart
Flushbar flush;
bool _wasAddClicked;
```

```dart
@override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: MaterialButton(
          onPressed: () {
            flush = Flushbar<bool>() // <bool> is the type of the result passed to dismiss() and collected by show().then((result){})
              ..title = "Hey Ninja"
              ..message = "Lorem Ipsum is simply dummy text of the printing and typesetting industry"
              ..icon = Icon(
                Icons.info_outline,
                color: Colors.blue,
              )
              ..mainButton = FlatButton(
                onPressed: () {
                  flush.dismiss(true); // result = true
                },
                child: Text(
                  "ADD",
                  style: TextStyle(color: Colors.amber),
                ),
              )
              ..show(context).then((result) {
                setState(() { // setState() is optional here
                  _wasAddClicked = result;
                });
              });
          },
        ),
      ),
    );
  }
```

![Icon and Button](https://github.com/AndreHaueisen/flushbar/blob/master/readme_resources/icon_and_button_bar.png)

### Flushbar position

Flushbar can be at `FlushbarPosition.BOTTOM` or `FlushbarPosition.TOP`.
* This variable is immutable and can not be changed after the instance is created.

```dart
Flushbar(flushbarPosition: FlushbarPosition.TOP)
  ..title = "Hey Ninja"
  ..message = "Lorem Ipsum is simply dummy text of the printing and typesetting industry"
  ..show(context);
```

![Bar position](https://github.com/AndreHaueisen/flushbar/blob/master/readme_resources/position_bar.png)

### Duration and dismiss policy

By default, Flushbar is infinite. To set a duration, use the `duration` property.
By default, Flushbar is dismissible by the user. A right or left drag will dismiss it.
Use the `isDismissible` to change it.

```dart
Flushbar()
  ..title = "Hey Ninja"
  ..message = "Lorem Ipsum is simply dummy text of the printing and typesetting industry"
  ..duration = Duration(seconds: 3)
  ..isDismissible = false
  ..show(context);
```

//TODO add gif

### Progress Indicator

If you are loading something, use a [LinearProgressIndicator](https://docs.flutter.io/flutter/material/LinearProgressIndicator-class.html)
If you want an undetermined progress indicator, do not set `progressIndicatorController`.
If ou want a determined progress indicator, you now have full controll over the progress since you own the `AnimationController`
* There is not need to add a listener to your controller just to call `setState(){}`. Once you pass in your controller, `Flushbar` will do this automatically. Just make sure you call `_controller.forward()`

```dart

AnimationController _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

Flushbar()
  ..title = "Hey Ninja"
  ..message = "Lorem Ipsum is simply dummy text of the printing and typesetting industry"
  ..showProgressIndicator = true,
  ..progressIndicatorController = _controller,
  ..progressIndicatorBackgroundColor = Colors.grey[800],
  ..show(context);
```

//TODO add gif

### Show and dismiss animation curves

You can set custom animation curves using `forwardAnimationCurve` and `reverseAnimationCurve`.
* These properties are immutable

```dart
Flushbar(
  forwardAnimationCurve: Curves.decelerate,
  reverseAnimationCurve: Curves.easeOut,
)
  ..title = "Hey Ninja"
  ..message = "Lorem Ipsum is simply dummy text of the printing and typesetting industry"
  ..show(context);
```

//TODO add gif

### Listen to status updates

You can listen to status update using the `onStatusChanged` property. 
* Note that when you pass a new listener using `onStatusChanged`, it will activate once immediately so you can check in what state the Flushbar is.

```dart

Flushbar flushbar = Flushbar(title: "Hey Ninja", message: "Lorem Ipsum is simply dummy text of the printing and typesetting industry");

  flushbar
    ..onStatusChanged = (FlushbarStatus status) {
      switch (status) {
        case FlushbarStatus.SHOWING:
          {
            doSomething();
            break;
          }
        case FlushbarStatus.IS_APPEARING:
          {
            doSomethingElse();
            break;
          }
        case FlushbarStatus.IS_HIDING:
          {
            doSomethingElse();
            break;
          }
        case FlushbarStatus.DISMISSED:
          {
            doSomethingElse();
            break;
          }
      }
    }
    ..show(context);

```

### Input text

Sometimes we just want a simple user input. Use the property`userInputForm`.
* Note that buttons, messages, and icons will be ignored if `userInputForm != null`
* `dismiss(result)` will yield result. `dismiss()` will yield null.

```dart
Flushbar<List<String>> flush;
final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
TextEditingController _controller1 = TextEditingController(text: "Initial Value");
TextEditingController _controller2 = TextEditingController(text: "Initial Value Two");
```

```dart
flush = Flushbar<List<String>>()
      ..userInputForm = Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            TextFormField(
              controller: _controller1,
              onFieldSubmitted: (String value) {},
            ),
            TextFormField(
              controller: _controller2,
              onFieldSubmitted: (String value) {},
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: MaterialButton(
                  textColor: Colors.amberAccent,
                  child: Text("SUBMIT"),
                  onPressed: () {
                    flush.dismiss([_controller1.value.text, _controller2.value.text]);
                  },
                ),
              ),
            )
          ]))
      ..show(context).then((result) {
        if (result != null) {
          String userInput1 = result[0];
          String userInput2 = result[1];
        }
      });
```

![Bar input](https://github.com/AndreHaueisen/flushbar/blob/master/readme_resources/input_bar.png)

This example tries to mimic the [Material Design style guide](https://material.io/design/components/text-fields.html#anatomy)
This is the `TextFormField` customization omitted from the example above for simplicity:
```dart
TextFormField(
  initialValue: "Initial Value",
  style: TextStyle(color: Colors.white),
  maxLength: 100,
  maxLines: 1,
  maxLengthEnforced: true,
  decoration: InputDecoration(
      fillColor: Colors.white10,
      filled: true,
      icon: Icon(
        Icons.label,
        color: Colors.grey[500],
      ),
      border: UnderlineInputBorder(),
      helperText: "Helper Text",
      helperStyle: TextStyle(color: Colors.grey),
      labelText: "Label Text",
      labelStyle: TextStyle(color: Colors.grey)),
)
```

## Flushbar Helper

I made a helper class to facilitate the creation of the most common Flushbars.

```dart
FlushbarHelper.createSuccess({message, title, duration});
FlushbarHelper.createInformation({message, title, duration});
FlushbarHelper.createError({message, title, duration});
FlushbarHelper.createAction({message, title, duration flatButton});
FlushbarHelper.createLoading({message,linearProgressIndicator, title, duration, progressIndicatorController, progressIndicatorBackgroundColor});
FlushbarHelper.createInputFlushbar({textForm});
```

## Give me a hand?

<a href="https://www.buymeacoffee.com/AndreHaueisen" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: auto !important;width: auto !important;" ></a>