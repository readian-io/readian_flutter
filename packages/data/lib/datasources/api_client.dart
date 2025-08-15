import 'package:dio/dio.dart';

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  // Auth endpoints
  Future<Response<Map<String, dynamic>>> login(Map<String, dynamic> loginData) async {
    return await _dio.post('/auth/login', data: loginData);
  }

  Future<Response<Map<String, dynamic>>> register(Map<String, dynamic> registerData) async {
    return await _dio.post('/auth/register', data: registerData);
  }

  Future<Response<Map<String, dynamic>>> refreshToken(Map<String, dynamic> refreshData) async {
    return await _dio.post('/auth/refresh', data: refreshData);
  }

  // Posts endpoints
  Future<Response<Map<String, dynamic>>> getSpotlightPosts(int page, int limit) async {
    return await _dio.get('/posts/spotlight', queryParameters: {
      'page': page,
      'limit': limit,
    });
  }

  Future<Response<Map<String, dynamic>>> getPostById(String postId) async {
    return await _dio.get('/posts/$postId');
  }

  Future<Response<Map<String, dynamic>>> likePost(String postId) async {
    return await _dio.post('/posts/$postId/like');
  }

  Future<Response<Map<String, dynamic>>> unlikePost(String postId) async {
    return await _dio.delete('/posts/$postId/like');
  }

  // Subscriptions endpoints
  Future<Response<Map<String, dynamic>>> getSubscriptions() async {
    return await _dio.get('/subscriptions');
  }

  Future<Response<Map<String, dynamic>>> subscribeToTag(String tagId) async {
    return await _dio.post('/subscriptions/$tagId');
  }

  Future<Response<Map<String, dynamic>>> unsubscribeFromTag(String tagId) async {
    return await _dio.delete('/subscriptions/$tagId');
  }

  // Library endpoints
  Future<Response<Map<String, dynamic>>> getSavedPosts(int page, int limit) async {
    return await _dio.get('/library/saved', queryParameters: {
      'page': page,
      'limit': limit,
    });
  }

  Future<Response<Map<String, dynamic>>> savePost(String postId) async {
    return await _dio.post('/library/save/$postId');
  }

  Future<Response<Map<String, dynamic>>> unsavePost(String postId) async {
    return await _dio.delete('/library/save/$postId');
  }

  // Profile endpoints
  Future<Response<Map<String, dynamic>>> getProfile() async {
    return await _dio.get('/profile');
  }

  Future<Response<Map<String, dynamic>>> updateProfile(Map<String, dynamic> profileData) async {
    return await _dio.put('/profile', data: profileData);
  }
}