import 'dart:async';
import 'dart:ui';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class FlushbarRoute<T> extends OverlayRoute<T> {
  Animation<double> _filterBlurAnimation;
  Animation<Color> _filterColorAnimation;

  FlushbarRoute({
    @required this.theme,
    @required this.flushbar,
    RouteSettings settings,
  }) : super(settings: settings) {
    this._builder = Builder(builder: (BuildContext innerContext) {
      return GestureDetector(
        child: flushbar,
        onTap: flushbar.onTap != null
            ? () {
                flushbar.onTap(flushbar);
              }
            : null,
      );
    });

    _configureAlignment(this.flushbar.flushbarPosition);
    _onStatusChanged = flushbar.onStatusChanged;
  }

  _configureAlignment(FlushbarPosition flushbarPosition) {
    switch (flushbar.flushbarPosition) {
      case FlushbarPosition.TOP:
        {
          _initialAlignment = Alignment(-1.0, -2.0);
          _endAlignment = Alignment(-1.0, -1.0);
          break;
        }
      case FlushbarPosition.BOTTOM:
        {
          _initialAlignment = Alignment(-1.0, 2.0);
          _endAlignment = Alignment(-1.0, 1.0);
          break;
        }
    }
  }

  Flushbar flushbar;
  Builder _builder;

  final ThemeData theme;

  Future<T> get completed => _transitionCompleter.future;
  final Completer<T> _transitionCompleter = Completer<T>();

  FlushbarStatusCallback _onStatusChanged;
  Alignment _initialAlignment;
  Alignment _endAlignment;
  bool _wasDismissedBySwipe = false;

  Timer _timer;

  bool get opaque => false;

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    List<OverlayEntry> overlays = [];

    if (flushbar.overlayBlur > 0.0) {
      overlays.add(
        OverlayEntry(
            builder: (BuildContext context) {
              return GestureDetector(
                onTap: flushbar.isDismissible ? () => flushbar.dismiss() : null,
                child: AnimatedBuilder(
                  animation: _filterBlurAnimation,
                  builder: (context, child) {
                    return BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: _filterBlurAnimation.value, sigmaY: _filterBlurAnimation.value),
                      child: Container(
                        constraints: BoxConstraints.expand(),
                        color: _filterColorAnimation.value,
                      ),
                    );
                  },
                ),
              );
            },
            maintainState: false,
            opaque: opaque),
      );
    }

    overlays.add(
      OverlayEntry(
          builder: (BuildContext context) {
            final Widget annotatedChild = Semantics(
              child: AlignTransition(
                alignment: _animation,
                child: flushbar.isDismissible ? _getDismissibleFlushbar(_builder) : _getFlushbar(),
              ),
              focused: false,
              container: true,
              explicitChildNodes: true,
            );
            return theme != null ? Theme(data: theme, child: annotatedChild) : annotatedChild;
          },
          maintainState: false,
          opaque: opaque),
    );

    return overlays;
  }

  /// This string is a workaround until Dismissible supports a returning item
  String dismissibleKeyGen = "";

  Widget _getDismissibleFlushbar(Widget child) {
    return Dismissible(
      direction: _getDismissDirection(),
      resizeDuration: null,
      confirmDismiss: (_) {
        if (currentStatus == FlushbarStatus.IS_APPEARING || currentStatus == FlushbarStatus.IS_HIDING) {
          return Future.value(false);
        }
        return Future.value(true);
      },
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
      child: _getFlushbar(),
    );
  }

  Widget _getFlushbar() {
    return Container(
      margin: flushbar.margin,
      child: _builder,
    );
  }

  DismissDirection _getDismissDirection() {
    if (flushbar.dismissDirection == FlushbarDismissDirection.HORIZONTAL) {
      return DismissDirection.horizontal;
    } else {
      if (flushbar.flushbarPosition == FlushbarPosition.TOP) {
        return DismissDirection.up;
      } else {
        return DismissDirection.down;
      }
    }
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
    assert(flushbar.animationDuration != null && flushbar.animationDuration >= Duration.zero);
    return AnimationController(
      duration: flushbar.animationDuration,
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
    return AlignmentTween(begin: _initialAlignment, end: _endAlignment).animate(
      CurvedAnimation(
        parent: _controller,
        curve: flushbar.forwardAnimationCurve,
        reverseCurve: flushbar.reverseAnimationCurve,
      ),
    );
  }

  Animation<double> createBlurFilterAnimation() {
    return Tween(begin: 0.0, end: flushbar.overlayBlur).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.0,
          0.35,
          curve: Curves.easeInOutCirc,
        ),
      ),
    );
  }

  Animation<Color> createColorFilterAnimation() {
    return ColorTween(begin: Colors.transparent, end: flushbar.overlayColor).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.0,
          0.35,
          curve: Curves.easeInOutCirc,
        ),
      ),
    );
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

  @override
  void install() {
    assert(!_transitionCompleter.isCompleted, 'Cannot install a $runtimeType after disposing it.');
    _controller = createAnimationController();
    assert(_controller != null, '$runtimeType.createAnimationController() returned null.');
    _filterBlurAnimation = createBlurFilterAnimation();
    _filterColorAnimation = createColorFilterAnimation();
    _animation = createAnimation();
    assert(_animation != null, '$runtimeType.createAnimation() returned null.');
    super.install();
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
    if (oldRoute is FlushbarRoute) _controller.value = oldRoute._controller.value;
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
      _timer = Timer(flushbar.duration, () {
        if (this.isCurrent) {
          navigator.pop();
        } else if (this.isActive) {
          navigator.removeRoute(this);
        }
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
  bool canTransitionTo(FlushbarRoute<dynamic> nextRoute) => true;

  /// Whether this route can perform a transition from the given route.
  ///
  /// Subclasses can override this method to restrict the set of routes they
  /// need to coordinate transitions with.
  bool canTransitionFrom(FlushbarRoute<dynamic> previousRoute) => true;

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

FlushbarRoute showFlushbar<T>({@required BuildContext context, @required Flushbar flushbar}) {
  assert(flushbar != null);

  return FlushbarRoute<T>(
    flushbar: flushbar,
    theme: Theme.of(context),
    settings: RouteSettings(name: FLUSHBAR_ROUTE_NAME),
  );
}
