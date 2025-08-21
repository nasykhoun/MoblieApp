import 'package:flutter/material.dart';

Future<bool?> showDeleteDialog(
  BuildContext context, {
  String title = "Delete Confirmation",
  String content = "Do you want to delete this item?",
  String discard = "DISCARD",
  String delete = "DELETE",
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(discard),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text(delete),
          ),
        ],
      );
    },
  );
}
