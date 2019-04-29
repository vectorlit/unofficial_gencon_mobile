import 'package:flutter/material.dart';

class ConventionTextScaleValue {
  const ConventionTextScaleValue(this.scale, this.label);

  final double scale;
  final String label;

  @override
  bool operator ==(dynamic other) {
    if (runtimeType != other.runtimeType)
      return false;
    final ConventionTextScaleValue typedOther = other;
    return scale == typedOther.scale && label == typedOther.label;
  }

  @override
  int get hashCode => hashValues(scale, label);

  @override
  String toString() {
    return '$runtimeType($label)';
  }

}

const List<ConventionTextScaleValue> kAllGalleryTextScaleValues = <ConventionTextScaleValue>[
  ConventionTextScaleValue(null, 'System Default'),
  ConventionTextScaleValue(0.8, 'Small'),
  ConventionTextScaleValue(1.0, 'Normal'),
  ConventionTextScaleValue(1.3, 'Large'),
  ConventionTextScaleValue(2.0, 'Huge'),
];
