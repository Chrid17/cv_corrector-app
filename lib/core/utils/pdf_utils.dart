import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfUtils {
  static Future<({String text, String fileName})?> pickAndExtractText() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'txt'],
        withData: true,
      );

      if (result != null && result.files.single.bytes != null) {
        final bytes = result.files.single.bytes!;
        final fileName = result.files.single.name;
        final extension = result.files.single.extension?.toLowerCase();

        String text;
        if (extension == 'pdf') {
          text = _extractTextFromPdfBytes(bytes);
        } else {
          text = String.fromCharCodes(bytes);
        }
        return (text: text, fileName: fileName);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to read file: $e');
    }
  }

  /// Pick an image file and return its bytes + metadata.
  static Future<({Uint8List bytes, String fileName, String extension})?> pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg', 'webp', 'bmp'],
        dialogTitle: 'Select Job Description Screenshot',
        withData: true,
      );

      if (result != null && result.files.single.bytes != null) {
        return (
          bytes: result.files.single.bytes!,
          fileName: result.files.single.name,
          extension: result.files.single.extension?.toLowerCase() ?? 'jpg',
        );
      }
      return null;
    } catch (e) {
      throw Exception('Failed to pick image: $e');
    }
  }

  static String _extractTextFromPdfBytes(Uint8List bytes) {
    try {
      final PdfDocument document = PdfDocument(inputBytes: bytes);
      String text = PdfTextExtractor(document).extractText();
      document.dispose();
      return text;
    } catch (e) {
      throw Exception('Error extracting PDF text: $e');
    }
  }
}
