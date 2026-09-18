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
