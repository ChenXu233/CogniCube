import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import '../view_models/auth_view_model.dart';
import 'package:provider/provider.dart';
// import 'package:go_router/go_router.dart';

import 'routes.dart';

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
        receiveTimeout: const Duration(seconds: 30),
        responseType: ResponseType.json,
      ),
    );

    // 添加拦截器
    _dio.interceptors.add(
      InterceptorsWrapper(onRequest: _handleRequest, onError: _handleError),
    );
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
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
    String errorMessage = '网络请求错误';
    if (error.response != null) {
      errorMessage = error.response?.data['message'] ?? errorMessage;
    } else {
      errorMessage = error.message ?? errorMessage;
    }
    print('Dio Error: ${error.message}');

    final modifiedError = DioException(
      requestOptions: error.requestOptions,
      response: error.response,
      error: errorMessage,
      type: error.type,
    );

    if (error.response?.statusCode == 401) {
      _performLogout();
    }

    handler.next(modifiedError); //报错
  }

  // void _gotoPage(BuildContext context, String routeName) {
  //   context.go(routeName);
  // }

  void _performLogout() {
    _prefs.remove('auth_token');
    if (navigatorKey.currentContext != null) {
      final authVM = Provider.of<AuthViewModel>(
        navigatorKey.currentContext!,
        listen: false,
      );
      authVM.logout();
    }
  }

  Dio get dio => _dio;
}
