import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/income.dart';
import '../widgets/bottom_nav.dart';
import 'statistics_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<Expense> expenses;
  final List<Income> incomes;
  final Function(int) onNavigation;

  const HomeScreen({
    super.key,
    required this.expenses,
    this.incomes = const [],
    required this.onNavigation,
  });

  double get totalExpense {
    double total = 0;

    for (var expense in expenses) {
      total += expense.amount;
    }

    return total;
  }

  double get totalIncome {
    double total = 0;

    for (var income in incomes) {
      total += income.amount;
    }

    return total;
  }

  double get balance => totalIncome - totalExpense;

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Food':
        return Icons.restaurant;
      case 'Transport':
        return Icons.directions_car;
      case 'Shopping':
        return Icons.shopping_bag;
      case 'Bills':
