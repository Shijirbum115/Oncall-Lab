# Authentication Context Guide

This app uses **optional authentication** where users can browse freely but must sign in for certain actions.

## Overview

- **Public Access**: Home screen, service information, browsing features
- **Requires Authentication**: Booking appointments, making payments, viewing results, chat with doctors

## Using AuthContext

The `AuthContext` helper provides methods to check authentication and prompt login when needed.

### Basic Usage

```dart
import 'package:oncall_lab/core/utils/auth_context.dart';

// In your booking/payment widget
Future<void> handleBooking() async {
  // Check if user is authenticated before proceeding
  if (await AuthContext.requireAuth(context, reason: 'book an appointment')) {
    // User is authenticated, proceed with booking
    await _performBooking();
  } else {
    // User cancelled login or login failed
    // No action needed, user stays on current screen
  }
}
```

### Example: Appointment Booking

```dart
ElevatedButton(
  onPressed: () async {
    if (await AuthContext.requireAuth(
      context,
      reason: 'book this appointment',
    )) {
      // Navigate to booking confirmation
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookingConfirmationScreen(doctor: doctor),
        ),
      );
    }
  },
  child: const Text('Book Appointment'),
)
```

### Example: Payment Flow

```dart
Future<void> proceedToPayment() async {
  final canProceed = await AuthContext.requireAuth(
    context,
    reason: 'complete your payment',
    onAuthSuccess: () {
      // This runs after successful authentication
      print('User authenticated, proceeding to payment');
    },
  );

  if (canProceed) {
    await _processPayment();
  }
}
```

### Example: With Dialog

```dart
Future<void> viewMyResults() async {
  final authenticated = await AuthContext.showAuthRequiredDialog(
    context,
    title: 'Sign In Required',
    message: 'Please sign in to view your lab results',
  );

  if (authenticated) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResultsScreen()),
    );
  }
}
```

### Check Specific Actions

```dart
// Check if action is allowed
final error = AuthContext.canPerformAction('make_payment');
if (error != null) {
  // Show error message or redirect to login
  showSnackBar(error);
} else {
  // Proceed with action
}
```

## Available Actions

### Public (No Auth Required)
- `view_home` - View home screen
- `browse_services` - Browse available services
- `view_info` - View information pages

### Requires Authentication
- `book_appointment` - Book an appointment
- `make_payment` - Make a payment
- `view_results` - View lab results
- `chat_with_doctor` - Start chat with doctor

## Implementation in UI Components

### Button with Auth Check

```dart
class BookingButton extends StatelessWidget {
  final Doctor doctor;

  const BookingButton({required this.doctor, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.calendar_today),
      label: const Text('Book Appointment'),
      onPressed: () async {
        if (await AuthContext.requireAuth(
          context,
          reason: 'book an appointment',
        )) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookingPage(doctor: doctor),
            ),
          );
        }
      },
    );
  }
}
```

### List Item with Auth Check

```dart
ListTile(
  leading: const Icon(Icons.payment),
  title: const Text('Payment History'),
  onTap: () async {
    if (await AuthContext.requireAuth(
      context,
      reason: 'view payment history',
    )) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentHistoryScreen(),
        ),
      );
    }
  },
)
```

## Best Practices

1. **Always provide a reason** when calling `requireAuth()` for better UX
2. **Check auth before navigation** to protected screens
3. **Use descriptive messages** that explain why login is needed
4. **Handle the false return value** gracefully (user stays on current screen)
5. **Don't block public content** - only gate actions that truly need authentication

## Testing Auth Flow

To test the optional auth flow:

1. Sign out completely
2. Browse the home screen (should work without auth)
3. Try to book an appointment (should prompt for login)
4. Complete login (should return to booking flow)
5. Complete the booking (should work now)
