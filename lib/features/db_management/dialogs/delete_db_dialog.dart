import 'package:flutter/material.dart';

Future<bool?> showDeleteDbDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const SelectableText("Warning"),
      content: const SelectableText(
        "Are you sure you want to delete this database?",
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text("CANCEL"),
        ),

        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text("DELETE"),
        ),
      ],
    ),
  );
}
