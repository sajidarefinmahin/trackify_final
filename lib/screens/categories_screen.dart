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
