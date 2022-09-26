import 'package:flutter/material.dart';

class SuccessAlert {
  void successAlert({
    required BuildContext context,
    required String content,
    required Function()? okFunction,
  }) {

    Widget yesButton = TextButton(
      onPressed: okFunction,
      child: const Text('Yes'),
    );

    AlertDialog dialog =AlertDialog(
      content: Text(content),
      actions: [yesButton],
    );

    showDialog(
        context: context,
        builder: (_) {
          return dialog;
        }
    );
  }
}