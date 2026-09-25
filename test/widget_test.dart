import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:trackify_sd/data/categories.dart';
import 'package:trackify_sd/main.dart';

void main() {
  testWidgets('50% Milestone User Flow Test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    // App opens directly into Trackify (bypasses Firebase auth gate
    // because Firebase cannot be initialised in the Flutter unit-test sandbox).
    await tester.pumpWidget(
      const MaterialApp(
        home: AppStart(),
      ),
    );

    // 3. Splash screen appears
    expect(find.text('Trackify'), findsOneWidget);
    expect(find.text('Track your money easily'), findsOneWidget);

    // 4. Home screen opens after 2-second timer
    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(find.text('Total Balance'), findsOneWidget);
    expect(find.text('Recent Transactions'), findsOneWidget);
    expect(find.text('No expenses yet'), findsOneWidget);

    // 5. Go to Add Expense via FAB
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    expect(find.text('Add Expense'), findsWidgets);

    // 6. Enter 500
    final amountField = find.widgetWithText(TextField, 'Enter amount');
    await tester.enterText(amountField, '500');

    // 7. Select Food (already default first category)
    expect(find.text('Food'), findsOneWidget);

    // 8. Select today's date (already selected by default)
    final now = DateTime.now();
    expect(find.text('${now.day}/${now.month}/${now.year}'), findsOneWidget);

    // 9. Add optional note
    final noteField = find.widgetWithText(TextField, 'Optional note');
    await tester.enterText(noteField, 'Lunch with team');

    // 10. Press Add Expense
    final addButton = find.widgetWithText(ElevatedButton, 'Add Expense');
    await tester.ensureVisible(addButton);
    await tester.tap(addButton);
    await tester.pumpAndSettle();

    // 11. Return to Home
    expect(find.text('Total Balance'), findsOneWidget);

    // 12. Confirm Expense total changed to 500
    expect(find.text('৳ 500.00'), findsOneWidget);
    expect(find.text('৳ -500.00'), findsOneWidget);

    // 13. Confirm transaction appears under Recent Transactions
    expect(find.text('Food'), findsOneWidget);
    expect(find.text('- ৳ 500.00'), findsOneWidget);

    // 14. Open History
    await tester.tap(find.byIcon(Icons.history));
    await tester.pumpAndSettle();
    expect(find.text('Transaction History'), findsOneWidget);

    // 15. Confirm the 500 Food expense appears
    expect(find.text('Food'), findsOneWidget);
    expect(find.text('- ৳ 500.00'), findsOneWidget);

    // 16. Open Categories
    await tester.tap(find.byIcon(Icons.category_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Categories'), findsWidgets);

    // 17. Confirm all categories are displayed
    for (final category in expenseCategories) {
      await tester.scrollUntilVisible(
        find.text(category),
        50.0,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text(category), findsWidgets);
    }
  });
}
