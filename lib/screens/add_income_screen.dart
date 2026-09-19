import 'package:flutter/material.dart';

import '../models/income.dart';

class AddIncomeScreen extends StatefulWidget {
  final Function(Income) onAddIncome;
  final Function(int) onNavigation;

  const AddIncomeScreen({
    super.key,
    required this.onAddIncome,
    required this.onNavigation,
  });

  @override
  State<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  String selectedSource = 'Salary';
  DateTime selectedDate = DateTime.now();

  final List<String> incomeSources = [
    'Salary',
    'Freelance',
    'Business',
    'Gift',
    'Other',
  ];

  Future<void> selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> saveIncome() async {
    final double? amount = double.tryParse(amountController.text);

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid amount'),
        ),
      );
      return;
    }

    final Income income = Income(
      amount: amount,
      source: selectedSource,
      date: selectedDate,
      note: noteController.text,
    );

    await widget.onAddIncome(income);

    amountController.clear();
    noteController.clear();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Income added successfully'),
      ),
    );

    widget.onNavigation(0);
  }

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Income'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => widget.onNavigation(0),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.account_balance_wallet,
              size: 50,
              color: Colors.green,
            ),
