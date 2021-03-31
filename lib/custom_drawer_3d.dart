import 'dart:math' as math;

import 'package:flutter/material.dart';

class CustomDrawer3D extends StatefulWidget {
  const CustomDrawer3D({Key key, this.parent, this.child}) : super(key: key);

  static CustomDrawer3DState of(BuildContext context) => context.findAncestorStateOfType<CustomDrawer3DState>();

  final Widget parent;
  final Widget child;

  @override
  CustomDrawer3DState createState() => CustomDrawer3DState();
}

class CustomDrawer3DState extends State<CustomDrawer3D> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  bool _canBeDragged = false;

  final minDragStartEdge = 50.0;
  final maxDragStartEdge = 300.0;
  final maxSlide = 300;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(duration: Duration(milliseconds: 250), vsync: this);
  }

  void toggle() {
    _animationController.isDismissed ? _animationController.forward() : _animationController.reverse();
  }

  void _close() {
    _animationController.animateBack(0.0);
  }

  void _open() {
    _animationController.animateTo(1.0);
  }

  void _onDragStart(DragStartDetails details) {
    final isDragOpenFromLeft = _animationController.isDismissed && details.globalPosition.dx < minDragStartEdge;
    final isDragCloseFromRight = _animationController.isCompleted && details.globalPosition.dx > maxDragStartEdge;

    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      final delta = details.primaryDelta / maxSlide;

      _animationController.value += delta;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    if (_animationController.isDismissed || _animationController.isCompleted) {
      return;
    }

    if (details.velocity.pixelsPerSecond.dx.abs() >= 365.0) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx / MediaQuery.of(context).size.width;

      _animationController.fling(velocity: visualVelocity);
    } else if (_animationController.value < 0.5) {
      _close();
    } else {
      _open();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _onDragStart,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      onTap: toggle,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (_, __) {
          return Stack(
            children: [
              Transform.translate(
                offset: Offset(maxSlide * (_animationController.value - 1), 0),
                child: Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(math.pi * (1 - _animationController.value) / 2),
                  alignment: Alignment.centerRight,
                  child: widget.parent,
                ),
              ),
              Transform.translate(
                offset: Offset(maxSlide * _animationController.value, 0),
                child: Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(-math.pi * _animationController.value / 2),
                  alignment: Alignment.centerLeft,
                  child: widget.child,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
