import 'package:flutter/foundation.dart';

enum SpacexEnum { rocket, satellite, mission, ship, unknown }

extension SpacexEnumExtension on SpacexEnum {
  static SpacexEnum fromString(String value) {
    SpacexEnum returnedType = SpacexEnum.values.firstWhere(
      (enumValue) =>
          describeEnum(enumValue) == value.toLowerCase().replaceAll(' ', ''),
      orElse: () => SpacexEnum.unknown,
    );

    return returnedType;
  }
}
