import 'package:flutter/material.dart';
import '../data/categories.dart';
import '../models/expense.dart';
import '../widgets/bottom_nav.dart';

class AddExpenseScreen extends StatefulWidget {
  final Function(Expense) onAddExpense;
  final Function(int) onNavigation;

  const AddExpenseScreen({
    super.key,
    required this.onAddExpense,
    required this.onNavigation,
  });

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final TextEditingController amountController =
      TextEditingController();

  final TextEditingController noteController =
      TextEditingController();

  String selectedCategory = expenseCategories[0];

  DateTime selectedDate = DateTime.now();

  Future<void> selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> saveExpense() async {
    final amount = double.tryParse(amountController.text);

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid amount'),
        ),
      );
      return;
    }

    final expense = Expense(
      amount: amount,
      category: selectedCategory,
