library flushbar;

import 'package:flutter/material.dart';

import 'dart:async';

import 'package:flutter/scheduler.dart';

class _FlushbarRoute<T> extends OverlayRoute<T> {
  _FlushbarRoute({
    @required this.theme,
    @required this.flushbar,
    RouteSettings settings,
  }) : super(settings: settings) {
    this._builder = Builder(builder: (BuildContext innerContext) {
      return flushbar;
    });

    _configureAlignment(this.flushbar.flushbarPosition);

    _onStatusChanged = flushbar.onStatusChanged;
  }

  _configureAlignment(FlushbarPosition flushbarPosition) {
    switch (flushbar.flushbarPosition) {
      case FlushbarPosition.TOP:
        {
          _initialAlignment = new Alignment(-1.0, -2.0);
          _endAlignment = new Alignment(-1.0, -1.0);
          break;
        }
      case FlushbarPosition.BOTTOM:
        {
          _initialAlignment = new Alignment(-1.0, 2.0);
          _endAlignment = new Alignment(-1.0, 1.0);
          break;
        }
    }
  }

  Flushbar flushbar;
  Builder _builder;

  final ThemeData theme;

  Future<T> get completed => _transitionCompleter.future;
  final Completer<T> _transitionCompleter = new Completer<T>();

  /// [onStatusChanged] A callback used to listen to Flushbar status [FlushbarStatus]. Set it using [setStatusListener()]
  FlushbarStatusCallback _onStatusChanged;
  Alignment _initialAlignment;
  Alignment _endAlignment;
  bool _wasDismissedBySwipe = false;

  Timer _timer;

  bool get opaque => false;

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    return [
      OverlayEntry(
          builder: (BuildContext context) {
            final Widget annotatedChild = new Semantics(
              child: AlignTransition(
                alignment: _animation,
                child: flushbar.isDismissible
                    ? _getDismissibleFlushbar(_builder)
                    : Padding(padding: EdgeInsets.all(flushbar.aroundPadding), child: _builder),
              ),
              focused: true,
              scopesRoute: true,
              explicitChildNodes: true,
            );
            return theme != null ? new Theme(data: theme, child: annotatedChild) : annotatedChild;
          },
          maintainState: false,
          opaque: opaque),
    ];
  }

  /// This string is a workaround until Dismissible supports a returning item
  String dismissibleKeyGen = "";

  Widget _getDismissibleFlushbar(Widget child) {
    return new Dismissible(
      resizeDuration: null,
      key: Key(dismissibleKeyGen),
      onDismissed: (_) {
        dismissibleKeyGen += "1";
        _cancelTimer();
        _wasDismissedBySwipe = true;

        if (isCurrent) {
          navigator.pop();
        } else {
          navigator.removeRoute(this);
        }
      },
      child: Padding(
        padding: EdgeInsets.all(flushbar.aroundPadding),
        child: child,
      ),
    );
  }

  @override
  bool get finishedWhenPopped => _controller.status == AnimationStatus.dismissed;

  /// The animation that drives the route's transition and the previous route's
  /// forward transition.
  Animation<Alignment> get animation => _animation;
  Animation<Alignment> _animation;

  /// The animation controller that the route uses to drive the transitions.
  ///
  /// The animation itself is exposed by the [animation] property.
  @protected
  AnimationController get controller => _controller;
  AnimationController _controller;

  /// Called to create the animation controller that will drive the transitions to
  /// this route from the previous one, and back to the previous route from this
  /// one.
  AnimationController createAnimationController() {
    assert(!_transitionCompleter.isCompleted, 'Cannot reuse a $runtimeType after disposing it.');
    final Duration duration = Duration(seconds: 1);
    assert(duration != null && duration >= Duration.zero);
    return new AnimationController(
      duration: duration,
      debugLabel: debugLabel,
      vsync: navigator,
    );
  }

  /// Called to create the animation that exposes the current progress of
  /// the transition controlled by the animation controller created by
  /// [createAnimationController()].
  Animation<Alignment> createAnimation() {
    assert(!_transitionCompleter.isCompleted, 'Cannot reuse a $runtimeType after disposing it.');
    assert(_controller != null);
    return AlignmentTween(begin: _initialAlignment, end: _endAlignment).animate(new CurvedAnimation(
        parent: _controller, curve: flushbar.forwardAnimationCurve, reverseCurve: flushbar.reverseAnimationCurve));
  }

  T _result;
  FlushbarStatus currentStatus;

  //copy of `routes.dart`
  void _handleStatusChanged(AnimationStatus status) {
    switch (status) {
      case AnimationStatus.completed:
        currentStatus = FlushbarStatus.SHOWING;
        _onStatusChanged(currentStatus);
        if (overlayEntries.isNotEmpty) overlayEntries.first.opaque = opaque;

        break;
      case AnimationStatus.forward:
        currentStatus = FlushbarStatus.IS_APPEARING;
        _onStatusChanged(currentStatus);
        break;
      case AnimationStatus.reverse:
        currentStatus = FlushbarStatus.IS_HIDING;
        _onStatusChanged(currentStatus);
        if (overlayEntries.isNotEmpty) overlayEntries.first.opaque = false;
        break;
      case AnimationStatus.dismissed:
        assert(!overlayEntries.first.opaque);
        // We might still be the current route if a subclass is controlling the
        // the transition and hits the dismissed status. For example, the iOS
        // back gesture drives this animation to the dismissed status before
        // popping the navigator.
        currentStatus = FlushbarStatus.DISMISSED;
        _onStatusChanged(currentStatus);

        if (!isCurrent) {
          navigator.finalizeRoute(this);
          assert(overlayEntries.isEmpty);
        }
        break;
    }
    changedInternalState();
  }

  /// The animation for the route being pushed on top of this route. This
  /// animation lets this route coordinate with the entrance and exit transition
  /// of routes pushed on top of this route.
  // Animation<Alignment> get secondaryAnimation => _secondaryAnimation;
  // final FlushbarProxyAnimation _secondaryAnimation = new FlushbarProxyAnimation(kAlwaysDismissedAnimation);

  @override
  void install(OverlayEntry insertionPoint) {
    assert(!_transitionCompleter.isCompleted, 'Cannot install a $runtimeType after disposing it.');
    _controller = createAnimationController();
    assert(_controller != null, '$runtimeType.createAnimationController() returned null.');
    _animation = createAnimation();
    assert(_animation != null, '$runtimeType.createAnimation() returned null.');
    super.install(insertionPoint);
  }

  @override
  TickerFuture didPush() {
    assert(_controller != null, '$runtimeType.didPush called before calling install() or after calling dispose().');
    assert(!_transitionCompleter.isCompleted, 'Cannot reuse a $runtimeType after disposing it.');
    _animation.addStatusListener(_handleStatusChanged);
    _configureTimer();
    return _controller.forward();
  }

  @override
  void didReplace(Route<dynamic> oldRoute) {
    assert(_controller != null, '$runtimeType.didReplace called before calling install() or after calling dispose().');
    assert(!_transitionCompleter.isCompleted, 'Cannot reuse a $runtimeType after disposing it.');
    if (oldRoute is _FlushbarRoute) _controller.value = oldRoute._controller.value;
    _animation.addStatusListener(_handleStatusChanged);
    super.didReplace(oldRoute);
  }

  @override
  bool didPop(T result) {
    assert(_controller != null, '$runtimeType.didPop called before calling install() or after calling dispose().');
    assert(!_transitionCompleter.isCompleted, 'Cannot reuse a $runtimeType after disposing it.');

    _result = result;
    _cancelTimer();

    if (_wasDismissedBySwipe) {
      Timer(Duration(milliseconds: 200), () {
        _controller.reset();
      });

      _wasDismissedBySwipe = false;
    } else {
      _controller.reverse();
    }

    return super.didPop(result);
  }

  void _configureTimer() {
    if (flushbar.duration != null) {
      if (_timer != null && _timer.isActive) {
        _timer.cancel();
      }
      _timer = new Timer(flushbar.duration, () {
        navigator.pop();
      });
    } else {
      if (_timer != null) {
        _timer.cancel();
      }
    }
  }

  void _cancelTimer() {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
    }
  }

  /// Whether this route can perform a transition to the given route.
  ///
  /// Subclasses can override this method to restrict the set of routes they
  /// need to coordinate transitions with.
  bool canTransitionTo(_FlushbarRoute<dynamic> nextRoute) => true;

  /// Whether this route can perform a transition from the given route.
  ///
  /// Subclasses can override this method to restrict the set of routes they
  /// need to coordinate transitions with.
  bool canTransitionFrom(_FlushbarRoute<dynamic> previousRoute) => true;

  @override
  void dispose() {
    assert(!_transitionCompleter.isCompleted, 'Cannot dispose a $runtimeType twice.');
    _controller?.dispose();
    _transitionCompleter.complete(_result);
    super.dispose();
  }

  /// A short description of this route useful for debugging.
  String get debugLabel => '$runtimeType';

  @override
  String toString() => '$runtimeType(animation: $_controller)';
}

_FlushbarRoute _showFlushbar<T>({@required BuildContext context, @required Flushbar flushbar}) {
  assert(flushbar != null);

  return new _FlushbarRoute<T>(
    flushbar: flushbar,
    theme: Theme.of(context),
    settings: RouteSettings(name: FLUSHBAR_ROUTE_NAME),
  );
}

const String FLUSHBAR_ROUTE_NAME = "/flushbarRoute";

typedef void FlushbarStatusCallback(FlushbarStatus status);

/// A custom widget so you can notify your user when you fell like he needs an explanation.
/// This is inspired on a custom view (Flashbar)[https://github.com/aritraroy/Flashbar] created for android.
///
/// [title] The title displayed to the user
/// [message] The message displayed to the user.
/// [titleText] If you need something more personalized, pass a [Text] widget to this variable. [title] will be ignored if this variable is not null.
/// [messageText] If you need something more personalized, pass a [Text] widget to this variable. [message] will be ignored if this variable is not null.
/// [icon] The [Icon] indication what kind of message you are displaying.
/// [aroundPadding] Adds a padding to all sides of Flushbar to make it float
/// [borderRadius] Adds a radius to all corners of Flushbar. Best combined with [aroundPadding]. I do not recommend using it with [showProgressIndicator] or [leftBarIndicatorColor]
/// [backgroundColor] Flushbar background color. Will be ignored if [backgroundGradient] is not null.
/// [leftBarIndicatorColor] If not null, shows a left vertical bar to better indicate the humor of the notification. It is not possible to use it with a [Form] and I do not recommend using it with [LinearProgressIndicator].
/// [shadowColor] The shadow generated by the Flushbar. Leave it null if you don't want a shadow.
/// [backgroundGradient] Flushbar background gradient. Makes [backgroundColor] be ignored.
/// [mainButton] A [FlatButton] widget if you need an action from the user.
/// [duration] How long until Flushbar will hide itself (be dismissed). To make it indefinite, leave it null.
/// [isDismissible] Determines if the user can swipe to dismiss the bar. It is recommended that you set [duration] != null if [isDismissible] == false. If the user swipes Flushbar to dismiss it no value will be returned.
/// [flushbarPosition] (final) Flushbar can be based on [FlushbarPosition.TOP] or on [FlushbarPosition.BOTTOM] of your screen. [FlushbarPosition.BOTTOM] is the default.
/// [forwardAnimationCurve] (final) The [Curve] animation used when show() is called. [Curves.easeOut] is default.
/// [reverseAnimationCurve] (final) The [Curve] animation used when dismiss() is called. [Curves.fastOutSlowIn] is default.
/// [showProgressIndicator] true if you want to show a [LinearProgressIndicator].
/// [progressIndicatorController] An optional [AnimationController] when you want to controll the progress of your [LinearProgressIndicator].
/// [progressIndicatorBackgroundColor] a [LinearProgressIndicator] configuration parameter.
/// [progressIndicatorValueColor] a [LinearProgressIndicator] configuration parameter.
/// [userInputForm] A [TextFormField] in case you want a simple user input. Every other widget is ignored if this is not null.
class Flushbar<T extends Object> extends StatefulWidget {
  Flushbar({
    Key key,
    this.title,
    this.message,
    this.titleText,
    this.messageText,
    this.icon,
    this.aroundPadding = 0.0,
    this.borderRadius = 0.0,
    this.backgroundColor = const Color(0xFF303030),
    this.leftBarIndicatorColor,
    this.shadowColor,
    this.backgroundGradient,
    this.mainButton,
    this.duration,
    this.isDismissible = true,
    this.showProgressIndicator = false,
    this.progressIndicatorController,
    this.progressIndicatorBackgroundColor,
    this.progressIndicatorValueColor,
    this.flushbarPosition = FlushbarPosition.BOTTOM,
    this.forwardAnimationCurve = Curves.easeOut,
    this.reverseAnimationCurve = Curves.fastOutSlowIn,
  }) : super(key: key);

  /// [onStatusChanged] A callback used to listen to Flushbar status [FlushbarStatus]. Set it using [setStatusListener()]
  FlushbarStatusCallback onStatusChanged = (FlushbarStatus status) {};
  String title;
  String message;
  Text titleText;
  Text messageText;
  Color backgroundColor;
  Color leftBarIndicatorColor;
  Color shadowColor;
  Gradient backgroundGradient;
  Icon icon;
  FlatButton mainButton;
  Duration duration;
  bool showProgressIndicator;
  AnimationController progressIndicatorController;
  Color progressIndicatorBackgroundColor;
  Animation<Color> progressIndicatorValueColor;
  bool isDismissible;
  double aroundPadding;
  double borderRadius;
  Form userInputForm;

  final FlushbarPosition flushbarPosition;
  final Curve forwardAnimationCurve;
  final Curve reverseAnimationCurve;

  _FlushbarRoute<T> _flushbarRoute;
  T _result;

  /// Show the flushbar. Kicks in [FlushbarStatus.IS_APPEARING] state followed by [FlushbarStatus.SHOWING]
  Future<T> show(BuildContext context) async {
    _flushbarRoute = _showFlushbar<T>(
      context: context,
      flushbar: this,
    );

    return await Navigator.of(context, rootNavigator: false).push(_flushbarRoute);
  }

  /// Dismisses the flushbar causing is to return a future containing [result].
  /// When this future finishes, it is guaranteed that Flushbar was dismissed.
  Future<T> dismiss([T result]) async {
    if (_flushbarRoute.isCurrent) {
      _flushbarRoute.navigator.pop(result);
      return _flushbarRoute.completed;
    } else if (_flushbarRoute.isActive) {
      // removeRoute is called every time you dismiss a Flushbar that is not the top route.
      // It will not animate back and listeners will not detect FlushbarStatus.IS_HIDING or FlushbarStatus.DISMISSED
      // To avoid this, always make sure that Flushbar is the top route when it is being dismissed
      _flushbarRoute.navigator.removeRoute(_flushbarRoute);
    }

    return null;
  }

  /// Checks if the flushbar is visible
  bool isShowing() {
    return _flushbarRoute.currentStatus == FlushbarStatus.SHOWING;
  }

  /// Checks if the flushbar is dismissed
  bool isDismissed() {
    return _flushbarRoute.currentStatus == FlushbarStatus.DISMISSED;
  }

  @override
  State createState() {
    return new _FlushbarState<T>();
  }
}

class _FlushbarState<K extends Object> extends State<Flushbar> with TickerProviderStateMixin {
  BoxShadow _boxShadow;
  FlushbarStatus currentStatus;
  Timer _timer;

  AnimationController _fadeController;
  Animation<double> _fadeAnimation;

  final Widget _emptyWidget = SizedBox(width: 0.0, height: 0.0);
  final double _initialOpacity = 1.0;
  final double _finalOpacity = 0.4;

  final Duration _pulseAnimationDuration = Duration(seconds: 1);

  List<BoxShadow> _getBoxShadowList() {
    if (_boxShadow != null) {
      return [_boxShadow];
    } else {
      return null;
    }
  }

  bool _isTitlePresent;
  double _messageTopMargin;

  @override
  void initState() {
    super.initState();

    assert(((widget.userInputForm != null || (widget.message != null || widget.messageText != null))),
        "Don't forget to show a message to your user!");

    _isTitlePresent = (widget.title != null || widget.titleText != null);
    _messageTopMargin = _isTitlePresent ? 6.0 : 16.0;

    _setBoxShadow();

    _configureLeftBarFuture();
    _configurePulseAnimation();
    _configureProgressIndicatorAnimation();

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    if (widget.progressIndicatorController != null) {
      widget.progressIndicatorController.removeListener(_progressListener);
      widget.progressIndicatorController.dispose();
    }
    focusNode.detach();
    super.dispose();
  }

  void _setBoxShadow() {
    switch (widget.flushbarPosition) {
      case FlushbarPosition.TOP:
        {
          if (widget.shadowColor != null) {
            _boxShadow = BoxShadow(
              color: widget.shadowColor,
              offset: Offset(0.0, 2.0),
              blurRadius: 3.0,
            );
          }

          break;
        }
      case FlushbarPosition.BOTTOM:
        {
          if (widget.shadowColor != null) {
            _boxShadow = BoxShadow(
              color: widget.shadowColor,
              offset: Offset(0.0, -0.7),
              blurRadius: 3.0,
            );
          }

          break;
        }
    }
  }

  final Completer<double> _boxHeightCompleter = Completer<double>();

  void _configureLeftBarFuture() {
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        final keyContext = backgroundBoxKey.currentContext;

        if (keyContext != null) {
          final RenderBox box = keyContext.findRenderObject();
          _boxHeightCompleter.complete(box.size.height);
        }
      },
    );
  }

  void _configurePulseAnimation() {
    _fadeController = AnimationController(vsync: this, duration: _pulseAnimationDuration);
    _fadeAnimation = new Tween(begin: _initialOpacity, end: _finalOpacity).animate(
      new CurvedAnimation(
        parent: _fadeController,
        curve: Curves.linear,
      ),
    );

    _fadeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _fadeController.reverse();
      }
      if (status == AnimationStatus.dismissed) {
        _fadeController.forward();
      }
    });

    _fadeController.forward();
  }

  Function _progressListener;

  void _configureProgressIndicatorAnimation() {
    if (widget.showProgressIndicator && widget.progressIndicatorController != null) {
      _progressListener = () {
        setState(() {});
      };
      widget.progressIndicatorController.addListener(_progressListener);

      _progressAnimation = CurvedAnimation(curve: Curves.linear, parent: widget.progressIndicatorController);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Align(
      heightFactor: 1.0,
      child: Material(
        color: Colors.transparent,
        child: SafeArea(
          minimum: widget.flushbarPosition == FlushbarPosition.BOTTOM
              ? EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom)
              : EdgeInsets.only(top: MediaQuery.of(context).viewInsets.top),
          bottom: widget.flushbarPosition == FlushbarPosition.BOTTOM,
          top: widget.flushbarPosition == FlushbarPosition.TOP,
          left: false,
          right: false,
          child: _getFlushbar(),
        ),
      ),
    );
  }

  Widget _getFlushbar() {
    return (widget.userInputForm != null) ? _generateInputFlushbar() : _generateFlushbar();
  }

  FocusScopeNode focusNode = FocusScopeNode();

  Widget _generateInputFlushbar() {
    return new DecoratedBox(
      decoration: new BoxDecoration(
        color: widget.backgroundColor,
        gradient: widget.backgroundGradient,
        boxShadow: _getBoxShadowList(),
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: new Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0, top: 16.0),
        child: FocusScope(
          child: widget.userInputForm,
          node: focusNode,
          autofocus: true,
        ),
      ),
    );
  }

  CurvedAnimation _progressAnimation;
  GlobalKey backgroundBoxKey = new GlobalKey();

  Widget _generateFlushbar() {
    return new DecoratedBox(
      key: backgroundBoxKey,
      decoration: new BoxDecoration(
        color: widget.backgroundColor,
        gradient: widget.backgroundGradient,
        boxShadow: _getBoxShadowList(),
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.showProgressIndicator
              ? LinearProgressIndicator(
                  value: widget.progressIndicatorController != null ? _progressAnimation.value : null,
                  backgroundColor: widget.progressIndicatorBackgroundColor,
                  valueColor: widget.progressIndicatorValueColor,
                )
              : _emptyWidget,
          new Row(mainAxisSize: MainAxisSize.max, children: _getAppropriateRowLayout()),
        ],
      ),
    );
  }

  List<Widget> _getAppropriateRowLayout() {
    if (widget.icon == null && widget.mainButton == null) {
      return [
        _buildLeftBarIndicator(),
        new Expanded(
          flex: 1,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              (_isTitlePresent)
                  ? new Padding(
                      padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                      child: _getTitleText(),
                    )
                  : _emptyWidget,
              new Padding(
                padding: EdgeInsets.only(top: _messageTopMargin, left: 16.0, right: 16.0, bottom: 16.0),
                child: widget.messageText ?? _getDefaultNotificationText(),
              ),
            ],
          ),
        ),
      ];
    } else if (widget.icon != null && widget.mainButton == null) {
      return <Widget>[
        _buildLeftBarIndicator(),
        new ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: 42.0),
          child: _getIcon(),
        ),
        new Expanded(
          flex: 1,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              (_isTitlePresent)
                  ? new Padding(
                      padding: const EdgeInsets.only(top: 16.0, left: 4.0, right: 16.0),
                      child: _getTitleText(),
                    )
                  : _emptyWidget,
              new Padding(
                padding: EdgeInsets.only(top: _messageTopMargin, left: 4.0, right: 16.0, bottom: 16.0),
                child: widget.messageText ?? _getDefaultNotificationText(),
              ),
            ],
          ),
        ),
      ];
    } else if (widget.icon == null && widget.mainButton != null) {
      return <Widget>[
        _buildLeftBarIndicator(),
        new Expanded(
          flex: 1,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              (_isTitlePresent)
                  ? new Padding(
                      padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                      child: _getTitleText(),
                    )
                  : _emptyWidget,
              new Padding(
                padding: EdgeInsets.only(top: _messageTopMargin, left: 16.0, right: 8.0, bottom: 16.0),
                child: widget.messageText ?? _getDefaultNotificationText(),
              ),
            ],
          ),
        ),
        new Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: _getMainActionButton(),
        ),
      ];
    } else {
      return <Widget>[
        _buildLeftBarIndicator(),
        new ConstrainedBox(constraints: BoxConstraints.tightFor(width: 42.0), child: _getIcon()),
        new Expanded(
          flex: 1,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              (_isTitlePresent)
                  ? new Padding(
                      padding: const EdgeInsets.only(top: 16.0, left: 4.0, right: 8.0),
                      child: _getTitleText(),
                    )
                  : _emptyWidget,
              new Padding(
                padding: EdgeInsets.only(top: _messageTopMargin, left: 4.0, right: 8.0, bottom: 16.0),
                child: widget.messageText ?? _getDefaultNotificationText(),
              ),
            ],
          ),
        ),
        new Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: _getMainActionButton(),
            ) ??
            _emptyWidget,
      ];
    }
  }

  Widget _buildLeftBarIndicator() {
    if (widget.leftBarIndicatorColor != null) {
      return FutureBuilder(
        future: _boxHeightCompleter.future,
        builder: (BuildContext buildContext, AsyncSnapshot<double> snapshot) {
          if (snapshot.hasData) {
            return Container(
              color: widget.leftBarIndicatorColor,
              width: 5.0,
              height: snapshot.data,
            );
          } else {
            return _emptyWidget;
          }
        },
      );
    } else {
      return _emptyWidget;
    }
  }

  Widget _getIcon() {
    if (widget.icon != null) {
      return FadeTransition(
        opacity: _fadeAnimation,
        child: widget.icon,
      );
    } else {
      return _emptyWidget;
    }
  }

  Text _getTitleText() {
    return widget.titleText != null
        ? widget.titleText
        : new Text(
            widget.title ?? "",
            style: TextStyle(fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.bold),
          );
  }

  Text _getDefaultNotificationText() {
    return new Text(
      widget.message ?? "",
      style: TextStyle(fontSize: 14.0, color: Colors.white),
    );
  }

  FlatButton _getMainActionButton() {
    if (widget.mainButton != null) {
      return widget.mainButton;
    } else {
      return null;
    }
  }
}

/// Indicates if flushbar is going to start at the [TOP] or at the [BOTTOM]
enum FlushbarPosition { TOP, BOTTOM }

/// Indicates the animation status
/// [FlushbarStatus.SHOWING] Flushbar has stopped and the user can see it
/// [FlushbarStatus.DISMISSED] Flushbar has finished its mission and returned any pending values
/// [FlushbarStatus.IS_APPEARING] Flushbar is moving towards [FlushbarStatus.SHOWING]
/// [FlushbarStatus.IS_HIDING] Flushbar is moving towards [] [FlushbarStatus.DISMISSED]
enum FlushbarStatus { SHOWING, DISMISSED, IS_APPEARING, IS_HIDING }
