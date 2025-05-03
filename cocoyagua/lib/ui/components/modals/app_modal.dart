import 'package:flutter/material.dart';

void showAppModal(BuildContext context, {
  required String title,
  required String message,
  bool isSuccess = true,
}) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Row(
        children: [
          Icon(isSuccess ? Icons.check_circle : Icons.error,
              color: isSuccess ? Colors.green : Colors.red),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
      content: Text(message),
      actions: [
        TextButton(
          child: const Text("Cerrar"),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    ),
  );
}
