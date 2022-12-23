import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thinkific_codetest/models/rocket_model.dart';

class RocketDetailScreen extends StatefulWidget {
  final RocketModel rocketModel;

  RocketDetailScreen({required this.rocketModel});

  @override
  State<RocketDetailScreen> createState() => _RocketDetailScreenState();
}

class _RocketDetailScreenState extends State<RocketDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rocket details'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.chevron_left_sharp),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.rocketModel.name,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'First flight: ${DateFormat('MMM d, y').format(widget.rocketModel.firstFlight)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            Text(widget.rocketModel.description),
            SizedBox(height: 20),
            Text(
              'Rocket info',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
                'Rocket mass: ${widget.rocketModel.massInKG} kg | ${widget.rocketModel.massInPounds} lbs'),
            Text(
                'Rocket mass: ${widget.rocketModel.heightInMeters} m | ${widget.rocketModel.heightInFeet} ft'),
            if (widget.rocketModel.rocketEngineModel.engines != null)
              Text(
                  'Engine model: ${widget.rocketModel.rocketEngineModel.engines}'),
            Text(
                'Engine type: ${describeEnum(widget.rocketModel.rocketEngineModel.type)}'),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
