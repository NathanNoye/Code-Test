// A simple class for capturing errors.
// The role of this class is to handle errors in a consistent way. In production - we would send this data to our error logging database
// Since this is just a test - this will only log the error to the console.
import 'package:flutter/foundation.dart';

class ErrorService {
  Future<void> captureException(dynamic exception, dynamic stackTrace,
      {String debuggingMessage = ''}) async {
    debugPrint(
        '====================================================================================');
    debugPrint(
        'Exception captured. This is a code test so this information is not sent to the error log database.');
    debugPrint('$debuggingMessage');
    debugPrint('$exception');
    debugPrint('$stackTrace');
    debugPrint(
        '====================================================================================');
  }
}
