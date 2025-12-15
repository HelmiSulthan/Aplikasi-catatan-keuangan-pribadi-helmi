import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../models/category.dart';
import '../repositories/transaction_repository.dart';
import '../repositories/category_repository.dart';

class TransactionFormScreen extends StatefulWidget {
  final Tx? editing;

  const TransactionFormScreen({super.key, this.editing});

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final txRepo = TransactionRepository();
  final catRepo = CategoryRepository();

  late DateTime date;
  late TxType type;
  int? categoryId;

  final amountCtrl = TextEditingController();
  final noteCtrl = TextEditingController();

  List<CategoryModel> categories = [];
  bool loading = false;
  bool catLoading = true;

  @override
  void initState() {
    super.initState();
    final e = widget.editing;

    date = e?.date ?? DateTime.now();
    type = e?.type ?? TxType.keluar;
    categoryId = e?.categoryId;

    amountCtrl.text = e != null ? e.amount.toString() : '';
    noteCtrl.text = e?.note ?? '';

    loadCategories();
  }

  @override
  void dispose() {
    amountCtrl.dispose();
    noteCtrl.dispose();
    super.dispose();
  }

  Future<void> loadCategories() async {
    try {
      categories = await catRepo.getAll();
    } catch (e) {
      // ignore, handled in UI
    }
    if (mounted) setState(() => catLoading = false);
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDate: date,
    );
    if (picked != null) {
      setState(() => date = picked);
    }
  }

  Future<void> save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    final tx = Tx(
      id: widget.editing?.id ?? 0,
      date: date,
      type: type,
      categoryId: categoryId,
      amount: double.parse(amountCtrl.text.replaceAll(',', '.')),
      note: noteCtrl.text.trim().isEmpty ? null : noteCtrl.text.trim(),
    );

    try {
      if (widget.editing == null) {
        await txRepo.create(tx);
      } else {
        await txRepo.update(tx);
      }

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ $e')),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> remove() async {
    final id = widget.editing?.id;
    if (id == null) return;

    setState(() => loading = true);

    try {
      await txRepo.delete(id);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ $e')),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.editing != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Transaksi' : 'Tambah Transaksi'),
        actions: [
          if (isEdit)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: loading
                  ? null
                  : () async {
                      final ok = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Hapus transaksi?'),
                          content: const Text(
                              'Transaksi ini akan dihapus permanen.'),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(context, false),
                              child: const Text('Batal'),
                            ),
                            FilledButton(
                              onPressed: () =>
                                  Navigator.pop(context, true),
                              child: const Text('Hapus'),
                            ),
                          ],
                        ),
                      );

                      if (ok == true) {
                        await remove();
                      }
                    },
            ),
        ],
      ),
      body: AbsorbPointer(
        absorbing: loading,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    // ===== TANGGAL =====
                    InkWell(
                      onTap: pickDate,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Tanggal',
                          border: OutlineInputBorder(),
                          prefixIcon:
                              Icon(Icons.calendar_today_outlined),
                        ),
                        child: Text(
                          '${date.year.toString().padLeft(4, '0')}-'
                          '${date.month.toString().padLeft(2, '0')}-'
                          '${date.day.toString().padLeft(2, '0')}',
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ===== JENIS =====
                    DropdownButtonFormField<TxType>(
                      initialValue: type,
                      items: const [
                        DropdownMenuItem(
                          value: TxType.masuk,
                          child: Text('MASUK'),
                        ),
                        DropdownMenuItem(
                          value: TxType.keluar,
                          child: Text('KELUAR'),
                        ),
                      ],
                      onChanged: (v) =>
                          setState(() => type = v ?? TxType.keluar),
                      decoration: const InputDecoration(
                        labelText: 'Jenis',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.swap_vert),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ===== KATEGORI (API) =====
                    DropdownButtonFormField<int?>(
                      initialValue: categoryId,
                      items: catLoading
                          ? const []
                          : [
                              const DropdownMenuItem(
                                value: null,
                                child: Text('- tanpa kategori -'),
                              ),
                              ...categories.map(
                                (c) => DropdownMenuItem(
                                  value: c.id,
                                  child: Text(c.name),
                                ),
                              ),
                            ],
                      onChanged: (v) =>
                          setState(() => categoryId = v),
                      decoration: const InputDecoration(
                        labelText: 'Kategori',
                        border: OutlineInputBorder(),
                        prefixIcon:
                            Icon(Icons.sell_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ===== NOMINAL =====
                    TextFormField(
                      controller: amountCtrl,
                      keyboardType:
                          const TextInputType.numberWithOptions(
                              decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Nominal',
                        border: OutlineInputBorder(),
                        prefixIcon:
                            Icon(Icons.payments_outlined),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Nominal wajib diisi';
                        }
                        final parsed = double.tryParse(
                            v.replaceAll(',', '.'));
                        if (parsed == null || parsed <= 0) {
                          return 'Nominal tidak valid';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // ===== KETERANGAN =====
                    TextFormField(
                      controller: noteCtrl,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Keterangan (opsional)',
                        border: OutlineInputBorder(),
                        prefixIcon:
                            Icon(Icons.notes_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ===== SIMPAN =====
                    FilledButton.icon(
                      onPressed: loading ? null : save,
                      icon: const Icon(Icons.save_outlined),
                      label: const Text('Simpan'),
                    ),
                  ],
                ),
              ),
            ),

            // ===== LOADING OVERLAY =====
            if (loading)
              Container(
                color: Colors.black.withOpacity(0.2),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
