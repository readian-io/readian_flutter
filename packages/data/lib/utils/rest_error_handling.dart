import 'package:dio/dio.dart';

Future<T> withRestErrorHandling<T>({
  required Future<T> Function() block,
  required T Function(Exception exception) errorBlock,
}) async {
  try {
    return await block();
  } catch (e) {
    if (e is Exception) {
      return errorBlock(e);
    } else {
      return errorBlock(Exception(e.toString()));
    }
  }
}
