import 'dart:io';
import 'package:dio/dio.dart';

import 'base_service.dart';

class ImageService extends BaseApiService {
  /// Upload file to backend `/upload` route
  Future<String> uploadFile(File file) async {
    final fileName = file.path.split('/').last;

    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: fileName),
      });

      final response = await dio.post('/files/upload', data: formData);
      return response.data['url'];
    } on DioException catch (e) {
      throw handleError(e);
    }
  }

  /// Get signed URL to access the file from S3
  Future<String> getFileUrl(String key) async {
    try {
      final response = await dio.get('/files/get-url/$key');
      return response.data['url'];
    } on DioException catch (e) {
      throw handleError(e);
    }
  }

  /// Generate a pre-signed URL for direct S3 upload
  Future<String> generatePreSignedUploadUrl({
    required String filename,
    required String contentType,
  }) async {
    try {
      final response =
          await dio.get('/files/generate-upload-url', queryParameters: {
        'filename': filename,
        'content_type': contentType,
      });

      return response.data['upload_url'];
    } on DioException catch (e) {
      throw handleError(e);
    }
  }

  /// Directly upload file to preSigned S3 URL
  Future<void> uploadToPreSignedUrl(
    String url,
    File file,
    String contentType,
  ) async {
    try {
      final bytes = await file.readAsBytes();

      await Dio().put(
        url,
        data: bytes,
        options: Options(
          headers: {
            'Content-Type': contentType,
          },
        ),
      );
    } on DioException catch (e) {
      throw handleError(e);
    }
  }
}
