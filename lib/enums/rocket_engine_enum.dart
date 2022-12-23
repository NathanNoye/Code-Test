import 'package:flutter/foundation.dart';

enum RocketEngine { merlin, raptor, unknown }

extension RocketEngineExtension on RocketEngine {
  static RocketEngine fromString(String value) {
    RocketEngine returnedType = RocketEngine.values.firstWhere(
      (enumValue) =>
          describeEnum(enumValue) == value.toLowerCase().replaceAll(' ', ''),
      orElse: () => RocketEngine.unknown,
    );

    return returnedType;
  }
}
