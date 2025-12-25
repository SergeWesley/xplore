import 'dart:math';
import '../../domain/entities/neo_entity.dart';

class PositionedNeo {
  final NeoEntity neo;
  final double x;
  final double y;
  final double radius;

  PositionedNeo({
    required this.neo,
    required this.x,
    required this.y,
    required this.radius,
  });
}

class NeoPositionCalculator {
  static const double _padding = 60.0;
  static const double _panelHeight = 100.0;
  static const double _legendOffset = 50.0;
  static const double _minRadius = 8.0;
  static const double _maxRadius = 30.0;
  static const double _margin = 8.0;
  static const int _maxAttempts = 100;

  final Random _random;

  NeoPositionCalculator({int seed = 42}) : _random = Random(seed);

  List<PositionedNeo> calculatePositions(
    List<NeoEntity> neos,
    double width,
    double height,
  ) {
    if (neos.isEmpty) return [];

    final result = <PositionedNeo>[];
    final usableWidth = width - _padding * 2;
    final usableHeight = height - _padding * 2 - _panelHeight;

    final diameters = neos.map((n) => n.averageDiameterMeters);
    final maxDiameter = diameters.reduce(max);
    final minDiameter = diameters.reduce(min);

    for (final neo in neos) {
      final radius = _calculateRadius(neo, minDiameter, maxDiameter);
      final position = _findNonOverlappingPosition(
        radius,
        usableWidth,
        usableHeight,
        result,
      );

      result.add(
        PositionedNeo(neo: neo, x: position.$1, y: position.$2, radius: radius),
      );
    }

    return result;
  }

  double _calculateRadius(
    NeoEntity neo,
    double minDiameter,
    double maxDiameter,
  ) {
    final normalizedSize = maxDiameter > minDiameter
        ? (neo.averageDiameterMeters - minDiameter) /
              (maxDiameter - minDiameter)
        : 0.5;
    return _minRadius + normalizedSize * (_maxRadius - _minRadius);
  }

  (double, double) _findNonOverlappingPosition(
    double radius,
    double usableWidth,
    double usableHeight,
    List<PositionedNeo> existing,
  ) {
    double x, y;
    int attempts = 0;

    do {
      x = _padding + _random.nextDouble() * usableWidth;
      y = _padding + _legendOffset + _random.nextDouble() * usableHeight;
      attempts++;
    } while (_hasOverlap(x, y, radius, existing) && attempts < _maxAttempts);

    return (x, y);
  }

  bool _hasOverlap(
    double x,
    double y,
    double radius,
    List<PositionedNeo> existing,
  ) {
    for (final p in existing) {
      final distance = sqrt(pow(x - p.x, 2) + pow(y - p.y, 2));
      final minDistance = radius + p.radius + _margin;
      if (distance < minDistance) {
        return true;
      }
    }
    return false;
  }
}
