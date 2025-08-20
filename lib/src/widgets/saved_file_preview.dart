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
          Padding(padding: EdgeInsets.only(left: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Exported Image preview', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
              IconButton(
                onPressed: Navigator.of(context).pop,
                icon: Icon(Icons.close),
              ),
            ],
          ),
          ),
          Image.file(File(filePath)),
        ],
      ),
    );
  }
}
