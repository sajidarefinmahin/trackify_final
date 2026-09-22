import 'package:flutter/material.dart';

import '../models/expense.dart';

class ExpenseDetailsScreen extends StatelessWidget {
  final Expense expense;

  const ExpenseDetailsScreen({
    super.key,
    required this.expense,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(
              Icons.receipt_long,
              size: 70,
              color: Colors.green,
            ),
            const SizedBox(height: 20),
            Text(
              '৳ ${expense.amount.toStringAsFixed(2)}',
