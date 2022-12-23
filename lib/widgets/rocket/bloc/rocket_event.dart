part of 'rocket_bloc.dart';

@immutable
abstract class RocketEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class RocketFetched extends RocketEvent {}

class RocketRefreshed extends RocketEvent {}

class RocketSelected extends RocketEvent {
  final RocketModel model;

  RocketSelected(this.model);

  @override
  List<Object> get props => [model];
}
