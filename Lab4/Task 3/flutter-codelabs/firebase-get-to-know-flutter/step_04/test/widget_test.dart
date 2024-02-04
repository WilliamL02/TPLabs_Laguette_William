import 'package:flutter_test/flutter_test.dart';
import 'package:gtk_flutter/main.dart';

void main() {
  testWidgets('Basic rendering', (tester) async {
    await tester.pumpWidget(const App());

    expect(find.text('Firebase Meetup'), findsOneWidget);
    expect(find.text('January 1st'), findsNothing);
  });
}
