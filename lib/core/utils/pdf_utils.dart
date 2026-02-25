import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PdfUtils {
  static Future<({String text, String fileName})?> pickAndExtractText() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'txt'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final fileName = result.files.single.name;
        final extension = result.files.single.extension?.toLowerCase();

        String text;
        if (extension == 'pdf') {
          text = await _extractTextFromPdf(file);
        } else {
          text = await file.readAsString();
        }
        return (text: text, fileName: fileName);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to read file: $e');
    }
  }

  static Future<String> _extractTextFromPdf(File file) async {
    try {
      final PdfDocument document = PdfDocument(inputBytes: await file.readAsBytes());
      String text = PdfTextExtractor(document).extractText();
      document.dispose();
      return text;
    } catch (e) {
      throw Exception('Error extracting PDF text: $e');
    }
  }

  static Future<File> saveTempText(String text) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/cv_text_${DateTime.now().millisecondsSinceEpoch}.txt');
    return await file.writeAsString(text);
  }
}
