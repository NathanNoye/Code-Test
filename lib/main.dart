import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thinkific_codetest/locator.dart';
import 'package:thinkific_codetest/models/rocket_model.dart';
import 'package:thinkific_codetest/screens/home_screen.dart';
import 'package:thinkific_codetest/screens/rocket_detail_screen.dart';
import 'package:thinkific_codetest/screens/staging_error_screen.dart';
import 'package:thinkific_codetest/services/error_service.dart';
import 'package:thinkific_codetest/widgets/rocket/bloc/rocket_bloc.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // This will stop the app from erroring out and shutting down.
  // Catches all uncaught errors
  runZonedGuarded(() async {
    // * Developer note:
    /*
      This is where we would include the initial setup for our error and our error screen.
      In a release mode - when an error occurs that causes a "red" screen in debug builds, it will appear as a grey screen in release modes.
      This can be a nightmare to test in testflight because we aren't able to see the debug logs. It's also dificult to debug when external testers or shareholders use the testing builds and say they experienced a grey screen. This code below adds an error screen that will only appear in non-prod release builds (or any build that is in release mode and isn't a production build if we had an environment switcher).
      This screen also lets the tester click a button that will copy the entire error log to their clipboard so they can include it in an email.
      There is a screenshot in the readme of what this screen looks like
    */

    if (kReleaseMode) {
      ErrorWidget.builder =
          (FlutterErrorDetails details) => StagingErrorScreen(details: details);
    }

    // await locator<DeepLinkingService>().initUniLinks();
    runApp(
      BlocProvider(
        create: (context) => RocketBloc()..add(RocketFetched()),
        child: MyApp(),
      ),
    );
  }, (exception, stackTrace) async {
    await locator<ErrorService>().captureException(exception, stackTrace,
        debuggingMessage:
            'An uncaught error was caught in ZONE GUARDED in <main.dart> (This really should be caught at the appropriate scope)');
  });
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<RocketBloc, RocketState>(
      listener: (context, state) {
        if (state is RocketDetailSelected) {
          setState(() {});
        }
      },
      child: MaterialApp(
        title: 'SpaceX Launches',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Navigator(
          pages: [
            MaterialPage(
              child: HomeScreen(),
            ),
            if (BlocProvider.of<RocketBloc>(context).state
                is RocketDetailSelected)
              MaterialPage(
                child: RocketDetailScreen(
                  rocketModel: (BlocProvider.of<RocketBloc>(context)
                      .state
                      .props[0] as RocketModel),
                ),
              ),
          ],
          onPopPage: (route, result) {
            if (BlocProvider.of<RocketBloc>(context).state
                is RocketDetailSelected) {
              BlocProvider.of<RocketBloc>(context).add(RocketFetched());
            }

            return route.didPop(result);
          },
        ),
      ),
    );
  }
}
