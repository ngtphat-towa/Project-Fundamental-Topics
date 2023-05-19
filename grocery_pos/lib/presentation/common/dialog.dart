import 'package:flutter/material.dart';

Future<bool?> showDialogDeleteConfirm({
  required BuildContext context,
  required String modelType,
}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Do you delete this $modelType ?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Yes'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('No'),
        ),
      ],
    ),
  );
}
Future<bool?> showDiagLogExitForm(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Do you want to exit form?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }