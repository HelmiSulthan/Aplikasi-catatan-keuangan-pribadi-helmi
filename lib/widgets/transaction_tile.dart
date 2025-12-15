import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionTile extends StatelessWidget {
  final Tx tx;
  final String categoryName;
  final Widget trailing;
  final VoidCallback? onTap;

  const TransactionTile({
    super.key,
    required this.tx,
    required this.categoryName,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // ❌ JANGAN pakai locale id_ID
    final dateStr = DateFormat('dd MMM yyyy').format(tx.date);
    final typeStr = tx.type == TxType.masuk ? 'MASUK' : 'KELUAR';

    return ListTile(
      onTap: onTap,
      title: Text(tx.note?.isNotEmpty == true ? tx.note! : categoryName),
      subtitle: Text('$dateStr • $typeStr • $categoryName'),
      trailing: trailing,
    );
  }
}
