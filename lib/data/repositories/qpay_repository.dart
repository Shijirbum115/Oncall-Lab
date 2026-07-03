import 'package:flutter/foundation.dart';
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
    final rawLinks =
        (json['deeplinks'] as List?) ??
        (json['qPay_deeplink'] as List?) ??
        (json['urls'] as List?) ??
        const [];

    final amountRaw = json['amount_mnt'];
    final amount = amountRaw is num ? amountRaw.toInt() : 0;

    return QpayInvoice(
      localId: json['qpay_payment_local_id'] as String,
      qpayInvoiceId: json['qpay_invoice_id'] as String,
      qrText: json['qr_text'] as String? ?? '',
      qrImage: json['qr_image'] as String? ?? '',
      shortUrl: json['short_url'] as String? ?? '',
      deeplinks: rawLinks
          .whereType<Map>()
          .map(
            (e) => QpayBankDeeplink.fromJson(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList(),
      amountMnt: amount,
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
    final session = supabase.auth.currentSession;
    final user = supabase.auth.currentUser;
    debugPrint(
      '🟣 [QPay] invoke create-invoice '
      'user=${user?.id ?? "NULL"} '
      'sessionExpired=${session?.isExpired} '
      'tokenLen=${session?.accessToken.length ?? 0} '
      'tokenPrefix=${session?.accessToken.substring(0, session.accessToken.length.clamp(0, 16)) ?? "NULL"}',
    );
    try {
      final response = await supabase.functions.invoke(
        'qpay-create-invoice',
        body: {'test_request_id': testRequestId},
      );
      final data = response.data;
      debugPrint('🟣 [QPay] response status=${response.status} data=$data');
      if (data is! Map) {
        throw Exception('Unexpected response from qpay-create-invoice: $data');
      }

      final map = Map<String, dynamic>.from(data);

      if (map['error'] != null) {
        throw Exception(map['error'].toString());
      }

      try {
        return QpayInvoice.fromJson(map);
      } catch (e, st) {
        debugPrint(
          '🔴 [QPay] parse failed: $e\n'
          'keys=${map.keys.toList()}\n'
          'types={qpay_payment_local_id:${map['qpay_payment_local_id']?.runtimeType}, '
          'qpay_invoice_id:${map['qpay_invoice_id']?.runtimeType}, '
          'deeplinks:${map['deeplinks']?.runtimeType}, '
          'qPay_deeplink:${map['qPay_deeplink']?.runtimeType}, '
          'urls:${map['urls']?.runtimeType}, '
          'amount_mnt:${map['amount_mnt']?.runtimeType}}\n$st',
        );
        rethrow;
      }
    } catch (e, st) {
      debugPrint('🔴 [QPay] invoke threw: $e\n$st');
      rethrow;
    }
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
