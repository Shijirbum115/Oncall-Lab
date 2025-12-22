import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:oncall_lab/core/constants/qpay_config.dart';
import 'package:oncall_lab/data/models/payment_model.dart';

/// QPAY API Service for payment processing
///
/// Handles authentication, invoice creation, and payment verification with QPAY
/// Documentation: https://developer.qpay.mn
class QPayService {
  QPayAuthToken? _authToken;
  DateTime? _tokenExpiry;

  /// Get authentication token from QPAY
  Future<QPayAuthToken> _getAuthToken() async {
    // Return cached token if still valid
    if (_authToken != null && _tokenExpiry != null) {
      if (DateTime.now().isBefore(_tokenExpiry!.subtract(const Duration(minutes: 5)))) {
        return _authToken!;
      }
    }

    final url = Uri.parse('${QPayConfig.apiUrl}/auth/token');

    final credentials = base64Encode(
      utf8.encode('${QPayConfig.username}:${QPayConfig.password}'),
    );

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Basic $credentials',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      _authToken = QPayAuthToken.fromJson(json);
      _tokenExpiry = DateTime.now().add(
        Duration(seconds: _authToken!.expiresIn),
      );
      return _authToken!;
    } else {
      throw Exception('Failed to authenticate with QPAY: ${response.body}');
    }
  }

  /// Create a QPAY invoice
  Future<QPayInvoice> createInvoice({
    required int amountMnt,
    required String description,
    String? callbackUrl,
  }) async {
    if (!QPayConfig.isConfigured) {
      throw Exception('QPAY is not configured. Please set QPAY credentials in .env file');
    }

    final token = await _getAuthToken();
    final url = Uri.parse('${QPayConfig.apiUrl}/invoice');

    final requestBody = {
      'invoice_code': QPayConfig.invoiceCode,
      'sender_invoice_no': 'BUG${DateTime.now().millisecondsSinceEpoch}',
      'invoice_receiver_code': 'terminal',
      'invoice_description': description,
      'amount': amountMnt,
      'callback_url': callbackUrl ?? '${QPayConfig.apiUrl}/payment/check',
    };

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer ${token.accessToken}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return QPayInvoice.fromJson(json);
    } else {
      throw Exception('Failed to create QPAY invoice: ${response.body}');
    }
  }

  /// Check payment status
  Future<QPayPaymentCheck> checkPayment(String invoiceId) async {
    final token = await _getAuthToken();
    final url = Uri.parse('${QPayConfig.apiUrl}/payment/check');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer ${token.accessToken}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'object_type': 'INVOICE',
        'object_id': invoiceId,
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return QPayPaymentCheck.fromJson(json);
    } else {
      throw Exception('Failed to check payment status: ${response.body}');
    }
  }

  /// Cancel an invoice
  Future<bool> cancelInvoice(String invoiceId) async {
    final token = await _getAuthToken();
    final url = Uri.parse('${QPayConfig.apiUrl}/invoice/$invoiceId/cancel');

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer ${token.accessToken}',
        'Content-Type': 'application/json',
      },
    );

    return response.statusCode == 200;
  }

  /// Get invoice details
  Future<Map<String, dynamic>> getInvoiceDetails(String invoiceId) async {
    final token = await _getAuthToken();
    final url = Uri.parse('${QPayConfig.apiUrl}/invoice/$invoiceId');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${token.accessToken}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get invoice details: ${response.body}');
    }
  }

  /// Clear cached auth token (useful for testing or logout)
  void clearAuthToken() {
    _authToken = null;
    _tokenExpiry = null;
  }
}
