import 'package:logger/logger.dart';

class LoggingService {
  static final _logger = Logger();
  static final _loggingSingle = LoggingService._internal();

  LoggingService._internal();

  factory LoggingService() {
    return _loggingSingle;
  }
}
