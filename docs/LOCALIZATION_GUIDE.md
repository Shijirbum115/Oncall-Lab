# OnCall Lab - Localization Guide

This app supports **Mongolian (mn)** and **English (en)** languages.

## Quick Start

### Using Localization in Your Screens

1. Import the localization package:
```dart
import 'package:oncall_lab/l10n/app_localizations.dart';
```

2. Get the localization object in your build method:
```dart
@override
Widget build(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;

  return Text(l10n.welcomeBack); // Uses translated string
}
```

### Language Switcher Widgets

#### Full Language Switcher
Use in profile screens or settings:
```dart
import 'package:oncall_lab/ui/shared/widgets/language_switcher.dart';

// In your widget tree:
const LanguageSwitcher()
```

#### Toggle Button
Quick toggle button for app bars:
```dart
import 'package:oncall_lab/ui/shared/widgets/language_switcher.dart';

// In your AppBar actions:
appBar: AppBar(
  actions: const [
    LanguageToggleButton(),
  ],
),
```

## Adding New Translations

### Step 1: Add to English ARB file
Edit `lib/l10n/app_en.arb`:
```json
{
  "myNewString": "Hello World",
  "stringWithParameter": "Welcome, {name}!",
  "@stringWithParameter": {
    "placeholders": {
      "name": {
        "type": "String"
      }
    }
  }
}
```

### Step 2: Add to Mongolian ARB file
Edit `lib/l10n/app_mn.arb`:
```json
{
  "myNewString": "Сайн уу",
  "stringWithParameter": "Тавтай морил, {name}!"
}
```

### Step 3: Generate localization files
```bash
flutter pub get
```

### Step 4: Use in your code
```dart
final l10n = AppLocalizations.of(context)!;

// Simple string
Text(l10n.myNewString)

// String with parameters
Text(l10n.stringWithParameter('John'))
```

## Current Translation Categories

The app has translations organized by feature:

- **@_AUTH**: Authentication (login, register, passwords)
- **@_REGISTRATION**: Patient and doctor registration
- **@_HOME**: Home screen and navigation
- **@_SERVICES**: Service listings and categories
- **@_LABORATORIES**: Laboratory information
- **@_DOCTORS**: Doctor profiles and listings
- **@_BOOKING**: Booking flow and confirmations
- **@_REQUESTS**: Request management and status
- **@_STATUS**: Request status values
- **@_PROFILE**: Profile management
- **@_STATS**: Statistics and metrics
- **@_COMMON**: Common UI strings (yes, no, cancel, etc.)
- **@_ADMIN**: Admin panel
- **@_NOTIFICATIONS**: Notification messages
- **@_ERRORS**: Error messages
- **@_VALIDATION**: Form validation messages

## Accessing Current Locale

```dart
import 'package:oncall_lab/stores/locale_store.dart';

// Check current language
if (localeStore.isMongolian) {
  // Do something for Mongolian
}

if (localeStore.isEnglish) {
  // Do something for English
}

// Get current locale
Locale currentLocale = localeStore.currentLocale;
```

## Changing Language Programmatically

```dart
import 'package:oncall_lab/stores/locale_store.dart';

// Change to specific language
await localeStore.changeLocale(const Locale('mn')); // Mongolian
await localeStore.changeLocale(const Locale('en')); // English

// Toggle between languages
await localeStore.toggleLocale();
```

## Default Language

The app defaults to **Mongolian (mn)** since 90% of users are Mongolian speakers.

## Best Practices

1. **Always use localized strings** - Never hardcode user-facing text
2. **Test both languages** - Make sure UI looks good in both Mongolian and English
3. **Keep translations consistent** - Use the same terminology across the app
4. **Update both files** - When adding new strings, update both `app_en.arb` and `app_mn.arb`
5. **Use descriptive keys** - Name your string keys clearly (e.g., `welcomeBack` not `str1`)
6. **Group related strings** - Use the comment sections (@_AUTH, @_HOME, etc.) to organize translations

## Example Screens Updated

- ✅ **Login Screen** - Fully localized with language switcher
- 🔄 **Other screens** - Need to be updated to use localized strings

## Next Steps

To complete localization across the app, update these screens:

1. Patient Registration Screen
2. Doctor Registration Screen
3. Home Screen
4. Profile Screens
5. Booking Screens
6. Request Screens
7. Doctor Dashboard

Use the Login Screen (`lib/ui/auth/login_screen.dart`) as a reference for how to implement localization.
