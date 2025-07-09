import 'package:dio/dio.dart';
import 'package:doggzi/models/menu_model.dart';
import 'package:doggzi/services/base_service.dart';

class MenuService extends BaseApiService {
  Future<MenuModel> getMenuItem(String id) async {
    try {
      final response = await dio.get('/menu/$id');
      return MenuModel.fromJson(response.data);
    } on DioException catch (e) {
      throw handleError(e);
    }
  }

  Future<List<MenuModel>> getMenuItems() async {
    try {
      final response = await dio.get('/menu');
      List<dynamic> data = response.data;
      return data.map((item) => MenuModel.fromJson(item)).toList();
    } on DioException catch (e) {
      throw handleError(e);
    }
  }
}
