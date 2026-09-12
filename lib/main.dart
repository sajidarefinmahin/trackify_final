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
