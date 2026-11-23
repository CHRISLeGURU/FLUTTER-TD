import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';

import 'picked_file_data.dart';

Future<PickedFileData?> pickImageFile() async {
  final uploadInput = html.FileUploadInputElement()
    ..accept = 'image/png,image/jpeg,image/jpg,image/webp,image/gif';
  uploadInput.click();

  final completer = Completer<PickedFileData?>();

  uploadInput.onChange.listen((event) {
    final files = uploadInput.files;
    if (files == null || files.isEmpty) {
      if (!completer.isCompleted) completer.complete(null);
      return;
    }

    final file = files[0];
    final reader = html.FileReader();

    reader.onLoadEnd.listen((event) {
      final result = reader.result;
      if (result is Uint8List) {
        if (!completer.isCompleted) {
          completer.complete(PickedFileData(name: file.name, bytes: result));
        }
      } else if (result is ByteBuffer) {
        if (!completer.isCompleted) {
          completer.complete(
            PickedFileData(name: file.name, bytes: result.asUint8List()),
          );
        }
      } else if (result is List<int>) {
        if (!completer.isCompleted) {
          completer.complete(PickedFileData(name: file.name, bytes: result));
        }
      } else {
        if (!completer.isCompleted) completer.complete(null);
      }
    });

    reader.onError.listen((_) {
      if (!completer.isCompleted) completer.complete(null);
    });

    reader.readAsArrayBuffer(file);
  });

  return completer.future;
}
