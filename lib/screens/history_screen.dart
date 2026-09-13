import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/income.dart';
import '../widgets/bottom_nav.dart';
import 'expense_details_screen.dart';

class HistoryScreen extends StatelessWidget {
  final List<Expense> expenses;
  final List<Income> incomes;
  final Function(int) onNavigation;

  const HistoryScreen({
    super.key,
    required this.expenses,
    this.incomes = const [],
    required this.onNavigation,
  });

  @override
  Widget build(BuildContext context) {
    final List<dynamic> allTransactions = [
      ...expenses,
      ...incomes,
    ]..sort((a, b) {
        final DateTime dateA = a is Expense ? a.date : (a as Income).date;
        final DateTime dateB = b is Expense ? b.date : (b as Income).date;
        return dateB.compareTo(dateA);
      });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text('Transaction History'),
        centerTitle: true,
