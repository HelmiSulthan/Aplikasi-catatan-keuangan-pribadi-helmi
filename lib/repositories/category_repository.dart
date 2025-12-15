import '../models/category.dart';
import '../services/api_service.dart';

class CategoryRepository {
  Future<List<CategoryModel>> getAll() async {
    final res = await ApiService.get('kategori');
    final List data = res['data'];

    return data.map((e) {
      return CategoryModel(
        id: int.parse(e['id'].toString()),
        name: e['nama'],
      );
    }).toList();
  }

  Future<void> create(String name) async {
    await ApiService.post('kategori', {'nama': name});
  }

  Future<void> delete(int id) async {
    await ApiService.delete('kategori/delete?id=$id');
  }
}
