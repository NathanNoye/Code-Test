import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redacted_codetest/widgets/rocket/bloc/rocket_bloc.dart';
import 'package:redacted_codetest/widgets/rocket/rocket_list_item.dart';

class RocketList extends StatefulWidget {
  const RocketList({super.key});

  @override
  State<RocketList> createState() => _RocketListState();
}

class _RocketListState extends State<RocketList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RocketBloc, RocketState>(
      builder: (context, state) {
        // The initial state  - this is what the widget will start with. This state will kick the BLoC off and will fetch the rocket data
        if (state is RocketInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is RocketRefreshing || state is RocketLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // This is the success state. If there is no data - a message will be shown to the user. Otherwise we'll show the list of rockets
        if (state is RocketFetchLoaded) {
          if (state.rockets.isEmpty) {
            return const Center(child: Text('no rockets to display'));
          }

          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return RocketListItem(rocketModel: state.rockets[index]);
              },
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: state.rockets.length,
              controller: _scrollController,
            ),
          );
        }

        // If something went wrong, this will allow the user to try again
        if (state is RocketFetchFailed) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Failed to fetch posts'),
                TextButton(onPressed: _retry, child: Text('Try again'))
              ],
            ),
          );
        }

        return Container();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _onRefresh() async {
    context.read<RocketBloc>().add(RocketRefreshed());
  }

  void _retry() {
    context.read<RocketBloc>().add(RocketFetched());
  }
}
