import 'package:dio/dio.dart';
import 'package:doggzi/models/general_model.dart';
import 'package:doggzi/services/base_api_service.dart';

class GeneralService extends BaseApiService {
  Future<GeneralModel> getGeneralSettings() async {
    try {
      final response = await dio.get('/custom/get-all');
      return GeneralModel.fromJson(response.data);
    } on DioException catch (e) {
      throw handleError(e);
    }
  }
}
