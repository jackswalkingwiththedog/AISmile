import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:venus/src/features/client/presentation/blocs/edit/edit_state.dart';

Future<String> handleUploadImage(
    {required String filename, required String folder}) async {
  final pickedFiles = await FilePicker.platform.pickFiles(withData: true);

  if (pickedFiles != null && pickedFiles.files.isNotEmpty) {
    final file = pickedFiles.files[0];
    final bytes = file.bytes;
    final upload = await FirebaseStorage.instance
        .ref('$folder/$filename')
        .putData(bytes as Uint8List,
            SettableMetadata(contentType: 'image/${file.extension}'));
    return upload.ref.getDownloadURL();
  }
  
  return Future(() => "");
}

Future<String> handleUploadPhoto({
  required PlatformFile file, required String filename, required String folder
}) async {
  final bytes = file.bytes;
  final streams = await FirebaseStorage.instance
        .ref('$folder/$filename')
        .putData(bytes as Uint8List,
            SettableMetadata(contentType: 'image/${file.runtimeType}'));
  return streams.ref.getDownloadURL();
}


Future<String> handleUploadPhotoFile({
  required FileData file, required String filename, required String folder
}) async {
  final bytes = file.bytes;
  final streams = await FirebaseStorage.instance
        .ref('$folder/$filename')
        .putData(bytes as Uint8List,
            SettableMetadata(contentType: 'image/${file.runtimeType}'));
  return streams.ref.getDownloadURL();
}

Future<String> handleUploadFile(
    {required String filename, required String folder}) async {
  final pickedFiles = await FilePicker.platform.pickFiles(withData: true);

  if (pickedFiles != null && pickedFiles.files.isNotEmpty) {
    final file = pickedFiles.files[0];
    final bytes = file.bytes;
    final upload = await FirebaseStorage.instance
        .ref('$folder/$filename')
        .putData(bytes as Uint8List);
    return upload.ref.getDownloadURL();
  }
  return Future(() => "");
}
