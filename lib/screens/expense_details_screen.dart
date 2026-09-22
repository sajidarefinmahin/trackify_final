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
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 30),
            detailRow('Category', expense.category),
            detailRow(
              'Date',
              '${expense.date.day}/${expense.date.month}/${expense.date.year}',
            ),
            detailRow(
              'Note',
              expense.note.isEmpty ? 'No note' : expense.note,
            ),
          ],
        ),
      ),
    );
  }

  Widget detailRow(String title, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
