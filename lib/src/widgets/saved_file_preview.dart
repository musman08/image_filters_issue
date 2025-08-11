import 'dart:io';

import 'package:flutter/material.dart';

class SavedFilePreviewDialog extends StatelessWidget {
  const SavedFilePreviewDialog({super.key, required this.filePath});

  final String filePath;

  Future<void> show(BuildContext context) async {
    showDialog(context: context, builder: (context) => this);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: Navigator.of(context).pop,
              icon: Icon(Icons.close),
            ),
          ),
          Image.file(File(filePath)),
        ],
      ),
    );
  }
}
