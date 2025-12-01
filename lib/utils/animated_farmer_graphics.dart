// lib/utils/animated_farmer_graphics.dart
import 'package:flutter/material.dart';
import 'package:khetibari/utils/farmer_land_graphics.dart';

/// Animated wrapper for farmer/land graphics with multiple animation styles
class AnimatedFarmerGraphic extends StatefulWidget {
  final String? type; // 'farmer', 'tractor', 'harvest', 'land_pattern'
  final double width;
  final double height;
  final Duration duration;
  final Curve curve;
  final String?
  animationType; // 'fadeIn', 'slideUp', 'rotate', 'scale', 'pulse'

  const AnimatedFarmerGraphic({
    Key? key,
    this.type = 'farmer',
    this.width = 200,
    this.height = 200,
    this.duration = const Duration(milliseconds: 1500),
    this.curve = Curves.easeInOut,
    this.animationType = 'fadeIn',
  }) : super(key: key);

  @override
  State<AnimatedFarmerGraphic> createState() => _AnimatedFarmerGraphicState();
}

class _AnimatedFarmerGraphicState extends State<AnimatedFarmerGraphic>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..forward();

    _setupAnimation();
  }

  void _setupAnimation() {
    switch (widget.animationType) {
      case 'slideUp':
        _animation = Tween<double>(
          begin: 0,
          end: 1,
        ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
        break;
      case 'rotate':
        _animation = Tween<double>(
          begin: 0,
          end: 1,
        ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
        break;
      case 'scale':
        _animation = Tween<double>(
          begin: 0,
          end: 1,
        ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
        break;
      case 'pulse':
        _animation = Tween<double>(
          begin: 0.8,
          end: 1.0,
        ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
        _controller.repeat(reverse: true);
        break;
      default:
        _animation = Tween<double>(
          begin: 0,
          end: 1,
        ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _getGraphic() {
    switch (widget.type) {
      case 'tractor':
        return FarmerLandGraphics.tractorPlowingField(
          width: widget.width,
          height: widget.height,
        );
      case 'harvest':
        return FarmerLandGraphics.harvestScene(
          width: widget.width,
          height: widget.height,
        );
      case 'land_pattern':
        return FarmerLandGraphics.cultivatedLandPattern(
          width: widget.width,
          height: widget.height,
        );
      case 'farmer':
      default:
        return FarmerLandGraphics.farmerWithLandscape(
          width: widget.width,
          height: widget.height,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        Widget result = _getGraphic();

        // Apply animation based on type
        switch (widget.animationType) {
          case 'slideUp':
            result = Transform.translate(
              offset: Offset(0, 50 * (1 - _animation.value)),
              child: result,
            );
            break;
          case 'rotate':
            result = Transform.rotate(
              angle: 6.28 * _animation.value,
              child: result,
            );
            break;
          case 'scale':
            result = Transform.scale(scale: _animation.value, child: result);
            break;
          case 'pulse':
            result = Transform.scale(scale: _animation.value, child: result);
            break;
          default:
            result = Opacity(opacity: _animation.value, child: result);
        }

        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: result,
        );
      },
    );
  }
}

/// Looping animated farmer graphic (repeats animation)
class LoopingAnimatedFarmerGraphic extends StatefulWidget {
  final String? type;
  final double width;
  final double height;
  final Duration duration;
  final String? animationType;

  const LoopingAnimatedFarmerGraphic({
    Key? key,
    this.type = 'farmer',
    this.width = 200,
    this.height = 200,
    this.duration = const Duration(milliseconds: 2000),
    this.animationType = 'pulse',
  }) : super(key: key);

  @override
  State<LoopingAnimatedFarmerGraphic> createState() =>
      _LoopingAnimatedFarmerGraphicState();
}

class _LoopingAnimatedFarmerGraphicState
    extends State<LoopingAnimatedFarmerGraphic>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        Widget graphic;
        switch (widget.type) {
          case 'tractor':
            graphic = FarmerLandGraphics.tractorPlowingField(
              width: widget.width,
              height: widget.height,
            );
            break;
          case 'harvest':
            graphic = FarmerLandGraphics.harvestScene(
              width: widget.width,
              height: widget.height,
            );
            break;
          case 'land_pattern':
            graphic = FarmerLandGraphics.cultivatedLandPattern(
              width: widget.width,
              height: widget.height,
            );
            break;
          default:
            graphic = FarmerLandGraphics.farmerWithLandscape(
              width: widget.width,
              height: widget.height,
            );
        }

        // Apply looping animation
        if (widget.animationType == 'pulse') {
          graphic = Transform.scale(
            scale: 0.9 + (0.1 * _controller.value),
            child: graphic,
          );
        } else if (widget.animationType == 'slide') {
          graphic = Transform.translate(
            offset: Offset(_controller.value * 20 - 10, 0),
            child: graphic,
          );
        }

        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: graphic,
        );
      },
    );
  }
}
