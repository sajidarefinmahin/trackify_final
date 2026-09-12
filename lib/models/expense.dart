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
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    DateTime parsedDate;
    final dynamic dateVal = json['date'];
    if (dateVal is String) {
      parsedDate = DateTime.tryParse(dateVal) ?? DateTime.now();
    } else if (dateVal != null) {
      try {
        parsedDate = (dateVal as dynamic).toDate();
      } catch (_) {
        parsedDate = DateTime.now();
      }
    } else {
      parsedDate = DateTime.now();
    }

    return Expense(
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      category: json['category'] as String? ?? '',
      date: parsedDate,
      note: json['note'] as String? ?? '',
    );
  }

  /// Convenient helper to format the date as day/month/year
  String get formattedDate => '${date.day}/${date.month}/${date.year}';

  /// Convenient helper to format amount in Taka currency format
  String get formattedAmount => '৳ ${amount.toStringAsFixed(2)}';
}
