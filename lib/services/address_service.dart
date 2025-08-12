import 'package:dio/dio.dart';
import 'package:doggzi/models/address_model.dart';
import 'package:doggzi/services/base_api_service.dart';

class AddressService extends BaseApiService {
  Future<List<AddressModel>> getAddresses() async {
    try {
      final response = await dio.get('/addresses/all');
      return (response.data as List)
          .map((item) => AddressModel.fromJson(item))
          .toList();
    } on DioException catch (e) {
      throw handleError(e);
    }
  }

  Future<AddressModel> addAddress(AddressModel address) async {
    try {
      final response = await dio.post('/addresses/', data: address.toJson());
      return AddressModel.fromJson(response.data);
    } on DioException catch (e) {
      throw handleError(e);
    }
  }
}
