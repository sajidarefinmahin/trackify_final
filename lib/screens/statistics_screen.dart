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
    double total = 0;

    for (Expense expense in expenses) {
      if (expense.category == category) {
        total += expense.amount;
      }
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {
    final List<String> categories = [
      'Food',
      'Transport',
      'Shopping',
      'Bills',
      'Entertainment',
      'Health',
      'Education',
      'Other',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: infoCard(
                    'Income',
                    '৳ ${totalIncome.toStringAsFixed(2)}',
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: infoCard(
                    'Expense',
                    '৳ ${totalExpense.toStringAsFixed(2)}',
                    Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            infoCard(
              'Balance',
              '৳ ${balance.toStringAsFixed(2)}',
              Colors.blue,
            ),
            const SizedBox(height: 25),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Expense by Category',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ...categories.map((category) {
              return Card(
                child: ListTile(
                  title: Text(category),
                  trailing: Text(
                    '৳ ${categoryTotal(category).toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget infoCard(
    String title,
    String value,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
