
import 'package:flutter/material.dart';

typedef DialogOptions<T> = Map<String, T?> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogOptions optionBuilder,
}) {
  final option = optionBuilder();
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
        content: Text(content, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),),
        actions: option.keys.map((optionTitle) {
          final T value = option[optionTitle];
          return TextButton(
              onPressed: () {
                if (value != null) {
                  Navigator.of(context).pop(value);
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Text(optionTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),));
        }).toList(),
      );
    },
  );
}