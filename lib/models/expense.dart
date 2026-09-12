class Expense {
  final double amount;
  final String category;
  final DateTime date;
  final String note;

  Expense({
    required this.amount,
    required this.category,
    required this.date,
    required this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'note': note,
    };
