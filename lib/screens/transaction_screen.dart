import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../repositories/transaction_repository.dart';
import '../widgets/amount_badge.dart';
import '../widgets/transaction_tile.dart';
import 'transaction_form_screen.dart';


class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final repo = TransactionRepository();

  List<Tx> items = [];
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      items = await repo.getAll();
    } catch (e) {
      error = e.toString();
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaksi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: load,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final ok = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => TransactionFormScreen(),
            ),
          );

          if (ok == true) load();
        },
        child: const Icon(Icons.add),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(child: Text('❌ $error'));
    }

    if (items.isEmpty) {
      return const Center(child: Text('Belum ada transaksi'));
    }

    return RefreshIndicator(
      onRefresh: load,
      child: ListView.separated(
        itemCount: items.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final tx = items[i];

          return TransactionTile(
            tx: tx,
            categoryName: tx.categoryId?.toString() ?? '-',
            trailing: AmountBadge(type: tx.type, amount: tx.amount),
            onTap: () async {
              final ok = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (_) => TransactionFormScreen(editing: tx),
                ),
              );

              if (ok == true) load();
            },
          );
        },
      ),
    );
  }
}
