import 'package:flutter/material.dart';

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
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}

/// Shows a dialog with yes/no buttons. Resolves to true if
/// user press Yes button, otherwise false.
Future<bool> showYesNoDialog(
    BuildContext context, Widget title, Widget message) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: title,
      content: message,
      actions: [
        TextButton(
          child: const Text('Yes'),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
        TextButton(
          child: const Text('No'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      ],
    ),
  );
  return result == true;
}
