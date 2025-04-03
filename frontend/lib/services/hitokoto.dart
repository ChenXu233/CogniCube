import 'package:dio/dio.dart';
import '../models/hitokoto_model.dart';

class OneSentenceApiService {
  static final Dio _dio = Dio();

  // 获取每日一言
  static Future<OneSentence> getDailySentence() async {
    try {
      final response = await _dio.get('https://api.xygeng.cn/openapi/one');
      if (response.statusCode == 200) {
        print(response.data['data']);
        final data = response.data['data'];
        return OneSentence.fromJson(data);
      } else {
        throw Exception('请求失败: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('网络请求失败: ${e.message}');
    }
  }
}

// 需要大改，网上的一言都不太行，需要人工筛选。
