import 'package:equatable/equatable.dart';
import 'package:redacted_codetest/enums/rocket_engine_enum.dart';
import 'package:redacted_codetest/enums/spacex_enum.dart';

class RocketModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final SpacexEnum type;
  final double mass;
  final double height;
  final String? wikipediaLink;
  final int stages;
  final DateTime firstFlight;
  final _RocketEngineModel rocketEngineModel;

  double get massInKG => mass;
  double get massInPounds => mass * 2.2046;

  double get heightInMeters => height;
  double get heightInFeet => height * 3.28084;

  RocketModel({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.mass,
    required this.height,
    this.wikipediaLink,
    required this.stages,
    required this.firstFlight,
    required this.rocketEngineModel,
  });

  factory RocketModel.fromJson(Map<String, dynamic> json) {
    return RocketModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: SpacexEnumExtension.fromString(json['type']),
      mass: double.parse(json['mass']['kg'].toString()),
      height: double.parse(json['height']['meters'].toString()),
      wikipediaLink:
          json.containsKey('wikipediaLink') ? json['wikipediaLink'] : null,
      stages: json['stages'],
      firstFlight: DateTime.parse(json['first_flight']),
      rocketEngineModel: _RocketEngineModel.fromJson(json['engines']),
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        type,
        mass,
        height,
        wikipediaLink,
        stages,
        firstFlight,
        rocketEngineModel
      ];
}

class _RocketEngineModel {
  final int? engines;
  final RocketEngine type;
  final String version;

  _RocketEngineModel({
    this.engines,
    required this.type,
    required this.version,
  });

  factory _RocketEngineModel.fromJson(Map<String, dynamic> json) {
    return _RocketEngineModel(
      engines: json.containsKey('engines') ? json['engines'] : null,
      type: RocketEngineExtension.fromString(json['type']),
      version: json['version'],
    );
  }
}
