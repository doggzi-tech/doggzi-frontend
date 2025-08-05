// lib/services/pet_service.dart

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../models/pet_model.dart';
import 'base_api_service.dart';

class PetService extends BaseApiService {
  /// GET /pets
  Future<List<PetModel>> listPets() async {
    try {
      final response = await dio.get('/pets');
      final data = response.data as List;
      return data.map((json) => PetModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception(handleError(e));
    }
  }

  /// GET /pets/{id}
  Future<PetModel> getPet(String id) async {
    try {
      final response = await dio.get('/pets/$id');
      return PetModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(handleError(e));
    }
  }

  /// POST /pets
  Future<void> createPet(PetCreate pet) async {
    try {
      final response = await dio.post(
        '/pets/',
        data: pet.toJson(),
      );
    } on DioException catch (e) {
      throw Exception(handleError(e));
    }
  }

  /// PUT /pets/{id}
  Future<PetModel> updatePet(String id, PetUpdate pet) async {
    try {
      final response = await dio.put(
        '/pets/$id',
        data: pet.toJson(),
      );
      return PetModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(handleError(e));
    }
  }

  /// DELETE /pets/{id}
  Future<void> deletePet(String id) async {
    try {
      await dio.delete('/pets/$id');
    } on DioException catch (e) {
      throw Exception(handleError(e));
    }
  }
}
