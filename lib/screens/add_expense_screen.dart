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
      date: selectedDate,
      note: noteController.text,
    );

    await widget.onAddExpense(expense);

    amountController.clear();
    noteController.clear();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Expense added successfully'),
      ),
    );

    widget.onNavigation(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text('Add Expense'),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xFFE8F5E9),
                child: Icon(
                  Icons.money_off,
                  size: 40,
                  color: Colors.green,
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'Amount',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
