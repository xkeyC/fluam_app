import 'package:flutter/material.dart';

class BouncingBox extends StatefulWidget {
  final Widget child;
  final GestureTapCallback? onTap;

  const BouncingBox({Key? key, this.onTap, required this.child})
      : super(key: key);

  @override
  _BouncingBoxState createState() => _BouncingBoxState();
}

class _BouncingBoxState extends State<BouncingBox>
    with SingleTickerProviderStateMixin {
  double? _scale;
  late AnimationController _controller;

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
      child: Transform.scale(
        scale: _scale,
        child: widget.child,
      ),
    );
  }

  void _tapDown(TapDownDetails details) async {
    _controller.forward();
    await Future.delayed(Duration(milliseconds: 250));
    _controller.reverse();
  }
}
