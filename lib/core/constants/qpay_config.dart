import 'package:flutter_dotenv/flutter_dotenv.dart';

/// QPAY configuration for payment processing
///
/// QPAY is Mongolia's leading payment gateway
/// Documentation: https://developer.qpay.mn
class QPayConfig {
  /// QPAY API URL from environment variables
  /// Sandbox: https://sandbox-merchant.qpay.mn/v2
  /// Production: https://merchant.qpay.mn/v2
  static String get apiUrl =>
      dotenv.env['QPAY_API_URL'] ??
      _throwError('QPAY_API_URL not found in .env file');

  /// QPAY merchant username
  static String get username =>
      dotenv.env['QPAY_USERNAME'] ??
      _throwError('QPAY_USERNAME not found in .env file');

  /// QPAY merchant password
  static String get password =>
      dotenv.env['QPAY_PASSWORD'] ??
      _throwError('QPAY_PASSWORD not found in .env file');

  /// Invoice code for QPAY invoices
  static String get invoiceCode =>
      dotenv.env['QPAY_INVOICE_CODE'] ?? 'BUGAMED_INVOICE';

  static String _throwError(String message) {
    throw Exception(message);
  }

  /// Check if QPAY is properly configured
  static bool get isConfigured {
    try {
      return dotenv.env['QPAY_USERNAME']?.isNotEmpty == true &&
          dotenv.env['QPAY_PASSWORD']?.isNotEmpty == true;
    } catch (e) {
      return false;
    }
  }

  /// Check if using sandbox environment
  static bool get isSandbox =>
      apiUrl.contains('sandbox');
}
