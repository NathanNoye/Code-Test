import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redacted_codetest/locator.dart';
import 'package:redacted_codetest/models/rocket_model.dart';
import 'package:redacted_codetest/services/error_service.dart';
import 'package:redacted_codetest/widgets/rocket/bloc/rocket_repo.dart';

part 'rocket_event.dart';
part 'rocket_state.dart';

class RocketBloc extends Bloc<RocketEvent, RocketState> {
  final RocketRepository rocketRepository = RocketRepository();
  List<RocketModel> rocketModels = [];

  RocketBloc() : super(RocketInitial()) {
    on<RocketFetched>(_onRocketFetched);

    on<RocketRefreshed>(_onRocketRefreshed);

    on<RocketSelected>(_onRocketSelected);
  }

  Future<void> _onRocketFetched(
      RocketFetched event, Emitter<RocketState> emit) async {
    List<RocketModel> rockets = [];

    try {
      emit(RocketLoading());

      // Use the last in-memory values from the previous fetch so if there's a delay in fetching (slow firebase operation / bad internet connection), the user can still browse
      if (rocketModels.isNotEmpty) {
        emit(RocketFetchLoaded(
          rockets: rocketModels,
        ));
      }

      Stopwatch stopwatch = Stopwatch();
      stopwatch.start();
      rockets = await rocketRepository.fetchRockets();
      stopwatch.stop();
      debugPrint(
          'Took ${stopwatch.elapsedMilliseconds / 1000} seconds to fetch rockets from the repository');

      rocketModels = rockets;

      return emit(RocketFetchLoaded(
        rockets: rockets,
      ));
    } catch (exception, stacktrace) {
      emit(RocketFetchFailed());

      await locator<ErrorService>().captureException(exception, stacktrace,
          debuggingMessage:
              'An error was caught in rocket_bloc.dart in the onRocketsFetched function');
    }
  }

  Future<void> _onRocketRefreshed(
      RocketRefreshed event, Emitter<RocketState> emit) async {
    emit(RocketRefreshing());

    List<RocketModel> rockets = await rocketRepository.fetchRockets(true);

    emit(RocketFetchLoaded(
      rockets: rockets,
    ));
  }

  Future<void> _onRocketSelected(
      RocketSelected event, Emitter<RocketState> emit) async {
    emit(RocketDetailSelected(rocket: event.props[0] as RocketModel));
  }
}
