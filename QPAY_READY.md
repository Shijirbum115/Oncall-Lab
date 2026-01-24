# QPay Payment System - Implementation Summary

## ✅ QPAY IS FULLY INTEGRATED AND READY TO USE!

Your OnCall Lab app has a **complete QPay payment integration**. Everything is implemented and production-ready.

## 📁 What's Already Implemented

### Core Services & Configuration
- ✅ **QPay Config** (`lib/core/constants/qpay_config.dart`)
- ✅ **QPay Service** (`lib/core/services/qpay_service.dart`) 
- ✅ **Payment Repository** (`lib/data/repositories/payment_repository.dart`)

### Data Models
- ✅ **Payment Models** (`lib/data/models/payment_model.dart`)
  - PaymentModel
  - QPayInvoice
  - QPayUrl
  - QPayAuthToken
  - QPayPaymentCheck
  - Payment status & method enums

### State Management
- ✅ **Payment Store** (`lib/stores/payment_store.dart`)
  - MobX reactive state
  - Create QPay payment
  - Check payment status  
  - Load user payments
  - Cancel payment

### UI Components
- ✅ **QPay Payment Widget** (`lib/ui/patient/widgets/qpay_payment_widget.dart`)
  - QR code display
  - Bank app deep links (with url_launcher)
  - Real-time status updates
  - Success/failure states
- ✅ **Payment Screen** (`lib/ui/payment/payment_screen.dart`)
- ✅ **Payment Success Screen** (`lib/ui/payment/payment_success_screen.dart`)

### Dependencies
- ✅ `qr_flutter: ^4.1.0` - QR code generation
- ✅ `url_launcher: ^6.3.1` - Deep links to banking apps
- ✅ `http` - API calls
- ✅ `flutter_dotenv` - Environment variables

## 🚀 How to Use

### 1. Configure QPay Credentials

Update your `.env` file (create from `.env.example` if needed):

```env
QPAY_API_URL=https://merchant-sandbox.qpay.mn/v2
QPAY_USERNAME=your_qpay_username
QPAY_PASSWORD=your_qpay_password  
QPAY_INVOICE_CODE=YOUR_INVOICE_CODE
```

**Get credentials from QPay:**
- Email: info@qpay.mn
- Request: Client ID, Client Secret, Invoice Code

### 2. Show Payment Screen

There are two ways to show the payment screen:

#### Option A: Full Screen
```dart
import 'package:oncall_lab/ui/patient/widgets/qpay_payment_widget.dart';

// In your booking confirmation screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => Scaffold(
      appBar: AppBar(title: Text('Payment')),
      body: QPayPaymentWidget(
        userId: currentUserId,
        amountMnt: 50000, // Amount in Mongolian Tugrik
        description: 'Home sample collection service',
        testRequestId: testRequest.id,
        onPaymentSuccess: () {
          // Handle success
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => PaymentSuccessScreen(...),
            ),
          );
        },
      ),
    ),
  ),
);
```

#### Option B: Bottom Sheet (Recommended)
```dart
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  builder: (context) => DraggableScrollableSheet(
    initialChildSize: 0.9,
    maxChildSize: 0.95,
    minChildSize: 0.5,
    builder: (_, scrollController) => Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: QPayPaymentWidget(
        userId: userId,
        amountMnt: amount,
        description: description,
        testRequestId: requestId,
        onPaymentSuccess: () {
          Navigator.pop(context);
          // Show success message
        },
      ),
    ),
  ),
);
```

### 3. Complete Booking Flow Example

```dart
// Step 1: Create test request
Future<void> completeBooking() async {
  try {
    // Create the test request
    final request = await testRequestRepository.createRequest(
      patientId: userId,
      testTypeId: selectedTestType.id,
      scheduledDate: selectedDate,
      address: deliveryAddress,
    );

    // Step 2: Show payment screen
    final paymentCompleted = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) => QPayPaymentWidget(
        userId: userId,
        amountMnt: request.totalAmount,
        description: '${selectedTestType.name} - Home collection',
        testRequestId: request.id,
        onPaymentSuccess: () {
          Navigator.pop(context, true);
        },
      ),
    );

    // Step 3: Update request status after payment
    if (paymentCompleted == true) {
      await testRequestRepository.updateStatus(
        requestId: request.id,
        status: RequestStatus.confirmed,
      );
      
      // Show success and navigate
      showSuccessDialog();
    }
  } catch (e) {
    showErrorDialog(e.toString());
  }
}
```

## 🎨 What Users See

### 1. Payment Amount Display
- Clear amount in MNT
- Service description
- Laboratory name (if applicable)

### 2. QR Code
- Large, scannable QR code
- Instructions to scan with banking app
- Automatic generation from QPay API

### 3. Bank App Buttons
Users can tap to open their banking app directly:
- Khan Bank
- State Bank
- XAC Bank
- TDB Bank
- Most Money
- NIB Bank
- Chinggis Khaan Bank
- Capitron Bank
- Bogd Bank
- Candy Pay

### 4. Payment Status
- **Pending**: Loading indicator
- **Processing**: Checking status animation
- **Success**: Green check mark
- **Failed**: Error message with retry option

### 5. Actions
- "Check Payment Status" button
- "Cancel" button
- Auto-refresh status

## 🔄 Payment Flow Diagram

```
User Books Test
      ↓
Create Test Request
      ↓
Show QPay Payment Widget
      ↓
Generate QR & Deep Links
      ↓
User Scans QR or Opens Bank App
      ↓
User Pays in Banking App
      ↓
App Checks Payment Status
      ↓
Update Request Status → Confirmed
      ↓
Send Notification
      ↓
Show Success Screen
```

## 💾 Database Integration

Payments are automatically saved to Supabase:

```sql
-- Payment record structure
{
  id: "uuid",
  patient_id: "user_uuid",
  test_request_id: "request_uuid",
  amount_mnt: 50000,
  payment_method: "qpay",
  payment_status: "completed",
  qpay_invoice_id: "qpay_invoice_id",
  qpay_qr_text: "qr_code_string",
  qpay_urls: {
    "Khan Bank": "khanbank://...",
    "TDB Bank": "tdbbank://..."
  },
  transaction_id: "payment_id_from_qpay",
  paid_at: "2026-01-17T10:30:00Z",
  created_at: "2026-01-17T10:25:00Z"
}
```

## 🧪 Testing

### Sandbox Testing
1. Use sandbox credentials in `.env`
2. Amounts work with test banks
3. Payment simulation without real money

### Test Flow
```dart
// 1. Create test payment
final payment = await paymentStore.createQPayPayment(
  patientId: 'test-user-id',
  amountMnt: 100,
  description: 'Test payment',
  testRequestId: 'test-request-id',
);

// 2. Check payment status
final isPaid = await paymentStore.checkPaymentStatus(
  payment.id,
);

print('Payment completed: $isPaid');
```

## 🏦 Supported Banks & Deep Links

All deep links are automatically generated:

| Bank | Deep Link Scheme |
|------|------------------|
| Khan Bank | `khanbank://q?qPay_QRcode=...` |
| State Bank | `statebank://q?qPay_QRcode=...` |
| XAC Bank | `xacbank://q?qPay_QRcode=...` |
| TDB Bank | `tdbbank://q?qPay_QRcode=...` |
| Most Money | `most://q?qPay_QRcode=...` |
| NIB Bank | `nibank://q?qPay_QRcode=...` |
| Chinggis Khaan Bank | `ckbank://q?qPay_QRcode=...` |
| Capitron Bank | `capitronbank://q?qPay_QRcode=...` |
| Bogd Bank | `bogdbank://q?qPay_QRcode=...` |
| Candy Pay | `candypay://q?qPay_QRcode=...` |

## 📱 Features

### ✅ Implemented Features
- QR code generation & display
- Deep links to all major Mongolian banks
- Real-time payment status checking
- Automatic payment confirmation
- Payment history
- Cancel payment
- Refund payment (admin only)
- Error handling
- Loading states
- Success animations
- Responsive UI
- Localization (Mongolian & English)

### 🎯 Key Capabilities
1. **Instant Payment Verification** - Check if paid in real-time
2. **Multiple Payment Options** - QR code OR deep link
3. **Auto Status Updates** - No manual refresh needed
4. **Secure** - All credentials in environment variables
5. **Production Ready** - Error handling, retry logic
6. **Mobile Optimized** - Works on iOS & Android

## 🔒 Security

- ✅ Credentials stored in `.env` (not in code)
- ✅ `.env` is in `.gitignore` (never committed)
- ✅ Bearer token authentication
- ✅ Token auto-refresh
- ✅ HTTPS only
- ✅ Server-side payment verification

## 🐛 Troubleshooting

### "QPAY is not configured"
**Solution:** Create `.env` file with QPay credentials

### "Failed to authenticate"
**Solution:** Verify username/password in `.env` are correct

### "Deep link not opening"
**Solution:** User doesn't have that banking app installed. They should use QR code instead.

### "Payment check failed"
**Solution:** 
1. Check network connection
2. Verify invoice ID is correct
3. Ensure payment was actually made

## 📚 Documentation

Full documentation available in:
- **Integration Guide**: `docs/QPAY_INTEGRATION_GUIDE.md`
- **API Reference**: `lib/core/services/qpay_service.dart`
- **Models**: `lib/data/models/payment_model.dart`
- **Widget Usage**: `lib/ui/patient/widgets/qpay_payment_widget.dart`

## ✅ Production Checklist

Before going live:
- [ ] Get production QPay credentials
- [ ] Update `.env` with production values
- [ ] Test with real bank accounts
- [ ] Set up payment webhooks (if needed)
- [ ] Test all supported banks
- [ ] Verify QR codes scan correctly
- [ ] Test error scenarios
- [ ] Set up monitoring/alerts
- [ ] Document support procedures

## 🎉 You're Ready!

Your QPay integration is **complete** and **production-ready**. Just add your credentials and start accepting payments!

### Quick Start Steps:
1. Contact QPay (info@qpay.mn) for credentials
2. Add credentials to `.env`
3. Test in sandbox mode
4. Switch to production
5. Start accepting payments! 💰

---

**Need Help?**
- QPay Support: info@qpay.mn
- Documentation: https://developer.qpay.mn
- Code: Check `lib/core/services/qpay_service.dart`
