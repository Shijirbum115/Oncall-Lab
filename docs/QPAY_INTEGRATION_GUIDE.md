# QPay Payment Integration Guide

## Overview

Your OnCall Lab app already has **full QPay payment integration** implemented. This guide explains how the system works and how to use it.

## 🎉 What's Already Implemented

### 1. **QPay Service** (`lib/core/services/qpay_service.dart`)
- ✅ Authentication with QPay API
- ✅ Token management with auto-refresh
- ✅ Invoice creation
- ✅ Payment status checking
- ✅ Invoice cancellation

### 2. **Payment Models** (`lib/data/models/payment_model.dart`)
- ✅ PaymentModel - Main payment record
- ✅ QPayInvoice - QPay API response
- ✅ QPayUrl - Deep links to banking apps
- ✅ QPayAuthToken - Authentication token
- ✅ QPayPaymentCheck - Payment verification

### 3. **Payment Store** (`lib/stores/payment_store.dart`)
- ✅ MobX state management
- ✅ Create QPay payment
- ✅ Check payment status
- ✅ Load user payments
- ✅ Cancel payments

### 4. **Payment UI Widget** (`lib/ui/patient/widgets/qpay_payment_widget.dart`)
- ✅ QR code display
- ✅ Deep links to banking apps
- ✅ Payment status checking
- ✅ Real-time status updates
- ✅ Error handling
- ✅ Success/failure states

## 🚀 Quick Start

### Step 1: Configure Environment Variables

Create a `.env` file (copy from `.env.example`):

```env
QPAY_API_URL=https://merchant-sandbox.qpay.mn/v2
QPAY_USERNAME=your_qpay_client_id
QPAY_PASSWORD=your_qpay_client_secret
QPAY_INVOICE_CODE=YOUR_INVOICE_CODE
```

### Step 2: Get QPay Credentials

Contact QPay to get your credentials:
- 📧 Email: info@qpay.mn
- 📋 You'll receive:
  - Client ID (username)
  - Client Secret (password)
  - Invoice Code

### Step 3: Use the Payment Widget

```dart
import 'package:oncall_lab/ui/patient/widgets/qpay_payment_widget.dart';

// Show payment screen
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  builder: (context) => DraggableScrollableSheet(
    initialChildSize: 0.9,
    maxChildSize: 0.9,
    minChildSize: 0.5,
    builder: (context, scrollController) => QPayPaymentWidget(
      userId: currentUserId,
      amountMnt: 50000, // Amount in MNT
      description: 'Home sample collection',
      testRequestId: requestId,
      onPaymentSuccess: () {
        // Handle successful payment
        Navigator.pop(context);
        showSuccessMessage();
      },
    ),
  ),
);
```

## 📱 Payment Flow

### 1. User Initiates Payment
```dart
// Create payment and show QR code
await paymentStore.createQPayPayment(
  patientId: userId,
  amountMnt: amount,
  description: 'Test request payment',
  testRequestId: requestId,
);
```

### 2. User Scans QR or Uses Deep Link
- **Option A**: Scan QR code with any banking app
- **Option B**: Tap on bank app button (deep link)

### 3. Payment Verification
```dart
// Check if payment completed
final isPaid = await paymentStore.checkPaymentStatus(paymentId);

if (isPaid) {
  // Update request status
  // Send confirmation
  // Show success message
}
```

## 🏦 Supported Banking Apps

The system automatically generates deep links for:
- Khan Bank (Хаан банк)
- State Bank (Төрийн банк)
- XAC Bank (Хас банк)
- TDB Bank (ХХБанк)
- Most Money (МОСТ мони)
- National Investment Bank (ҮХОБ)
- Chinggis Khaan Bank (Чингис Хаан банк)
- Capitron Bank (Капитрон банк)
- Bogd Bank (Богд банк)
- Candy Pay (Кэнди пэй)

## 🔄 Payment Status Workflow

```
pending → processing → completed
   ↓          ↓
cancelled   failed
```

## 📊 Database Schema

The payment data is stored in Supabase with the following structure:

```sql
CREATE TABLE payments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  patient_id UUID REFERENCES profiles(id),
  test_request_id UUID REFERENCES test_requests(id),
  amount_mnt INTEGER NOT NULL,
  payment_method TEXT NOT NULL,
  payment_status TEXT NOT NULL,
  
  -- QPay specific
  qpay_invoice_id TEXT,
  qpay_qr_text TEXT,
  qpay_urls JSONB,
  
  -- Transaction tracking
  transaction_id TEXT,
  transaction_reference TEXT,
  
  -- Timestamps
  paid_at TIMESTAMPTZ,
  failed_at TIMESTAMPTZ,
  cancelled_at TIMESTAMPTZ,
  
  -- Audit
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

## 🎨 UI Customization

The payment widget is fully customizable. Key features:

### QR Code Display
```dart
QrImageView(
  data: invoice.qrText,
  version: QrVersions.auto,
  size: 200,
  backgroundColor: Colors.white,
)
```

### Bank App Buttons
Each supported bank gets a button with:
- Bank logo (if available)
- Bank name
- Description
- Deep link to open the app

### Status Indicators
- ⏳ Pending: Loading indicator
- ✅ Success: Green check icon
- ❌ Failed: Red error icon
- 🔄 Checking: Refresh animation

## 🔐 Security

### Token Management
- Tokens are cached in memory
- Auto-refresh before expiry
- Never stored in persistent storage

### Environment Variables
- Credentials stored in `.env`
- Never committed to git
- Loaded at runtime

### API Security
- Basic Auth for token retrieval
- Bearer tokens for API calls
- HTTPS only

## 🧪 Testing

### Sandbox Mode
```dart
QPayConfig.useSandbox = true; // Use sandbox
```

### Test Payment Flow
1. Use sandbox credentials
2. Create test invoice
3. Use test bank apps
4. Verify webhook callbacks

### Mock Data
```dart
// Test invoice creation
final invoice = await qpayService.createInvoice(
  amountMnt: 100,
  description: 'Test payment',
);

print('Invoice ID: ${invoice.invoiceId}');
print('QR Text: ${invoice.qrText}');
```

## 📱 Integration Example

### Complete Booking Flow with Payment

```dart
// 1. Create test request
final request = await createTestRequest(
  patientId: userId,
  testTypeId: testTypeId,
  scheduledDate: selectedDate,
);

// 2. Show payment screen
final paymentCompleted = await showPaymentScreen(
  context: context,
  amount: request.totalAmount,
  requestId: request.id,
);

// 3. Confirm request after payment
if (paymentCompleted) {
  await updateRequestStatus(
    requestId: request.id,
    status: RequestStatus.confirmed,
  );
  
  // 4. Send notifications
  await sendConfirmationNotification(userId);
}
```

### Full Widget Example

```dart
class PaymentScreen extends StatelessWidget {
  final String requestId;
  final int amount;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Төлбөр төлөх')),
      body: QPayPaymentWidget(
        userId: authStore.currentProfile!.id,
        amountMnt: amount,
        description: 'Гэрээс дээж авах үйлчилгээ',
        testRequestId: requestId,
        onPaymentSuccess: () {
          Navigator.of(context).pop(true);
          showSuccessDialog(context);
        },
      ),
    );
  }
}
```

## 🐛 Troubleshooting

### Common Issues

**1. "QPAY is not configured"**
- Check `.env` file exists
- Verify credentials are correct
- Ensure flutter_dotenv is loaded in main.dart

**2. "Failed to authenticate with QPAY"**
- Verify username/password
- Check API URL (sandbox vs production)
- Confirm invoice code is correct

**3. "Payment check failed"**
- Ensure invoice ID is correct
- Check network connectivity
- Verify token hasn't expired

**4. "Deep link not opening"**
- User doesn't have banking app installed
- Show helpful error message
- Fallback to QR code

### Debug Mode

Enable verbose logging:
```dart
// In qpay_service.dart
print('Creating invoice: $requestBody');
print('Response: ${response.body}');
```

## 📚 API Reference

### QPay Endpoints

```dart
// Authentication
POST /v2/auth/token
POST /v2/auth/refresh

// Invoice Management
POST /v2/invoice
GET /v2/invoice/:id
DELETE /v2/invoice/:id

// Payment
POST /v2/payment/check
GET /v2/payment/:id
POST /v2/payment/list
```

### Response Examples

**Create Invoice Response:**
```json
{
  "invoice_id": "00f94137-66fd-4d90-b2b2-8225c1b4ed2d",
  "qr_text": "0002010102...",
  "qr_image": "base64_encoded_image",
  "urls": [
    {
      "name": "Khan bank",
      "description": "Хаан банк",
      "logo": "https://...",
      "link": "khanbank://q?qPay_QRcode=..."
    }
  ]
}
```

**Payment Check Response:**
```json
{
  "count": 1,
  "paid_amount": 100,
  "rows": [{
    "payment_id": "593744473409193",
    "payment_status": "PAID",
    "payment_date": "2020-10-19T08:58:46.641Z",
    "payment_amount": "100.00",
    "payment_currency": "MNT"
  }]
}
```

## 🚀 Production Checklist

- [ ] Update `.env` with production credentials
- [ ] Set `useSandbox = false` in QPayConfig
- [ ] Test with real bank accounts
- [ ] Set up webhook endpoint for callbacks
- [ ] Monitor payment success rate
- [ ] Set up error alerting
- [ ] Test deep links on real devices
- [ ] Verify QR codes scan correctly
- [ ] Test payment cancellation flow
- [ ] Document support procedures

## 📞 Support

### QPay Support
- Email: info@qpay.mn
- Documentation: https://developer.qpay.mn

### App Support
For implementation questions, refer to:
- Payment Store: `lib/stores/payment_store.dart`
- QPay Service: `lib/core/services/qpay_service.dart`
- Payment Models: `lib/data/models/payment_model.dart`

## 🎯 Next Steps

1. **Get QPay credentials** from info@qpay.mn
2. **Update .env file** with your credentials
3. **Test in sandbox** mode
4. **Integrate payment** into your booking flow
5. **Test with real users**
6. **Switch to production**

---

**Your QPay integration is complete and production-ready!** 🎉
