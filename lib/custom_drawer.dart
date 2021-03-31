import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key key, this.parent, this.child}) : super(key: key);

  static CustomDrawerState of(BuildContext context) => context.findAncestorStateOfType<CustomDrawerState>();

  final Widget parent;
  final Widget child;

  @override
  CustomDrawerState createState() => CustomDrawerState();
}

class CustomDrawerState extends State<CustomDrawer> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  bool _canBeDragged = false;

  final minDragStartEdge = 50.0;
  final maxDragStartEdge = 300.0;
  final maxSlide = 200;

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
          final slide = _animationController.value * maxSlide;
          final scale = 1 - (_animationController.value * 0.3);

          return Stack(
            children: [
              widget.parent,
              Transform(
                transform: Matrix4.identity()
                  ..translate(slide)
                  ..scale(scale),
                alignment: Alignment.center,
                child: widget.child,
              ),
            ],
          );
        },
      ),
    );
  }
}
