import 'dart:typed_data';

Future<String?> platformSavePdf(Uint8List bytes, String fileName) =>
    throw UnsupportedError('Platform not supported');

Future<void> platformOpenFileLocation(String filePath) =>
    throw UnsupportedError('Platform not supported');
