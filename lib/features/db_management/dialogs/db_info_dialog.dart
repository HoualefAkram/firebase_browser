import 'package:firebase_browser/features/db_management/models/remote_db.dart';
import 'package:flutter/material.dart';

Future<RemoteDatabase?> showDbInfoDialog(BuildContext context) async {
  return showDialog(context: context, builder: (context) => DbInfoDialog());
}

class DbInfoDialog extends StatefulWidget {
  const DbInfoDialog({super.key});

  @override
  State<DbInfoDialog> createState() => _DbInfoDialogState();
}

class _DbInfoDialogState extends State<DbInfoDialog> {
  late TextEditingController urlController;
  late TextEditingController nameController;

  bool isNameValid = true;
  bool isUrlValid = true;

  @override
  void initState() {
    urlController = TextEditingController();
    nameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    urlController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const SelectableText("DATABASE"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: urlController,
            decoration: InputDecoration(
              hint: SelectableText("url"),
              label: const SelectableText("url"),
              errorText: isUrlValid ? null : "url can't be empty",
            ),
          ),
          SizedBox(height: 12),
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              hint: Text("name"),
              label: const Text("name"),
              errorText: isNameValid ? null : "name can't be empty",
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(null);
          },
          child: const Text("CANCEL"),
        ),
        TextButton(
          onPressed: () {
            final String dbUrl = urlController.text;
            final String dbName = nameController.text;
            if (dbUrl.trim().isEmpty) {
              setState(() {
                isUrlValid = false;
                isNameValid = dbName.trim().isNotEmpty;
              });

              return;
            }
            if (dbName.trim().isEmpty) {
              setState(() {
                isNameValid = false;
                isUrlValid = dbUrl.trim().isNotEmpty;
              });
              return;
            }

            Navigator.of(context).pop(RemoteDatabase(name: dbName, url: dbUrl));
          },
          child: const Text("ADD"),
        ),
      ],
    );
  }
}
