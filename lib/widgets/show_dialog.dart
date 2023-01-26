import 'package:flutter/material.dart';

import 'error_dialog.dart';

Future<void> showCustomDialog(BuildContext context, Widget dialog) async {
  return showDialog<void>(
      context: context,
      builder: (c) {
        return dialog;
      });
}

Future<void> showErrorDialog(BuildContext context, String message) {
  return showCustomDialog(context, ErrorDialog(message: message));
}