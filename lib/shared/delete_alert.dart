import 'package:flutter/material.dart';

class CustomDeleteAlert {
  void deleteAlert({
    required BuildContext context,
    required String item,
    required Function()? cancelFunction,
    required Function()? yesFunction,
  }) {

    Widget cancelButton = TextButton(
      onPressed: cancelFunction,
      child: const Text('Cancel'),
    );

    Widget yesButton = TextButton(
      onPressed: yesFunction,
      child: const Text('Yes'),
    );

    AlertDialog dialog =AlertDialog(
      title: const Text('Delete'),
      content: Text('Are you sure you want to delete this ${item}?'),
      actions: [cancelButton, yesButton],
    );

    showDialog(
      context: context,
      builder: (_) {
        return dialog;
      }
    );
  }
}