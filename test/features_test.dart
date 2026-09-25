import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trackify_sd/main.dart';
import 'package:trackify_sd/models/expense.dart';
import 'package:trackify_sd/models/income.dart';
import 'package:trackify_sd/screens/home_screen.dart';
import 'package:trackify_sd/screens/add_income_screen.dart';
import 'package:trackify_sd/screens/expense_details_screen.dart';
import 'package:trackify_sd/screens/history_screen.dart';
import 'package:trackify_sd/screens/profile_screen.dart';
import 'package:trackify_sd/screens/statistics_screen.dart';
import 'package:trackify_sd/screens/login_screen.dart';
import 'package:trackify_sd/screens/register_screen.dart';
import 'package:trackify_sd/screens/forgot_password_screen.dart';

void main() {
  group('New Features Integration Tests', () {
    testWidgets('AddIncomeScreen adds income successfully and navigates',
        (WidgetTester tester) async {
      Income? addedIncome;
      int? navigatedIndex;

      await tester.pumpWidget(
        MaterialApp(
          home: AddIncomeScreen(
            onAddIncome: (income) => addedIncome = income,
            onNavigation: (index) => navigatedIndex = index,
          ),
        ),
      );

      expect(find.text('Add Income'), findsWidgets);
      expect(find.text('Amount'), findsOneWidget);

      final amountField = find.widgetWithText(TextField, 'Enter amount');
      await tester.enterText(amountField, '1500');

      final noteField = find.byType(TextField).last;
      await tester.enterText(noteField, 'Freelance work');

      final saveButton = find.widgetWithText(ElevatedButton, 'Add Income');
      await tester.ensureVisible(saveButton);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      expect(addedIncome, isNotNull);
      expect(addedIncome!.amount, 1500.0);
      expect(addedIncome!.source, 'Salary');
      expect(addedIncome!.note, 'Freelance work');
      expect(navigatedIndex, 0);
    });

    testWidgets('ExpenseDetailsScreen displays expense information correctly',
        (WidgetTester tester) async {
      final expense = Expense(
        amount: 250.75,
        category: 'Food',
        date: DateTime(2026, 9, 19),
        note: 'Dinner with friends',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: ExpenseDetailsScreen(expense: expense),
        ),
      );

      expect(find.text('Expense Details'), findsOneWidget);
      expect(find.text('৳ 250.75'), findsOneWidget);
      expect(find.text('Category'), findsOneWidget);
      expect(find.text('Food'), findsOneWidget);
      expect(find.text('Date'), findsOneWidget);
      expect(find.text('19/9/2026'), findsOneWidget);
      expect(find.text('Note'), findsOneWidget);
      expect(find.text('Dinner with friends'), findsOneWidget);
    });

    testWidgets('HistoryScreen opens ExpenseDetailsScreen when expense tapped',
        (WidgetTester tester) async {
      final expense = Expense(
        amount: 100.0,
        category: 'Transport',
        date: DateTime(2026, 9, 19),
        note: 'Bus fare',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: HistoryScreen(
            expenses: [expense],
            onNavigation: (_) {},
          ),
        ),
      );

      expect(find.text('Transport'), findsOneWidget);
      await tester.tap(find.text('Transport'));
      await tester.pumpAndSettle();

      expect(find.text('Expense Details'), findsOneWidget);
      expect(find.text('৳ 100.00'), findsOneWidget);
      expect(find.text('Bus fare'), findsOneWidget);
    });

    testWidgets('StatisticsScreen accurately calculates income, expense, and balance',
        (WidgetTester tester) async {
      final expenses = [
        Expense(
          amount: 200,
          category: 'Food',
          date: DateTime.now(),
          note: '',
        ),
        Expense(
          amount: 300,
          category: 'Bills',
          date: DateTime.now(),
          note: '',
        ),
      ];

      final incomes = [
        Income(
          amount: 1200,
          source: 'Salary',
          date: DateTime.now(),
          note: '',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: StatisticsScreen(
            expenses: expenses,
            incomes: incomes,
          ),
        ),
      );

      expect(find.text('Statistics'), findsOneWidget);
      expect(find.text('৳ 1200.00'), findsOneWidget); // Total Income
      expect(find.text('৳ 500.00'), findsOneWidget); // Total Expense
      expect(find.text('৳ 700.00'), findsOneWidget); // Balance = 1200 - 500 = 700
      expect(find.text('Expense by Category'), findsOneWidget);
    });

    testWidgets('ProfileScreen renders profile items and switch toggles',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ProfileScreen(),
        ),
      );

      expect(find.text('Profile & Settings'), findsOneWidget);
      expect(find.text('Trackify User'), findsWidgets);
      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Dark Mode'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);

      final switches = find.byType(Switch);
      expect(switches, findsNWidgets(2));

      // Toggle dark mode
      await tester.tap(switches.last);
      await tester.pumpAndSettle();
    });

    testWidgets('LoginScreen renders and validates empty inputs',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LoginScreen(onLoginSuccess: () {}),
        ),
      );

      expect(find.text('Login'), findsWidgets);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Forgot Password?'), findsOneWidget);
      expect(find.text('Create Account'), findsOneWidget);

      final loginBtn = find.widgetWithText(ElevatedButton, 'Login');
      await tester.tap(loginBtn);
      await tester.pumpAndSettle();

      expect(find.text('Please enter email and password'), findsOneWidget);
    });

    testWidgets('RegisterScreen renders and validates empty inputs',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: RegisterScreen(),
        ),
      );

      expect(find.text('Create Account'), findsWidgets);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);

      final regBtn = find.widgetWithText(ElevatedButton, 'Create Account');
      await tester.tap(regBtn);
      await tester.pumpAndSettle();

      expect(find.text('Please enter email and password'), findsOneWidget);
    });

    testWidgets('ForgotPasswordScreen renders and validates empty input',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ForgotPasswordScreen(),
        ),
      );

      expect(find.text('Forgot Password'), findsWidgets);
      expect(find.text('Email'), findsOneWidget);

      final resetBtn =
          find.widgetWithText(ElevatedButton, 'Send Reset Email');
      await tester.tap(resetBtn);
      await tester.pumpAndSettle();

      expect(find.text('Please enter your email'), findsOneWidget);
    });

    testWidgets('HomeScreen accurately calculates Total Income, Total Expense, and Balance',
        (WidgetTester tester) async {
      final expenses = [
        Expense(
          amount: 350.0,
          category: 'Shopping',
          date: DateTime(2026, 9, 19),
          note: 'Groceries',
        ),
      ];

      final incomes = [
        Income(
          amount: 1000.0,
          source: 'Salary',
          date: DateTime(2026, 9, 19),
          note: 'Monthly salary',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(
            expenses: expenses,
            incomes: incomes,
            onNavigation: (_) {},
          ),
        ),
      );

      // Balance = 1000 - 350 = 650.00
      expect(find.text('৳ 650.00'), findsOneWidget);
      // Income = 1000.00
      expect(find.text('৳ 1000.00'), findsOneWidget);
      // Expense = 350.00
      expect(find.text('৳ 350.00'), findsOneWidget);
    });

    testWidgets('HistoryScreen displays both expense and income transactions with visual distinction',
        (WidgetTester tester) async {
      final expenses = [
        Expense(
          amount: 150.0,
          category: 'Transport',
          date: DateTime(2026, 9, 19),
          note: 'Uber',
        ),
      ];

      final incomes = [
        Income(
          amount: 500.0,
          source: 'Freelance',
          date: DateTime(2026, 9, 18),
          note: 'App project',
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: HistoryScreen(
            expenses: expenses,
            incomes: incomes,
            onNavigation: (_) {},
          ),
        ),
      );

      expect(find.text('Transaction History'), findsOneWidget);
      // Expense item with negative format
      expect(find.text('Transport'), findsOneWidget);
      expect(find.text('- ৳ 150.00'), findsOneWidget);

      // Income item with positive format
      expect(find.text('Freelance'), findsOneWidget);
      expect(find.text('+ ৳ 500.00'), findsOneWidget);
    });

    test('Expense and Income JSON serialization works correctly for persistence', () {
      final now = DateTime(2026, 9, 19, 14, 30);
      final expense = Expense(
        amount: 250.50,
        category: 'Food',
        date: now,
        note: 'Coffee and snacks',
      );

      final expenseJson = jsonEncode(expense.toJson());
      final restoredExpense = Expense.fromJson(jsonDecode(expenseJson));

      expect(restoredExpense.amount, 250.50);
      expect(restoredExpense.category, 'Food');
      expect(restoredExpense.date.toIso8601String(), now.toIso8601String());
      expect(restoredExpense.note, 'Coffee and snacks');

      final income = Income(
        amount: 3000.00,
        source: 'Salary',
        date: now,
        note: 'Part-time teaching',
      );

      final incomeJson = jsonEncode(income.toJson());
      final restoredIncome = Income.fromJson(jsonDecode(incomeJson));

      expect(restoredIncome.amount, 3000.00);
      expect(restoredIncome.source, 'Salary');
      expect(restoredIncome.date.toIso8601String(), now.toIso8601String());
      expect(restoredIncome.note, 'Part-time teaching');
    });

    testWidgets('Data persists across app restart: previously saved expenses and incomes reload into AppStart',
        (WidgetTester tester) async {
      final savedExpense = Expense(
        amount: 450.0,
        category: 'Food',
        date: DateTime(2026, 9, 19),
        note: 'Team lunch',
      );
      final savedIncome = Income(
        amount: 2500.0,
        source: 'Salary',
        date: DateTime(2026, 9, 19),
        note: 'Salary credit',
      );

      // Simulate local storage with previously saved data
      SharedPreferences.setMockInitialValues({
        'test_user_expenses': jsonEncode([savedExpense.toJson()]),
        'test_user_incomes': jsonEncode([savedIncome.toJson()]),
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: AppStart(),
        ),
      );

      // Advance past splash screen (2 seconds)
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Balance = 2500 - 450 = 2050.00
      expect(find.text('৳ 2050.00'), findsOneWidget);
      // Income = 2500.00
      expect(find.text('৳ 2500.00'), findsOneWidget);
      // Expense = 450.00
      expect(find.text('৳ 450.00'), findsOneWidget);
      // Recent transactions list
      expect(find.text('Food'), findsOneWidget);
      expect(find.text('- ৳ 450.00'), findsOneWidget);

      // Navigate to History screen
      await tester.tap(find.byIcon(Icons.history));
      await tester.pumpAndSettle();

      // Verify both saved items show in History
      expect(find.text('Transaction History'), findsOneWidget);
      expect(find.text('Food'), findsOneWidget);
      expect(find.text('- ৳ 450.00'), findsOneWidget);
      expect(find.text('Salary'), findsOneWidget);
      expect(find.text('+ ৳ 2500.00'), findsOneWidget);
    });

    testWidgets('AppStart with specific userId loads and saves under user-specific keys',
        (WidgetTester tester) async {
      final userExpense = Expense(
        amount: 80.0,
        category: 'Transport',
        date: DateTime(2026, 9, 19),
        note: 'Bus',
      );

      SharedPreferences.setMockInitialValues({
        'user_123_expenses': jsonEncode([userExpense.toJson()]),
        'user_123_incomes': jsonEncode([]),
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: AppStart(userId: 'user_123'),
        ),
      );

      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.text('৳ 80.00'), findsOneWidget);
      expect(find.text('Transport'), findsOneWidget);
    });
  });
}
