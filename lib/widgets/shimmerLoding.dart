import 'package:flutter/material.dart';

class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({
    super.key,
    required this.isLoading,
    required this.child,
  });

  final bool isLoading;
  final Widget child;

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading> {
  double _shimmerPosition = -1.0;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    // Start the shimmer animation
    _animateShimmer();
  }

  @override
  void dispose() {
    _isDisposed = true; // Mark as disposed
    super.dispose();
  }

  void _animateShimmer() {
    Future.delayed(const Duration(milliseconds: 50), () {
      if (!_isDisposed) {
        setState(() {
          _shimmerPosition =
              _shimmerPosition >= 1.0 ? -1.0 : _shimmerPosition + 0.03;
        });
        _animateShimmer(); // Continue animation if not disposed
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (bounds) {
        return _shimmerGradient.createShader(
          Rect.fromLTWH(
            _shimmerPosition * bounds.width, // Animate the shimmer position
            0,
            bounds.width,
            bounds.height,
          ),
        );
      },
      child: widget.child,
    );
  }
}

const _shimmerGradient = LinearGradient(
  colors: [
    Color(0xFFEBEBF4), // Light shimmer color
    Color(0xFFF4F4F4), // Dark shimmer color
    Color(0xFFEBEBF4), // Light shimmer color again
  ],
  stops: [
    0.1,
    0.3,
    0.4,
  ],
  begin: Alignment(-1.0, -0.3),
  end: Alignment(1.0, 0.3),
  tileMode: TileMode.clamp,
);
