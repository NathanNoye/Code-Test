part of 'rocket_bloc.dart';

abstract class RocketState extends Equatable {
  const RocketState() : super();

  @override
  List<Object> get props => [];
}

class RocketInitial extends RocketState {}

class RocketFetchLoaded extends RocketState {
  final List<RocketModel> rockets;

  RocketFetchLoaded({
    this.rockets = const <RocketModel>[],
  }) : super();

  RocketFetchLoaded copyWith({List<RocketModel>? rockets}) {
    return RocketFetchLoaded(
      rockets: rockets ?? this.rockets,
    );
  }

  @override
  List<Object> get props => [rockets];
}

class RocketLoading extends RocketState {}

class RocketRefreshing extends RocketState {}

class RocketFetchFailed extends RocketState {}

class RocketDetailSelected extends RocketState {
  final RocketModel rocket;

  RocketDetailSelected({
    required this.rocket,
  }) : super();

  RocketDetailSelected copyWith({required RocketModel rocket}) {
    return RocketDetailSelected(
      rocket: rocket,
    );
  }

  @override
  List<Object> get props => [rocket];
}
