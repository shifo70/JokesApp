import 'package:flutter_test/flutter_test.dart';
import 'package:room_booking_app/main.dart';

void main() {
  testWidgets('App launches splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const RoomBookingApp());
    expect(find.byType(RoomBookingApp), findsOneWidget);
  });
}
