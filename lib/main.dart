import 'package:flutter/material.dart';

import 'models/expense.dart';
import 'screens/home_screen.dart';
import 'screens/add_expense_screen.dart';
import 'screens/history_screen.dart';
import 'screens/categories_screen.dart';

void main() {
  runApp(const ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          primary: Colors.green,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
      ),
      home: const AppStart(),
    );
  }
}

class AppStart extends StatefulWidget {
  const AppStart({super.key});

  @override
  State<AppStart> createState() => _AppStartState();
}

class _AppStartState extends State<AppStart> {
  final List<Expense> expenses = [];

  int currentIndex = 0;
  bool showSplash = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          showSplash = false;
        });
      }
    });
  }

  void addExpense(Expense expense) {
    setState(() {
      expenses.add(expense);
    });
  }

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  Widget getCurrentPage() {
    switch (currentIndex) {
      case 0:
        return HomeScreen(
          expenses: expenses,
          onNavigation: changePage,
        );

      case 1:
        return AddExpenseScreen(
          onAddExpense: addExpense,
          onNavigation: changePage,
        );

      case 2:
        return HistoryScreen(
          expenses: expenses,
          onNavigation: changePage,
        );

      case 3:
        return CategoriesScreen(
          onNavigation: changePage,
        );

      default:
        return HomeScreen(
          expenses: expenses,
          onNavigation: changePage,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (showSplash) {
      return const SplashContent();
    }

    return getCurrentPage();
  }
}

class SplashContent extends StatelessWidget {
  const SplashContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.account_balance_wallet,
              size: 80,
              color: Colors.white,
            ),
            SizedBox(height: 20),
            Text(
              'Expense Tracker',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Track your money easily',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
