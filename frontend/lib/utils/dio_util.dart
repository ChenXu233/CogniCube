import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class DioUtil {
  static final DioUtil _instance = DioUtil._internal();
  late Dio _dio;
  late SharedPreferences _prefs;

  factory DioUtil() => _instance;
  SharedPreferences get prefs => _prefs;

  DioUtil._internal() {
    _initDio();
    _initSharedPreferences();
  }

  void _initDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: Constants.backendUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 60),
        responseType: ResponseType.json,
      ),
    );

    // 添加拦截器
    _dio.interceptors.add(
      InterceptorsWrapper(onRequest: _handleRequest, onError: _handleError),
    );
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> _handleRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 动态获取最新 token
    final token = _prefs.getString('auth_token') ?? '';
    options.headers.addAll({
      'Content-Type': 'application/json',
      'token': token,
    });
    handler.next(options);
  }

  void _handleError(DioException error, ErrorInterceptorHandler handler) {
    if (error.response?.statusCode == 401) {
      _performLogout();
    }
    handler.next(error);
  }

  void _performLogout() {
    _prefs.remove('auth_token');
    // 这里可以添加路由跳转到登录页的逻辑
  }

  Dio get dio => _dio;
}
