import 'package:flutter/material.dart';

/// Creates a combined fade and position translation transition.
/// This is a unique staggered animation technique, which will be published
/// soon as an official flutter package. Replace this code with that package in 
/// future.
class FadeSlideAnimation {
  
  AnimationController animationController;
  Offset begin = Offset(0, 1);
  Offset end = Offset.zero;
  double overlapFactor = 5;

  FadeSlideAnimation({@required this.animationController}) 
  : assert(animationController != null);

  void changeDirection() => begin = begin == Offset(0, 1) ? Offset(0, -1): Offset(0, 1);

  /// Returns the same list of widgets wrapped up in the transition animation widget.
  List toStaggerdAnimation(List children) {
    final double _delayFactor = 1.0/children.length;
    double _position = 0;
    return children.map((widget) {
      double _start = _position*_delayFactor;
      double _end = _start+_delayFactor+(_delayFactor*overlapFactor);
      _end = _end > 1 ? 1.0 : _end;
      _position++;
      return FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: this.animationController, 
            curve: Interval(
              _start, _end,
              curve: Curves.linear,
            ),
          ),
        ),
        child: SlideTransition(
          position: Tween<Offset>(begin: begin, end: end).animate(
            CurvedAnimation(
              parent: this.animationController,
              curve: Interval(_start, _end, curve: Curves.easeOutQuart),
            ),
          ),
          child: widget,
        ),
      );
    }).toList();
  }
}
