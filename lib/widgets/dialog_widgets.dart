import 'package:flutter/material.dart';

showDialogWidget({
  required BuildContext context,
  required bool success,
  required String message,
}) {
  return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
            backgroundColor:
                success ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.errorContainer,
            contentPadding: const EdgeInsets.fromLTRB(15, 30, 15, 30),
            alignment: Alignment.center,
            children: [
              Center(
                  child: Column(
                children: [
                  Icon(
                    success ? Icons.done_outlined : Icons.error_outline,
                    size: 48,
                    color: success
                        ? Theme.of(context).colorScheme.onPrimaryContainer
                        : Theme.of(context).colorScheme.onErrorContainer,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: success
                          ? Theme.of(context).colorScheme.onPrimaryContainer
                          : Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ],
              ))
            ],
          ));
}
