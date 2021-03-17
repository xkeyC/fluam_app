import 'package:flutter/material.dart';

class BouncingBox extends StatefulWidget {
  final Widget child;
  final GestureTapCallback onTap;

  const BouncingBox({Key key, this.onTap, this.child})
      : assert(child != null),
        super(key: key);

  @override
  _BouncingBoxState createState() => _BouncingBoxState();
}

class _BouncingBoxState extends State<BouncingBox>
    with SingleTickerProviderStateMixin {
  double _scale;
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 100,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _tapDown,
      onTapUp: _tapUp,
      child: Transform.scale(
        scale: _scale,
        child: widget.child,
      ),
    );
  }

  void _tapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _tapUp(TapUpDetails details) async {
    await Future.delayed(Duration(milliseconds: 150));
    _controller.reverse();
  }
}
