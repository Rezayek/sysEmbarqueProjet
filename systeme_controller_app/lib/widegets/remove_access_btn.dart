import 'package:flutter/material.dart';

class RemoveAccessBtn extends StatelessWidget {
  const RemoveAccessBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
            height: 60,
            width: 95,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 38, 0),
              borderRadius: BorderRadius.circular(26),
            ),
            child: const Center(
                child: Text(
              'Remove access',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            )),
        );
  }
}