import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

Future<String?> platformSavePdf(Uint8List bytes, String fileName) async {
  final result = await FilePicker.platform.saveFile(
    dialogTitle: 'Save PDF',
    fileName: fileName,
    type: FileType.custom,
    allowedExtensions: ['pdf'],
  );

  if (result == null) return null;

  final savePath = result.endsWith('.pdf') ? result : '$result.pdf';
  await File(savePath).writeAsBytes(bytes);
  return savePath;
}

Future<void> platformOpenFileLocation(String filePath) async {
  await Process.run('explorer', ['/select,', filePath]);
}
