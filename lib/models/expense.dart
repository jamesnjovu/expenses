class Expense {
  int? id;
  String title;
  double amount;
  String date;

  Expense({
    this.id,
    required this.title,
    required this.amount,
    required this.date,
    required String category,
    required String? image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date,
    };
  }
}
