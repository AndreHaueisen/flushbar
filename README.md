# Flushbar

Use this package if you need more customization when notifying your user. For Android developers, it is made to substitute
toasts and snackbars. IOS developers, I don't know what you use there, but you will like it

See the [install instructions](https://pub.dartlang.org/packages/flushbar#-installing-tab-).

This is a flutter widget inspired by [Flashbar](https://github.com/aritraroy/Flashbar).
Development of Flushbar and Flashbar are totally separate.

![Flushbar](https://github.com/AndreHaueisen/flushbar/blob/master/readme_resources/flushbar_logo.png)

## **IMPORTANT**

Flushbar works by pushing a new route on top of the existing ones. For it to work as intended, make sure there is no route on top of the Flushbar you want to dismiss. To help you accomplish that, you have two options. First, a listener that you can subscribe to that will notify you when it changed state, including when it reaches the `DISMISSED` state. Second, the function `dismiss()` yields a Future that completes only when Flushbar is `DISMISSED`. Choose your pick.

- Dismissing a Flushbar that is not the top route will have the following effects:
 1. It does not animate back. It simply vanishes.
 2. FlushbarStatus listener will not register `FlushbarStatus.IS_HIDING` or `FlushbarStatus.DISMISSED`
 3. It returns no value when the Future yield by `dismiss()` completes.

## Getting Started

### The possibilities

![Flushbar Animated](https://github.com/AndreHaueisen/flushbar/blob/master/readme_resources/flushbar_animated.gif)

### A basic Flushbar

The most basic Flushbar uses only a message. Failing to provide it before you call `show()` will result in a runtime error.
`Duration`, if not provided, will create an infinite Flushbar, only dismissible by code, back button clicks, or a drag (case `isDismissible` is set to `true`).

- Note that only `message` is a required parameter. All the other ones are optional

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
      backgroundGradient: new LinearGradient(colors: [Colors.blueGrey, Colors.black]),
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
      showProgressIndicator: true,
      progressIndicatorBackgroundColor: Colors.blueGrey,
      titleText: new Text(
        "Hello Hero",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.yellow[600], fontFamily: "ShadowsIntoLightTwo"),
      ),
      messageText: new Text(
        "You killed that giant monster in the city. Congratulations!",
        style: TextStyle(fontSize: 18.0, color: Colors.green, fontFamily: "ShadowsIntoLightTwo"),
      ),
    );
```

![Complete Example](https://github.com/AndreHaueisen/flushbar/blob/master/readme_resources/complete_bar.png)

- Note that the properties `flushbarPosition`, `reverseAnimationCurve`, `forwardAnimationCurve` are immutable and have to be set at construction time.
- Don't forget to call `show()` or the bar will stay hidden.
- To deactivate any of those properties, pass `null` to it.

Here is a notation I like to use.

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
      ..showProgressIndicator = true,
      ..progressIndicatorBackgroundColor = Colors.blueGrey,
      ..onStatusChanged = (status) {}
      ..show(context);
```

### Left indicator bar

Flushbar has a lateral bar to better convey the humor of the notification. To use it, simple give `leftBarIndicatorColor` a color.

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

- Note that `title` will be ignored if `titleText` is not `null`
- Note that `message` will be ignored if `messageText` is not `null`

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

- Note that `backgroundColor` will be ignored while `backgroundGradient` is not `null`

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
I recommend that you specify the `result` generic type if you intend to collect an user input.

```dart
Flushbar flush;
bool _wasButtonClicked;
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
                  _wasButtonClicked = result;
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

- This variable is immutable and can not be changed after the instance is created.

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
Set `isDismissible` to `false` to change this behaviour.

```dart
Flushbar()
  ..title = "Hey Ninja"
  ..message = "Lorem Ipsum is simply dummy text of the printing and typesetting industry"
  ..duration = Duration(seconds: 3)
  ..isDismissible = false
  ..show(context);
```

### Progress Indicator

If you are loading something, use a [LinearProgressIndicator](https://docs.flutter.io/flutter/material/LinearProgressIndicator-class.html)
If you want an undetermined progress indicator, do not set `progressIndicatorController`.
If you want a determined progress indicator, you now have full controll over the progress since you own the `AnimationController`

- There is no need to add a listener to your controller just to call `setState(){}`. Once you pass in your controller, `Flushbar` will do this automatically. Just make sure you call `_controller.forward()`

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

### Show and dismiss animation curves

You can set custom animation curves using `forwardAnimationCurve` and `reverseAnimationCurve`.

- These properties are immutable

```dart
Flushbar(
  forwardAnimationCurve: Curves.decelerate,
  reverseAnimationCurve: Curves.easeOut,
)
  ..title = "Hey Ninja"
  ..message = "Lorem Ipsum is simply dummy text of the printing and typesetting industry"
  ..show(context);
```

### Listen to status updates

You can listen to status update using the `onStatusChanged` property.

- Note that when you pass a new listener using `onStatusChanged`, it will activate once immediately so you can check in what state the Flushbar is.

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

- Note that buttons, messages, and icons will be ignored if `userInputForm != null`
- `dismiss(result)` will yield result. `dismiss()` will yield null.

```dart
Flushbar<List<String>> flush;
final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
```

```dart
TextFormField getFormField(String text) {
    return TextFormField(
      initialValue: text,
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
    );
  }

flush = Flushbar<List<String>>()
      ..userInputForm = Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              getTextFormField("Initial Value"),
              getTextFormField("Initial Value Two"),
            ]
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

This example tries to mimic the [Material Design style guide](https://material.io/design/components/text-fields.html#anatomy)

![Bar input](https://github.com/AndreHaueisen/flushbar/blob/master/readme_resources/input_bar.png)

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

## Make it rain

<a href="https://www.buymeacoffee.com/AndreHaueisen" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: auto !important;width: auto !important;" ></a>