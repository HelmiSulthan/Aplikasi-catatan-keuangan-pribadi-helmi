import '../models/transaction.dart';
import '../services/api_service.dart';

class TransactionRepository {
  Future<List<Tx>> getAll({DateTime? start, DateTime? end}) async {
    String endpoint = 'transaksi';

    if (start != null && end != null) {
      endpoint +=
          '?start=${_fmt(start)}&end=${_fmt(end)}';
    }

    final res = await ApiService.get(endpoint);
    final List data = res['data'];

    return data.map((e) {
      return Tx(
        id: int.parse(e['id'].toString()),
        date: DateTime.parse(e['tanggal']),
        type: e['jenis'] == 'MASUK' ? TxType.masuk : TxType.keluar,
        categoryId: e['kategori_id'] == null
            ? null
            : int.parse(e['kategori_id'].toString()),
        amount: double.parse(e['nominal'].toString()),
        note: e['keterangan'],
      );
    }).toList();
  }

  Future<void> create(Tx tx) async {
    await ApiService.post('transaksi', {
      'tanggal': _fmt(tx.date),
      'jenis': tx.type == TxType.masuk ? 'MASUK' : 'KELUAR',
      'kategori_id': tx.categoryId,
      'nominal': tx.amount,
      'keterangan': tx.note,
    });
  }

  Future<void> update(Tx tx) async {
    await ApiService.post('transaksi/update', {
      'id': tx.id,
      'tanggal': _fmt(tx.date),
      'jenis': tx.type == TxType.masuk ? 'MASUK' : 'KELUAR',
      'kategori_id': tx.categoryId,
      'nominal': tx.amount,
      'keterangan': tx.note,
    });
  }

  Future<void> delete(int id) async {
    await ApiService.delete('transaksi/delete?id=$id');
  }

  String _fmt(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}
