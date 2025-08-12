import 'package:dio/dio.dart';
import 'package:doggzi/models/menu_model.dart';
import 'package:doggzi/services/base_api_service.dart';

class MenuService extends BaseApiService {
  Future<MenuModel> getMenuItem(String id) async {
    try {
      final response = await dio.get('/menu/$id');
      return MenuModel.fromJson(response.data);
    } on DioException catch (e) {
      throw handleError(e);
    }
  }

  Future<List<MenuModel>> getMenuItems(
      DietType dietType, Species species, FoodType foodType) async {
    try {
      Map<String, String> parameters = {
        if (dietType != DietType.all) 'diet_type': dietType.name,
        if (species != Species.all) 'species': species.name,
        if (foodType != FoodType.all) 'food_type': foodType.name,
      };
      final response = await dio.get(
        '/menu',
        queryParameters: parameters,
      );

      return (response.data as List)
          .map((item) => MenuModel.fromJson(item))
          .toList();
    } on DioException catch (e) {
      throw handleError(e);
    }
  }

  Future<MenuModelList> getAllMenuItems() async {
    try {
      final response = await dio.get(
        '/menu/all',
      );

      return MenuModelList.fromJson(response.data);
    } on DioException catch (e) {
      throw handleError(e);
    }
  }
}
