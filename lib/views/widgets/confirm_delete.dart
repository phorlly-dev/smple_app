import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmButtonText;
  final String cancelButtonText;
  final Color confirmButtonColor;

  const DeleteConfirmationDialog({
    super.key,
    this.title = 'Confirm Delete',
    this.content =
        'Are you sure you want to delete this item? This action cannot be undone.',
    this.confirmButtonText = 'Delete',
    this.cancelButtonText = 'Cancel',
    this.confirmButtonColor = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false); // User canceled
          },
          child: Text(cancelButtonText),
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: confirmButtonColor,
          ),
          onPressed: () {
            Navigator.of(context).pop(true); // User confirmed
          },
          child: Text(confirmButtonText),
        ),
      ],
    );
  }
}
