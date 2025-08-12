import '../models/promo_code_model.dart';
import 'base_api_service.dart';

class PromoCodeService extends BaseApiService {
//   get all promo codes
  Future<List<PromoCode>> getAllPromoCodes() async {
    try {
      final response = await dio.get('/promo-codes/');
      return (response.data as List)
          .map((item) => PromoCode.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch promo codes: $e');
    }
  }
}
