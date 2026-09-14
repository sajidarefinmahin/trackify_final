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
