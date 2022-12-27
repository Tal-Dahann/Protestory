import 'package:flutter/material.dart';
import 'package:protestory/constants/colors.dart';

class DiscardChanges extends StatelessWidget {
  final Widget child;

  const DiscardChanges({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title:
                    const Text('Are you sure you want to discard the changes?'),
                actionsAlignment: MainAxisAlignment.end,
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    style: TextButton.styleFrom(foregroundColor: purple),
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).popUntil(ModalRoute.withName('/'));
                    },
                    style: TextButton.styleFrom(foregroundColor: purple),
                    child: const Text('Yes'),
                  ),
                ],
              );
            },
          );
          return false;
        },
        child: child);
  }
}
