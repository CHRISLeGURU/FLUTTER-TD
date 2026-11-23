import 'picked_file_data.dart';
export 'picked_file_data.dart';

import 'image_picker_stub.dart'
    if (dart.library.html) 'image_picker_web.dart' as picker;

Future<PickedFileData?> pickImageFile() {
  return picker.pickImageFile();
}
