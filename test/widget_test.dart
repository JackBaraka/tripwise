// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:tripwise/app/tripwise_app.dart';

void main() {
  testWidgets('App launches to TripWise home', (WidgetTester tester) async {
    await tester.pumpWidget(const TripwiseApp());
    await tester.pumpAndSettle();

    expect(find.text('TripWise'), findsWidgets);
    expect(find.textContaining('Plan smarter trips.'), findsOneWidget);
  });
}
