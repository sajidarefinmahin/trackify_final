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
        return Icons.receipt_long;
      case 'Entertainment':
        return Icons.movie;
      case 'Health':
        return Icons.health_and_safety;
      case 'Education':
        return Icons.school;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text('Home'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: 'Statistics',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StatisticsScreen(
                    expenses: expenses,
                    incomes: incomes,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: 'Profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Balance Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Balance',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${expenses.length + incomes.length} recorded',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
