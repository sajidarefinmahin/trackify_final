import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

import 'models/expense.dart';
import 'models/income.dart';
import 'screens/home_screen.dart';
import 'screens/add_expense_screen.dart';
import 'screens/history_screen.dart';
import 'screens/categories_screen.dart';
import 'screens/add_income_screen.dart';
import 'screens/statistics_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {
  const ExpenseTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trackify',
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
      home: AuthGate(home: const AppStart()),
    );
  }
}

class AppStart extends StatefulWidget {
  final String? userId;

  const AppStart({
    super.key,
    this.userId,
  });

  @override
  State<AppStart> createState() => _AppStartState();
}

class _AppStartState extends State<AppStart> {
  final List<Expense> expenses = [];
  final List<Income> incomes = [];

  int currentIndex = 0;
  bool showSplash = true;
  bool isLoadingData = true;

  StreamSubscription<User?>? _authSubscription;
  String? _loadedUid;

  bool get _isFirebaseAvailable {
    try {
      return Firebase.apps.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  String? get _currentUid {
    if (widget.userId != null && widget.userId!.isNotEmpty) {
      return widget.userId;
    }
    if (_loadedUid != null && _loadedUid!.isNotEmpty) {
      return _loadedUid;
    }
    if (_isFirebaseAvailable) {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null && user.uid.isNotEmpty) {
          return user.uid;
        }
      } catch (e) {
        debugPrint('Error getting currentUser: $e');
      }
      return null;
    } else {
      // Test environment without Firebase
      return 'test_user';
    }
  }

  @override
  void initState() {
    super.initState();

    final initialUid = _currentUid;
    if (initialUid != null && initialUid.isNotEmpty) {
      _loadedUid = initialUid;
      _loadSavedData(initialUid);
    } else if (!_isFirebaseAvailable) {
      _loadedUid = 'test_user';
      _loadSavedData('test_user');
    }

    if (_isFirebaseAvailable) {
      // Listen for authenticated user changes
      _authSubscription =
          FirebaseAuth.instance.authStateChanges().listen((user) {
        if (user != null && user.uid.isNotEmpty) {
          if (_loadedUid != user.uid) {
            _loadedUid = user.uid;
            _loadSavedData(user.uid);
          }
        }
      });
    }

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          showSplash = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadSavedData(String uid) async {
    if (_isFirebaseAvailable && uid.isNotEmpty && uid != 'test_user') {
      try {
        debugPrint('Loading expenses from Firestore for uid: $uid');
        final expenseSnap = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('expenses')
            .get();

        final List<Expense> loadedExpenses = [];
        for (final doc in expenseSnap.docs) {
          loadedExpenses.add(Expense.fromJson(doc.data()));
        }

        debugPrint('Loading incomes from Firestore for uid: $uid');
        final incomeSnap = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('incomes')
            .get();

        final List<Income> loadedIncomes = [];
        for (final doc in incomeSnap.docs) {
          loadedIncomes.add(Income.fromJson(doc.data()));
        }

        debugPrint(
            'Loaded from Firestore: ${loadedExpenses.length} expenses, ${loadedIncomes.length} incomes');

        if (mounted) {
          setState(() {
            expenses.clear();
            expenses.addAll(loadedExpenses);
            incomes.clear();
            incomes.addAll(loadedIncomes);
            isLoadingData = false;
          });
        }
        return;
      } catch (e) {
        debugPrint('Error loading from Firestore: $e');
      }
    }

    // Local SharedPreferences fallback for test environment
    try {
      debugPrint('Loading expenses for key: ${uid}_expenses');
      debugPrint('Loading incomes for key: ${uid}_incomes');

      final prefs = await SharedPreferences.getInstance();
      await prefs.reload();
      final expensesJson = prefs.getString('${uid}_expenses');
      final incomesJson = prefs.getString('${uid}_incomes');

      final List<Expense> loadedExpenses = [];
      if (expensesJson != null && expensesJson.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(expensesJson);
        for (final item in decoded) {
          if (item is Map) {
            loadedExpenses.add(Expense.fromJson(Map<String, dynamic>.from(item)));
          }
        }
      }

      final List<Income> loadedIncomes = [];
      if (incomesJson != null && incomesJson.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(incomesJson);
        for (final item in decoded) {
          if (item is Map) {
            loadedIncomes.add(Income.fromJson(Map<String, dynamic>.from(item)));
          }
        }
      }

      debugPrint('Loaded expenses: ${loadedExpenses.length}');
      debugPrint('Loaded incomes: ${loadedIncomes.length}');

      if (mounted) {
        setState(() {
          expenses.clear();
          expenses.addAll(loadedExpenses);
          incomes.clear();
          incomes.addAll(loadedIncomes);
          isLoadingData = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading saved data: $e');
      if (mounted) {
        setState(() {
          isLoadingData = false;
        });
      }
    }
  }

  Future<void> _saveExpensesLocally() async {
    final uid = _currentUid;
    if (uid == null || uid.isEmpty) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final String data = jsonEncode(expenses.map((e) => e.toJson()).toList());
      await prefs.setString('${uid}_expenses', data);
    } catch (e) {
      debugPrint('Error saving expenses locally: $e');
    }
  }

  Future<void> _saveIncomesLocally() async {
    final uid = _currentUid;
    if (uid == null || uid.isEmpty) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final String data = jsonEncode(incomes.map((i) => i.toJson()).toList());
      await prefs.setString('${uid}_incomes', data);
    } catch (e) {
      debugPrint('Error saving incomes locally: $e');
    }
  }

  Future<void> addExpense(Expense expense) async {
    setState(() {
      expenses.add(expense);
    });

    final uid = _currentUid;
    if (_isFirebaseAvailable && uid != null && uid.isNotEmpty && uid != 'test_user') {
      try {
        debugPrint('Saving expense to Firestore: users/$uid/expenses');
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('expenses')
            .add(expense.toJson());
        debugPrint('Successfully saved expense to Firestore');
      } catch (e) {
        debugPrint('Error saving expense to Firestore: $e');
      }
    } else {
      await _saveExpensesLocally();
    }
  }

  Future<void> addIncome(Income income) async {
    setState(() {
      incomes.add(income);
    });

    final uid = _currentUid;
    if (_isFirebaseAvailable && uid != null && uid.isNotEmpty && uid != 'test_user') {
      try {
        debugPrint('Saving income to Firestore: users/$uid/incomes');
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('incomes')
            .add(income.toJson());
        debugPrint('Successfully saved income to Firestore');
      } catch (e) {
