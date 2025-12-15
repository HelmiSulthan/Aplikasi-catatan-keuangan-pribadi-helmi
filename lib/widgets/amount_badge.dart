import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class AmountBadge extends StatelessWidget {
  final TxType type;
  final double amount;

  const AmountBadge({super.key, required this.type, required this.amount});

  String rupiah(num v) => NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(v);

  @override
  Widget build(BuildContext context) {
    final isMasuk = type == TxType.masuk;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: isMasuk ? Colors.green.withOpacity(.12) : Colors.red.withOpacity(.12),
      ),
      child: Text(
        (isMasuk ? '+ ' : '- ') + rupiah(amount),
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: isMasuk ? Colors.green.shade700 : Colors.red.shade700,
        ),
      ),
    );
  }
}
