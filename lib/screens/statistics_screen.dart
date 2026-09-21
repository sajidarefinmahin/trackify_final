import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../models/income.dart';

class StatisticsScreen extends StatelessWidget {
  final List<Expense> expenses;
  final List<Income> incomes;

  const StatisticsScreen({
    super.key,
    required this.expenses,
    required this.incomes,
  });

  double get totalExpense {
    double total = 0;

    for (Expense expense in expenses) {
      total += expense.amount;
    }

    return total;
  }

  double get totalIncome {
    double total = 0;

    for (Income income in incomes) {
      total += income.amount;
    }

    return total;
  }

  double get balance {
    return totalIncome - totalExpense;
  }

  double categoryTotal(String category) {
