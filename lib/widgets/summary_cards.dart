import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SummaryCards extends StatelessWidget {
  final double totalMasuk;
  final double totalKeluar;
  final double saldo;

  const SummaryCards({
    super.key,
    required this.totalMasuk,
    required this.totalKeluar,
    required this.saldo,
  });

  String rupiah(num v) => NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(v);

  @override
  Widget build(BuildContext context) {
    Widget card(String title, String value, IconData icon) {
      return Expanded(
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Icon(icon),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: Theme.of(context).textTheme.labelMedium),
                      const SizedBox(height: 6),
                      Text(value, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        card('Masuk', rupiah(totalMasuk), Icons.arrow_downward),
        const SizedBox(width: 10),
        card('Keluar', rupiah(totalKeluar), Icons.arrow_upward),
        const SizedBox(width: 10),
        card('Saldo', rupiah(saldo), Icons.account_balance_wallet_outlined),
      ],
    );
  }
}
