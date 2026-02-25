import 'package:flutter_test/flutter_test.dart';
import 'package:cv_corrector/main.dart';

void main() {
  testWidgets('App builds without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const CvGeneratorApp());
    expect(find.text('CV'), findsOneWidget);
  });
}
