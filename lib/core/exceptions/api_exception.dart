import 'dart:developer';
import 'dart:io';

import 'package:saving/core/exceptions/app_exception.dart';

class ApiExcepion {
  ApiExcepion._();

  static String onError(dynamic exception) {
    String message;
    if (exception is AppException) {
      log(
        exception.message,
        error: exception.error,
        stackTrace: exception.stackTrace,
      );
      return exception.message;
    } else if (exception is SocketException) {
      log(
        'Socket exception occurred ${exception.message} on address  ${exception.address}',
      );
      return exception.message;
    }
    log('Something went wrong.... $exception');
    message = 'Somnething went wrong, please try again later!';
    return message;
  }
}
