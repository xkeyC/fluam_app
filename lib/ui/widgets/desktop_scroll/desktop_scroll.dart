import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

const int DEFAULT_NORMAL_SCROLL_ANIMATION_LENGTH_MS = 250;
const int DEFAULT_SCROLL_SPEED = 130;

class SmoothScrollDesktop extends StatelessWidget {
  ///Same ScrollController as the child widget's.
  final ScrollController controller;

  ///Child scrollable widget.
  final Widget child;

  ///Scroll speed px/scroll.
  final int scrollSpeed;

  ///Scroll animation length in milliseconds.
  final int scrollAnimationLength;

  ///Curve of the animation.
  final Curve curve;

  SmoothScrollDesktop({
    required this.controller,
    required this.child,
    this.scrollSpeed = DEFAULT_SCROLL_SPEED,
    this.scrollAnimationLength = DEFAULT_NORMAL_SCROLL_ANIMATION_LENGTH_MS,
    this.curve = Curves.linear,
  });

  @override
  Widget build(BuildContext context) {
    double _scroll = 0;

    controller.addListener(() {
      _scroll = controller.offset;
    });

    return Listener(
      onPointerSignal: (pointerSignal) {
        int millis = scrollAnimationLength;
        if (pointerSignal is PointerScrollEvent) {
          //print("offset: ${controller.offset}");
          /// Ignore the scroll event at the bottom.
          if (controller.offset >= controller.position.maxScrollExtent &&
              pointerSignal.scrollDelta.dy > 0) {
            return;
          }

          if (pointerSignal.scrollDelta.dy > 0) {
            _scroll += scrollSpeed;
            //print("[down] scroll: $_scroll scrollSpeed:$scrollSpeed");
          } else {
            _scroll -= scrollSpeed;
            if (_scroll < 0) {
              if (controller.offset >=
                  controller.position.maxScrollExtent / 2) {
                _scroll = controller.position.maxScrollExtent - scrollSpeed;
              } else {
                _scroll = 0;
              }
            }
            //print("[up] scroll: $_scroll scrollSpeed:$scrollSpeed");
          }

          controller.animateTo(
            _scroll,
            duration: Duration(milliseconds: millis),
            curve: curve,
          );
        }
      },
      child: child,
    );
  }
}
