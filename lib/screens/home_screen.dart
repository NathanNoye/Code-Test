import 'package:flutter/material.dart';
import 'package:thinkific_codetest/constants.dart';
import 'package:thinkific_codetest/widgets/rocket/rocket_list.dart';

class HomeScreen extends StatefulWidget {
  static const String id = Constants.homeScreen;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SpaceX Launches')),
      body: const RocketList(),
    );
  }
}
