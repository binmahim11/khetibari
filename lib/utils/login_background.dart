// lib/utils/login_background.dart
/// Real farmer images from Unsplash with blur and gradient overlay
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

/// Login background with real farmer cultivating images from Unsplash
class LoginBackgroundWithGradient extends StatefulWidget {
  final Widget child;

  const LoginBackgroundWithGradient({Key? key, required this.child})
    : super(key: key);

  @override
  State<LoginBackgroundWithGradient> createState() =>
      _LoginBackgroundWithGradientState();
}

class _LoginBackgroundWithGradientState
    extends State<LoginBackgroundWithGradient>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background color - dark
        Container(color: const Color(0xFF1A1A1A)),

        // Farmer images from Unsplash - Background layers
        Positioned.fill(
          child: Stack(
            children: [
              // Left side farmer image - plowing/cultivating
              Positioned(
                left: -80,
                bottom: -100,
                width: 400,
                height: 400,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(30 * (_controller.value - 0.5), 0),
                      child: Opacity(
                        opacity: 0.25,
                        child: Image.network(
                          'https://images.unsplash.com/photo-1574943320219-553eb213f72d?w=500&h=500&fit=crop',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: const Color(0xFF2D5016),
                              child: const Center(
                                child: Icon(
                                  Icons.agriculture,
                                  size: 80,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Right side farmer image - harvesting
              Positioned(
                right: -60,
                bottom: -120,
                width: 380,
                height: 380,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(-25 * (_controller.value - 0.5), 0),
                      child: Opacity(
                        opacity: 0.2,
                        child: Image.network(
                          'https://images.unsplash.com/photo-1625246333195-78d9c38ad576?w=500&h=500&fit=crop',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: const Color(0xFF3D6B1F),
                              child: const Center(
                                child: Icon(
                                  Icons.agriculture,
                                  size: 80,
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Top center - cultivated fields pattern
              Positioned(
                top: -50,
                left: 0,
                right: 0,
                height: 300,
                child: Opacity(
                  opacity: 0.15,
                  child: Image.network(
                    'https://images.unsplash.com/photo-1611273426858-450d8e3c9fce?w=800&h=400&fit=crop',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(color: const Color(0xFF2D5016));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),

        // Blur effect layer
        Positioned.fill(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
            child: Container(color: Colors.transparent),
          ),
        ),

        // Gradient overlay - darker at bottom for text readability
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.75),
                ],
              ),
            ),
          ),
        ),

        // Content on top
        Positioned.fill(child: widget.child),
      ],
    );
  }
}
