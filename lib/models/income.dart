class Income {
  final double amount;
  final String source;
  final DateTime date;
  final String note;

  Income({
    required this.amount,
    required this.source,
    required this.date,
    required this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'source': source,
      'date': date.toIso8601String(),
      'note': note,
    };
  }

  factory Income.fromJson(Map<String, dynamic> json) {
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

    return Income(
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      source: json['source'] as String? ?? '',
      date: parsedDate,
      note: json['note'] as String? ?? '',
    );
  }
}
