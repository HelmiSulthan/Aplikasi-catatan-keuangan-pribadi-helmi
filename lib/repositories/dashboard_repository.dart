import '../services/api_service.dart';

class DashboardRepository {
  Future<Map<String, double>> getSummary() async {
    final res = await ApiService.get('dashboard');

    final data = res['data'];
    return {
      'masuk': (data['total_masuk'] as num).toDouble(),
      'keluar': (data['total_keluar'] as num).toDouble(),
      'saldo': (data['saldo'] as num).toDouble(),
    };
  }
}
