// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:redacted_codetest/models/rocket_model.dart';
import 'package:redacted_codetest/widgets/rocket/bloc/rocket_bloc.dart';
import 'package:redacted_codetest/widgets/rocket/bloc/rocket_repo.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final rocketJsonFile =
      await rootBundle.loadString("assets/mocks/rocket_launches.json");
  final rocketJson = json.decode(rocketJsonFile);

  test('Build a rocket from json', () {
    RocketModel model = RocketModel.fromJson(rocketJson['data']['rockets'][0]);
    expect(model.name, 'Falcon 1');
    expect(model.massInKG, 30146.0);
    expect(model.massInPounds, 66459.8716);
  });

  test('Get rocket collection from repo', () async {
    MockRocketRepository mockRepo = MockRocketRepository();
    List<RocketModel> rocketCollection = await mockRepo.fetchRockets(false);

    expect(rocketCollection.length, 4);
    expect(rocketCollection.last.name, 'Starship');
  });

  test('Test BLoC state flow', () async* {
    MockRocketBloc bloc = MockRocketBloc();

    Iterable<RocketState> expectedStates = [
      RocketInitial(),
      RocketLoading(),
      RocketFetchLoaded(rockets: [])
    ];

    whenListen(
      bloc,
      Stream.fromIterable(expectedStates),
    );

    expectLater(bloc, emitsInOrder(expectedStates));
  });
}

class MockRocketBloc extends MockBloc<RocketEvent, RocketState>
    implements RocketBloc {
  @override
  final RocketRepository rocketRepository = MockRocketRepository();
}

class MockRocketRepository extends Mock implements RocketRepository {
  @override
  FirebaseFirestore firestore = FakeFirebaseFirestore();

  @override
  Future<List<RocketModel>> fetchRockets([bool forcedUpdate = false]) async {
    final rocketJsonFile =
        await rootBundle.loadString("assets/mocks/rocket_launches.json");
    final rocketJson = json.decode(rocketJsonFile);

    List<RocketModel> rocketCollection = [];

    (rocketJson['data']['rockets'] as List<dynamic>).forEach((json) {
      rocketCollection.add(RocketModel.fromJson(json));
    });

    return rocketCollection;
  }
}
