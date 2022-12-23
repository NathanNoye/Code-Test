import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:redacted_codetest/constants.dart';
import 'package:redacted_codetest/locator.dart';
import 'package:redacted_codetest/models/rocket_model.dart';
import 'package:redacted_codetest/queries/rockets_query.dart';
import 'package:redacted_codetest/services/api_service.dart';

class RocketRepository {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // This will grab rockets from various sources
  // At first, the repo will check to see if we have any locally stored rockets.
  // If we do, it will check if the data is fresh or not.
  // If the data is fresh, the function will return those rockets.
  // If it's not, it will delete the old rocket data from the local cache and grab it from the internet
  // Once it's grabbed from the internet, it will store it in the local cache for X amount of time
  Future<List<RocketModel>> fetchRockets([bool forceUpdate = false]) async {
    List<RocketModel> rockets = [];

    // * This can be used to gather analytics on how long read and write processes take
    Stopwatch stopwatch = Stopwatch();
    stopwatch.start();
    // Get the collection to see if there's anything in the db
    debugPrint('Fetching rockets, checking local cache first');
    QuerySnapshot<Map<String, dynamic>> rocketsCollection =
        await firestore.collection("rockets").get();
    stopwatch.stop();
    debugPrint(
        '==== firebase query took ${stopwatch.elapsedMilliseconds / 1000} seconds ====');

    if (forceUpdate) {
      debugPrint('Force update is true, grabbing from internet');

      rockets = await _getRocketsFromAPI(rocketsCollection)
        ..sort((a, b) => b.firstFlight.compareTo(a.firstFlight));

      return rockets;
    }

    // Checks first to see if we have any rockets stored in our local DB.
    // Will return empty if there is no rockets stored OR if the data is stale - There's a note below about caching and implementation choices
    debugPrint('Checking rocket collection from firebase');
    rockets = await _getRocketsFromFirebase(rocketsCollection);

    // If the collection is empty, we'll want to grab it from the internet but first we'll want to confirm that the user even has a connection to the internet
    if (rockets.isEmpty) {
      debugPrint(
          'Local rocket collection is empty, checking internet connection');
      ConnectivityResult connection = await Connectivity().checkConnectivity();

      // If they're offline and the local collection is empty, throw an error since we won't be able to update the collection
      if (connection == ConnectivityResult.none) {
        debugPrint('Local data is empty and no internet connection is present');
        throw 'Local data is empty and no internet connection is present';
      }

      // If we've reached this point - the user should have a connection and can grab the latest info
      debugPrint(
          'Local collection is empty or stale but we have a connection, grabbing data from the API');
      rockets = await _getRocketsFromAPI(rocketsCollection);

      debugPrint('Got rockets from api');
    } else {
      debugPrint('Rocket collection is fresh, using local data');
    }

    // Sort them by newest to oldest
    rockets.sort((a, b) => b.firstFlight.compareTo(a.firstFlight));
    return rockets;
  }

  // Grabs the latest info from the API and stores it in the local DB
  Future<List<RocketModel>> _getRocketsFromAPI(
      QuerySnapshot<Map<String, dynamic>> rocketsCollection) async {
    List<RocketModel> rockets = [];

    // * This can be used to gather analytics on how long read and write processes take
    Stopwatch stopwatch = Stopwatch();
    stopwatch.start();
    dynamic result = await locator<ApiService>().graphQL(
      url: '${Constants.spacexBaseUrl}${Constants.graphQL}',
      query: getRocketsQuery(),
    );
    stopwatch.stop();
    debugPrint(
        '==== GraphQL query took ${stopwatch.elapsedMilliseconds / 1000} seconds ====');

    if (rocketsCollection.docs.isNotEmpty) {
      // Delete the old local values after we've received the data from the API call
      rocketsCollection.docs.forEach(((element) => element.reference.delete()));
    }

    (result['rockets'] as List).forEach((element) async {
      Map<String, dynamic> json = element as Map<String, dynamic>;

      rockets.add(RocketModel.fromJson(json));

      json.addAll({"lastUpdated": DateTime.now().toIso8601String()});

      // Add a new document with a generated ID
      await firestore.collection("rockets").add(json);
    });

    return rockets;
  }

  // * Developer note - In prod for this specific situation, I'd go with a Hive implementation if we only required local storage and caching since it's so fast.
  // * If this was going to be something that required remote storage (like favouriting a rocket launch), then I would FireBase for this kind of implementation.
  Future<List<RocketModel>> _getRocketsFromFirebase(
      QuerySnapshot<Map<String, dynamic>> rocketsCollection) async {
    List<RocketModel> rockets = [];
    int cacheDuration = 60;

    // If there's nothing in the db, return an empty collection
    if (rocketsCollection.docs.isEmpty) {
      return [];
    } else {
      // * Developer note - I chose the for-in loop opposed to the forEach loop since we can use the break keyword if in the future we ever wanted to break the loop and continue the code below instead of short circuiting it
      for (QueryDocumentSnapshot<Map<String, dynamic>> doc
          in rocketsCollection.docs) {
        if (DateTime.parse(doc.data()['lastUpdated']).isBefore(
            DateTime.now().subtract(Duration(minutes: cacheDuration)))) {
          return [];
        } else {
          rockets.add(RocketModel.fromJson(doc.data()));
        }
      }
    }
    return rockets;
  }
}
