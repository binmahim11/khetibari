// lib/utils/farmer_land_graphics.dart
import 'package:flutter/material.dart';

/// High-contrast farmer and land illustrations using Flutter Canvas & Widgets
class FarmerLandGraphics {
  /// Creates a high-contrast farmer silhouette with cultivated land
  static Widget farmerWithLandscape({
    double width = 200,
    double height = 200,
    Color farmerColor = Colors.white,
    Color landColor = const Color(0xFF2D5016), // Dark green
    Color skyColor = const Color(0xFF1A1A1A), // Near black
  }) {
    return CustomPaint(
      size: Size(width, height),
      painter: FarmerLandPainter(
        farmerColor: farmerColor,
        landColor: landColor,
        skyColor: skyColor,
      ),
    );
  }

  /// Creates high-contrast tractor plowing field
  static Widget tractorPlowingField({
    double width = 200,
    double height = 150,
    Color tractorColor = Colors.white,
    Color fieldColor = const Color(0xFF3D6B1F), // Medium-dark green
    Color skyColor = const Color(0xFF1A1A1A),
  }) {
    return CustomPaint(
      size: Size(width, height),
      painter: TractorFieldPainter(
        tractorColor: tractorColor,
        fieldColor: fieldColor,
        skyColor: skyColor,
      ),
    );
  }

  /// Creates high-contrast harvest scene
  static Widget harvestScene({
    double width = 200,
    double height = 200,
    Color workerColor = Colors.white,
    Color cropColor = const Color(0xFFD4AF37), // Gold/wheat
    Color skyColor = const Color(0xFF1A1A1A),
  }) {
    return CustomPaint(
      size: Size(width, height),
      painter: HarvestScenePainter(
        workerColor: workerColor,
        cropColor: cropColor,
        skyColor: skyColor,
      ),
    );
  }

  /// Creates cultivated land pattern (rows of crops)
  static Widget cultivatedLandPattern({
    double width = 200,
    double height = 150,
    Color landColor = const Color(0xFF2D5016),
    Color lineColor = Colors.white,
  }) {
    return CustomPaint(
      size: Size(width, height),
      painter: CultivatedLandPatternPainter(
        landColor: landColor,
        lineColor: lineColor,
      ),
    );
  }
}

// ============================================
// Custom Painters for High-Contrast Graphics
// ============================================

class FarmerLandPainter extends CustomPainter {
  final Color farmerColor;
  final Color landColor;
  final Color skyColor;

  FarmerLandPainter({
    required this.farmerColor,
    required this.landColor,
    required this.skyColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Sky (background)
    paint.color = skyColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Land (bottom 2/3)
    paint.color = landColor;
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.6, size.width, size.height * 0.4),
      paint,
    );

    // Farmer body (rectangle for simplicity)
    paint.color = farmerColor;
    paint.strokeWidth = 2;

    // Farmer head (circle)
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.35),
      size.width * 0.08,
      paint,
    );

    // Farmer body (rectangle)
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.42,
        size.height * 0.43,
        size.width * 0.16,
        size.height * 0.18,
      ),
      paint,
    );

    // Left arm
    canvas.drawLine(
      Offset(size.width * 0.42, size.height * 0.48),
      Offset(size.width * 0.28, size.height * 0.52),
      paint,
    );

    // Right arm (raised - holding tool)
    canvas.drawLine(
      Offset(size.width * 0.58, size.height * 0.48),
      Offset(size.width * 0.72, size.height * 0.35),
      paint,
    );

    // Tool handle
    canvas.drawLine(
      Offset(size.width * 0.72, size.height * 0.35),
      Offset(size.width * 0.75, size.height * 0.3),
      paint,
    );

    // Legs
    canvas.drawLine(
      Offset(size.width * 0.46, size.height * 0.61),
      Offset(size.width * 0.44, size.height * 0.75),
      paint,
    );

    canvas.drawLine(
      Offset(size.width * 0.54, size.height * 0.61),
      Offset(size.width * 0.56, size.height * 0.75),
      paint,
    );

    // Cultivated rows on land
    paint.strokeWidth = 1;
    for (int i = 0; i < 4; i++) {
      final offset = i * (size.width * 0.2);
      canvas.drawLine(
        Offset(offset, size.height * 0.65),
        Offset(offset + size.width * 0.15, size.height),
        paint..color = landColor.withOpacity(0.7),
      );
    }
  }

  @override
  bool shouldRepaint(FarmerLandPainter oldDelegate) => false;
}

class TractorFieldPainter extends CustomPainter {
  final Color tractorColor;
  final Color fieldColor;
  final Color skyColor;

  TractorFieldPainter({
    required this.tractorColor,
    required this.fieldColor,
    required this.skyColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Sky
    paint.color = skyColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height * 0.5), paint);

    // Field
    paint.color = fieldColor;
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.5, size.width, size.height * 0.5),
      paint,
    );

    // Tractor body (cab)
    paint.color = tractorColor;
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.15,
        size.height * 0.55,
        size.width * 0.15,
        size.height * 0.15,
      ),
      paint,
    );

    // Tractor engine block
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.32,
        size.height * 0.57,
        size.width * 0.12,
        size.height * 0.13,
      ),
      paint,
    );

    // Back wheels (large)
    paint.strokeWidth = 2;
    canvas.drawCircle(
      Offset(size.width * 0.65, size.height * 0.74),
      size.width * 0.12,
      paint,
    );

    // Front wheel (small)
    canvas.drawCircle(
      Offset(size.width * 0.25, size.height * 0.7),
      size.width * 0.06,
      paint,
    );

    // Plow attachment
    paint.strokeWidth = 2;
    canvas.drawLine(
      Offset(size.width * 0.65, size.height * 0.72),
      Offset(size.width * 0.8, size.height * 0.85),
      paint,
    );

    canvas.drawLine(
      Offset(size.width * 0.8, size.height * 0.85),
      Offset(size.width * 0.95, size.height * 0.87),
      paint,
    );

    // Plow blade
    final plowPath =
        Path()
          ..moveTo(size.width * 0.95, size.height * 0.87)
          ..lineTo(size.width * 0.98, size.height * 0.95)
          ..lineTo(size.width * 0.92, size.height * 0.92)
          ..close();
    canvas.drawPath(plowPath, paint);
  }

  @override
  bool shouldRepaint(TractorFieldPainter oldDelegate) => false;
}

class HarvestScenePainter extends CustomPainter {
  final Color workerColor;
  final Color cropColor;
  final Color skyColor;

  HarvestScenePainter({
    required this.workerColor,
    required this.cropColor,
    required this.skyColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Sky
    paint.color = skyColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height * 0.5), paint);

    // Field
    paint.color = const Color(0xFF2D5016); // Dark green field
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.5, size.width, size.height * 0.5),
      paint,
    );

    // Worker body
    paint.color = workerColor;
    canvas.drawCircle(
      Offset(size.width * 0.3, size.height * 0.45),
      size.width * 0.07,
      paint,
    );

    // Worker torso
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.25,
        size.height * 0.52,
        size.width * 0.1,
        size.height * 0.15,
      ),
      paint,
    );

    // Worker arms
    paint.strokeWidth = 2;
    canvas.drawLine(
      Offset(size.width * 0.25, size.height * 0.57),
      Offset(size.width * 0.1, size.height * 0.6),
      paint,
    );

    canvas.drawLine(
      Offset(size.width * 0.35, size.height * 0.57),
      Offset(size.width * 0.5, size.height * 0.55),
      paint,
    );

    // Basket/harvest container
    paint.color = cropColor;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;
    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.55,
        size.height * 0.58,
        size.width * 0.25,
        size.height * 0.28,
      ),
      paint,
    );

    // Crops in basket (stacked)
    paint.style = PaintingStyle.fill;
    for (int i = 0; i < 3; i++) {
      final offset = i * (size.height * 0.08);
      canvas.drawCircle(
        Offset(size.width * 0.68, size.height * 0.65 + offset),
        size.width * 0.08,
        paint,
      );
    }

    // Worker legs
    paint.color = workerColor;
    paint.strokeWidth = 2;
    canvas.drawLine(
      Offset(size.width * 0.27, size.height * 0.67),
      Offset(size.width * 0.24, size.height * 0.85),
      paint,
    );

    canvas.drawLine(
      Offset(size.width * 0.33, size.height * 0.67),
      Offset(size.width * 0.36, size.height * 0.85),
      paint,
    );
  }

  @override
  bool shouldRepaint(HarvestScenePainter oldDelegate) => false;
}

class CultivatedLandPatternPainter extends CustomPainter {
  final Color landColor;
  final Color lineColor;

  CultivatedLandPatternPainter({
    required this.landColor,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Background land
    paint.color = landColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Cultivated rows (diagonal lines)
    paint.color = lineColor;
    paint.strokeWidth = 1.5;
    final spacing = size.width * 0.15;

    for (double x = 0; x < size.width + size.height; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x - size.height, size.height),
        paint,
      );
    }

    // Cross-hatch pattern for depth
    for (double y = 0; y < size.height; y += spacing * 0.8) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y + size.height * 0.3),
        paint..color = lineColor.withOpacity(0.5),
      );
    }
  }

  @override
  bool shouldRepaint(CultivatedLandPatternPainter oldDelegate) => false;
}
