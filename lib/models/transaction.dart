enum TxType { masuk, keluar }

class Tx {
  final int id;
  final DateTime date;
  final TxType type;
  final int? categoryId;
  final double amount;
  final String? note;

  const Tx({
    required this.id,
    required this.date,
    required this.type,
    required this.amount,
    this.categoryId,
    this.note,
  });

  Tx copyWith({
    int? id,
    DateTime? date,
    TxType? type,
    int? categoryId,
    double? amount,
    String? note,
  }) {
    return Tx(
      id: id ?? this.id,
      date: date ?? this.date,
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      amount: amount ?? this.amount,
      note: note ?? this.note,
    );
  }
}
