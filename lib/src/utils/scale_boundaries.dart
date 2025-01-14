import 'dart:math' as math;
import 'dart:ui' show Size;

import 'package:photo_view/photo_view.dart';

class ScaleBoundaries {
  const ScaleBoundaries(
    this._minScale,
    this._maxScale,
    this._initialScale,
    this.outerSize,
    this.childSize,
  );

  final PhotoViewScale _minScale;
  final PhotoViewScale _maxScale;
  final PhotoViewScale _initialScale;
  final Size outerSize;
  final Size childSize;

  double get minScale {
    return switch (_minScale) {
      PhotoViewScaleValue(:final scale) => scale,
      PhotoViewScaleContained(:final multiplier) =>
        _scaleForContained(outerSize, childSize) * multiplier,
      PhotoViewScaleCovered(:final multiplier) =>
        _scaleForCovering(outerSize, childSize) * multiplier,
    };
  }

  double get maxScale {
    return switch (_maxScale) {
      PhotoViewScaleValue(:final scale) => scale,
      PhotoViewScaleContained(:final multiplier) =>
        _scaleForContained(outerSize, childSize) * multiplier,
      PhotoViewScaleCovered(:final multiplier) =>
        _scaleForCovering(outerSize, childSize) * multiplier,
    }
        .clamp(minScale, double.infinity);
  }

  double get initialScale {
    return switch (_initialScale) {
      PhotoViewScaleValue(:final scale) => scale,
      PhotoViewScaleContained(:final multiplier) =>
        _scaleForContained(outerSize, childSize) * multiplier,
      PhotoViewScaleCovered(:final multiplier) =>
        _scaleForCovering(outerSize, childSize) * multiplier,
    }
        .clamp(minScale, maxScale);
  }

  @override
  String toString() {
    return 'ScaleBoundaries(_minScale: $_minScale, _maxScale: $_maxScale, _initialScale: $_initialScale, outerSize: $outerSize, childSize: $childSize)';
  }

  @override
  bool operator ==(covariant ScaleBoundaries other) {
    if (identical(this, other)) return true;

    return other._minScale == _minScale &&
        other._maxScale == _maxScale &&
        other._initialScale == _initialScale &&
        other.outerSize == outerSize &&
        other.childSize == childSize;
  }

  @override
  int get hashCode {
    return _minScale.hashCode ^
        _maxScale.hashCode ^
        _initialScale.hashCode ^
        outerSize.hashCode ^
        childSize.hashCode;
  }
}

double _scaleForContained(Size size, Size childSize) {
  final imageWidth = childSize.width;
  final imageHeight = childSize.height;

  final screenWidth = size.width;
  final screenHeight = size.height;

  return math.min(screenWidth / imageWidth, screenHeight / imageHeight);
}

double _scaleForCovering(Size size, Size childSize) {
  final imageWidth = childSize.width;
  final imageHeight = childSize.height;

  final screenWidth = size.width;
  final screenHeight = size.height;

  return math.max(screenWidth / imageWidth, screenHeight / imageHeight);
}
