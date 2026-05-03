import 'package:bugamed/core/services/supabase_service.dart';

class QpayInvoice {
  final String localId;
  final String qpayInvoiceId;
  final String qrText;
  final String qrImage;
  final String shortUrl;
  final List<QpayBankDeeplink> deeplinks;
  final int amountMnt;

  const QpayInvoice({
    required this.localId,
    required this.qpayInvoiceId,
    required this.qrText,
    required this.qrImage,
    required this.shortUrl,
    required this.deeplinks,
    required this.amountMnt,
  });

  factory QpayInvoice.fromJson(Map<String, dynamic> json) {
    final rawLinks = (json['deeplinks'] as List?) ?? const [];
    return QpayInvoice(
      localId: json['qpay_payment_local_id'] as String,
      qpayInvoiceId: json['qpay_invoice_id'] as String,
      qrText: json['qr_text'] as String? ?? '',
      qrImage: json['qr_image'] as String? ?? '',
      shortUrl: json['short_url'] as String? ?? '',
      deeplinks: rawLinks
          .map((e) => QpayBankDeeplink.fromJson(e as Map<String, dynamic>))
          .toList(),
      amountMnt: (json['amount_mnt'] as num).toInt(),
    );
  }
}

class QpayBankDeeplink {
  final String name;
  final String description;
  final String logo;
  final String link;

  const QpayBankDeeplink({
    required this.name,
    required this.description,
    required this.logo,
    required this.link,
  });

  factory QpayBankDeeplink.fromJson(Map<String, dynamic> json) {
    return QpayBankDeeplink(
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      logo: json['logo'] as String? ?? '',
      link: json['link'] as String? ?? '',
    );
  }
}

enum QpayPaymentStatus {
  pending,
  paid,
  failed,
  cancelled,
  refunded,
  expired;

  static QpayPaymentStatus fromString(String value) {
    return QpayPaymentStatus.values.firstWhere(
      (s) => s.name == value,
      orElse: () => QpayPaymentStatus.pending,
    );
  }
}

class QpayRepository {
  Future<QpayInvoice> createInvoice({required String testRequestId}) async {
    final response = await supabase.functions.invoke(
      'qpay-create-invoice',
      body: {'test_request_id': testRequestId},
    );

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw Exception('Unexpected response from qpay-create-invoice: $data');
    }
    if (data['error'] != null) {
      throw Exception(data['error'].toString());
    }
    return QpayInvoice.fromJson(data);
  }

  Future<QpayPaymentStatus> checkPayment({required String localId}) async {
    final response = await supabase.functions.invoke(
      'qpay-check-payment',
      body: {'qpay_payment_local_id': localId},
    );

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw Exception('Unexpected response from qpay-check-payment: $data');
    }
    if (data['error'] != null) {
      throw Exception(data['error'].toString());
    }
    final status = data['status'] as String? ?? 'pending';
    return QpayPaymentStatus.fromString(status);
  }

  Stream<QpayPaymentStatus> watchInvoiceStatus({required String localId}) {
    return supabase
        .from('qpay_payments')
        .stream(primaryKey: ['id'])
        .eq('id', localId)
        .map((rows) {
          if (rows.isEmpty) return QpayPaymentStatus.pending;
          final status = rows.first['status'] as String? ?? 'pending';
          return QpayPaymentStatus.fromString(status);
        });
  }
}
