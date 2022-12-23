import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thinkific_codetest/models/rocket_model.dart';
import 'package:thinkific_codetest/widgets/rocket/bloc/rocket_bloc.dart';

class RocketListItem extends StatelessWidget {
  final RocketModel rocketModel;

  RocketListItem({
    required this.rocketModel,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: ValueKey(rocketModel.id),
      onTap: () {
        BlocProvider.of<RocketBloc>(context).add(RocketSelected(rocketModel));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${rocketModel.name}',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  'First launch: ${rocketModel.firstFlight.toIso8601String().split('T')[0]}',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            Icon(Icons.chevron_right_sharp)
          ],
        ),
      ),
    );
  }
}
