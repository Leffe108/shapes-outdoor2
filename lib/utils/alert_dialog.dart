import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

Future<void> showAlert(BuildContext context, Widget title, Widget message) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: title,
      content: message,
      actions: [
        TextButton(
          child: const Text('Ok'),
          onPressed: () {
            Routemaster.of(context).pop();
          },
        ),
      ],
    ),
  );
}
