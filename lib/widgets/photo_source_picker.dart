import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class PhotoSourcePicker extends StatelessWidget {
  final void Function(File file) onSelected;

  const PhotoSourcePicker({super.key, required this.onSelected});

  Future<void> _pick(BuildContext context, ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source);
    if (picked != null) {
      Navigator.pop(context);
      onSelected(File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      actions: [
        CupertinoActionSheetAction(
          onPressed: () => _pick(context, ImageSource.gallery),
          child: const Text('Media library',
              style: TextStyle(color: Color(0xFF007AFF))),
        ),
        CupertinoActionSheetAction(
          onPressed: () => _pick(context, ImageSource.camera),
          child:
              const Text('Camera', style: TextStyle(color: Color(0xFF007AFF))),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel',
            style: TextStyle(
                color: Color(0xFF007AFF), fontWeight: FontWeight.w600)),
      ),
    );
  }
}
