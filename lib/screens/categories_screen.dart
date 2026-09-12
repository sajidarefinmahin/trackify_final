import 'package:flutter/material.dart';
import '../data/categories.dart';
import '../widgets/bottom_nav.dart';

class CategoriesScreen extends StatelessWidget {
  final Function(int) onNavigation;

  const CategoriesScreen({
    super.key,
    required this.onNavigation,
  });

  IconData getCategoryIcon(String category) {
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
        title: const Text('Categories'),
        centerTitle: true,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: expenseCategories.length,
        itemBuilder: (context, index) {
          final category = expenseCategories[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green.shade100,
                child: Icon(
                  getCategoryIcon(category),
                  color: Colors.green,
                ),
              ),
              title: Text(
