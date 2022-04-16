import 'package:flutter/material.dart';
import 'package:systeme_controller_app/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog(
    context: context,
    title: 'An Error has occurred',
    content: text,
    optionBuilder: () => {'OK': null},
  );
}