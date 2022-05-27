import 'package:flutter/material.dart';

class PlayerMarkerWidget extends StatelessWidget {
  const PlayerMarkerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[300],
        borderRadius: const BorderRadius.all(Radius.circular(10000)),
        border: Border.all(
          color: Colors.blue,
        ),
      ),
    );
  }
}
