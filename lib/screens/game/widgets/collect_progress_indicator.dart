import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shapes_outdoor/models/game_state.dart';

class CollectProgressIndicator extends StatefulWidget {
  const CollectProgressIndicator({Key? key}) : super(key: key);

  @override
  State<CollectProgressIndicator> createState() =>
      _CollectProgressIndicatorState();
}

class _CollectProgressIndicatorState extends State<CollectProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  DateTime? _from;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: collectTime);
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    final state = Provider.of<GameState>(context, listen: true);
    if (state.collectStartTime != _from) {
      _from = state.collectStartTime;
      _controller.reset();
      if (_from != null) {
        _controller.animateTo(1.0, duration: collectTime);
      }
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final value = _from != null ? _controller.value : 0.0;
    return LinearProgressIndicator(
      key: ValueKey<double>(value),
      value: value,
    );
  }
}
