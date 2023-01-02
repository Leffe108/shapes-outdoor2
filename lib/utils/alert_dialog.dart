import 'package:flutter/material.dart';

Future<void> showAlert(BuildContext context, Widget title, Widget message,
    {String buttonText = 'Ok'}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: title,
      content: message,
      actions: [
        TextButton(
          child: Text(
            buttonText,
            style: Theme.of(context).textTheme.button,
          ),
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
  BuildContext context,
  Widget title,
  Widget message, {
  String yesButtonText = 'Yes',
  String noButtonText = 'No',
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: title,
      content: message,
      actions: [
        TextButton(
          child: Text(
            yesButtonText,
            style: Theme.of(context).textTheme.button,
          ),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
        TextButton(
          child: Text(
            noButtonText,
            style: Theme.of(context).textTheme.button,
          ),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      ],
    ),
  );
  return result == true;
}
