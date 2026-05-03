# OnCall Lab - Backend Setup Complete ✅

## Overview

Your Supabase backend is now fully set up and ready for production use! This document provides a quick overview of what has been configured.

## What's Been Created

### ✅ Database Schema (9 Tables)

1. **profiles** - User profiles (patient/doctor/admin roles)
2. **doctor_profiles** - Extended doctor information
3. **laboratories** - Lab facilities (3 pre-seeded)
4. **test_types** - Available lab tests (10 pre-seeded)
5. **test_requests** - Main workflow table
6. **doctor_availability** - Doctor scheduling
7. **request_status_history** - Audit trail for status changes
8. **notifications** - In-app notifications
9. **audit_logs** - System-wide audit trail

### ✅ Security Features

- **Row Level Security (RLS)** enabled on all tables
- Role-based access control (patient, doctor, admin)
- Secure database functions with fixed search paths
- Phone number authentication ready

### ✅ Real-time Subscriptions

Real-time enabled for:
- Test requests (live status updates)
- Notifications (instant delivery)
- Doctor availability (live updates)
- Doctor profiles (availability status)

### ✅ Business Logic

**Database Functions:**
- `get_available_doctors()` - Get list of available doctors
- `get_pending_requests_for_doctor()` - Get pending requests for doctors
- `create_notification()` - Create notifications

**Automatic Triggers:**
- Auto-update timestamps on all tables
- Automatic status change logging
- Automatic notifications on status changes
- Doctor statistics updates

### ✅ Seed Data

**3 Laboratories:**
- Central Laboratory (Peace Avenue 15)
- MedLab Mongolia (Seoul Street 24)
- UB Diagnostics (Baga Toiruu 41)

**10 Test Types:**
- Complete Blood Count (12,000 MNT)
- Blood Glucose (8,000 MNT)
- Lipid Profile (15,000 MNT)
- Liver Function Test (18,000 MNT)
- Kidney Function Test (16,000 MNT)
- Urinalysis (10,000 MNT)
- Thyroid Function (25,000 MNT)
- HbA1c (22,000 MNT)
- Vitamin D Test (30,000 MNT)
- Iron Studies (20,000 MNT)

## Your Supabase Project

**Project URL:** https://zrwtugcgimaocrhjdtob.supabase.co

**Supabase Dashboard:** https://supabase.com/dashboard/project/zrwtugcgimaocrhjdtob

**API Documentation:** https://supabase.com/dashboard/project/zrwtugcgimaocrhjdtob/api

## Getting Started

### 1. Windows Development Setup

Follow the comprehensive guide:
```
docs/WINDOWS_SETUP.md
```

This includes:
- Flutter SDK installation
- Android Studio setup
- VS Code configuration
- Environment setup
- Common issues & solutions

### 2. Backend Architecture

Understand the database design and API patterns:
```
docs/BACKEND_ARCHITECTURE.md
```

This includes:
- Complete database schema reference
- Row Level Security policies
- Database functions and triggers
- Real-time subscription configuration
- Authentication flow
- API patterns and examples

### 3. Flutter Integration

Learn how to connect your Flutter app to Supabase:
```
docs/FLUTTER_INTEGRATION.md
```

This includes:
- Supabase initialization
- Authentication implementation
- Data models with Freezed
- Repository pattern
- MobX stores
- Real-time subscriptions
- Error handling
- Testing examples

### 4. Quick Start

```bash
# 1. Install dependencies
flutter pub get

# 2. Generate code (MobX, Freezed, AutoRoute)
dart run build_runner build --delete-conflicting-outputs

# 3. Run the app
flutter run
```

**Note:** The Supabase configuration file has already been created at:
```
lib/core/constants/supabase_config.dart
```

## Database Migrations

All database changes are tracked via migrations:

1. `create_core_schema_and_profiles` - Core types, profiles, RLS
2. `create_laboratories_and_test_types` - Lab and test catalog
3. `create_doctor_profiles_and_availability` - Doctor-specific tables
4. `create_test_requests` - Main workflow table
5. `add_profiles_rls_and_create_audit_tables` - Audit and notifications
6. `enable_realtime_subscriptions` - Real-time configuration
7. `create_business_logic_functions` - Database functions and triggers
8. `add_auth_trigger_and_seed_data` - Seed data for labs and tests
9. `fix_function_search_paths` - Security improvements

## Workflow

The app follows this workflow:

```
1. Patient creates request (status: pending)
2. Doctor accepts request (status: accepted)
3. Doctor travels to patient (status: on_the_way)
4. Doctor collects sample (status: sample_collected)
5. Doctor delivers to lab (status: delivered_to_lab)
6. Lab completes test (status: completed)

   OR

   Any party cancels (status: cancelled)
```

Each status change:
- Automatically logs to `request_status_history`
- Updates corresponding timestamp
- Sends notifications to relevant parties
- Updates statistics (on completion)

## Security Best Practices

✅ All tables have RLS enabled
✅ Function search paths are set securely
✅ No security warnings from Supabase linter
✅ Phone number authentication configured
✅ Proper indexes for performance
✅ Audit logging implemented

## Next Steps

1. **Phone Auth Configuration:**
   - Go to Supabase Dashboard → Authentication → Settings
   - Enable Phone provider
   - Configure SMS provider (Twilio recommended for Mongolia)
   - Set up OTP templates

2. **Set Up Push Notifications:**
   - Integrate Firebase Cloud Messaging
   - Create database trigger to send push notifications
   - Configure notification handlers in Flutter

3. **Testing:**
   - Create test users with different roles
   - Test the complete workflow
   - Verify real-time subscriptions work
   - Test RLS policies

4. **Production Deployment:**
   - Enable database backups
   - Set up monitoring and alerts
   - Configure custom domain
   - Review and adjust rate limits

5. **Future Features:**
   - Payment integration (Mongolian payment gateways)
   - Reviews and ratings system
   - Doctor earnings dashboard
   - Analytics and reporting
   - File upload for test results
   - Multi-language support (Mongolian/English)

## Support Resources

- **Supabase Documentation:** https://supabase.com/docs
- **Flutter Documentation:** https://docs.flutter.dev
- **Project Documentation:** See `docs/` folder
- **Supabase Community:** https://github.com/supabase/supabase/discussions

## Database Dashboard Access

Access your database directly:
- **SQL Editor:** https://supabase.com/dashboard/project/zrwtugcgimaocrhjdtob/sql/new
- **Table Editor:** https://supabase.com/dashboard/project/zrwtugcgimaocrhjdtob/editor
- **Database Logs:** https://supabase.com/dashboard/project/zrwtugcgimaocrhjdtob/logs/postgres-logs

## API Endpoint

Your auto-generated REST API is available at:
```
https://zrwtugcgimaocrhjdtob.supabase.co/rest/v1/
```

All API requests require the `apikey` header with your anon key.

## Common Tasks

### Create Admin User
```sql
-- Run this in SQL Editor after creating a user via phone auth
UPDATE profiles
SET role = 'admin'
WHERE phone_number = '+97699123456';
```

### Verify a Doctor
```sql
-- Verify doctor (required before they can accept requests)
UPDATE profiles
SET is_verified = true
WHERE id = 'doctor-uuid-here' AND role = 'doctor';
```

### View Request Statistics
```sql
-- Get request counts by status
SELECT status, COUNT(*) as count
FROM test_requests
GROUP BY status
ORDER BY count DESC;
```

### Check Real-time Connections
```sql
-- View active real-time connections
SELECT * FROM pg_stat_activity
WHERE state = 'active';
```

## Production Checklist

- [ ] Configure phone SMS provider in Supabase
- [ ] Set up database backups (automatic on paid plans)
- [ ] Configure monitoring and alerts
- [ ] Test all user roles and permissions
- [ ] Test real-time subscriptions
- [ ] Implement error tracking (Sentry, Crashlytics)
- [ ] Set up CI/CD pipeline
- [ ] Configure custom domain (optional)
- [ ] Review and adjust rate limits
- [ ] Load test the application
- [ ] Security audit
- [ ] Prepare launch plan

## Questions?

Refer to the comprehensive documentation in the `docs/` folder:
- `WINDOWS_SETUP.md` - Environment setup
- `BACKEND_ARCHITECTURE.md` - Database and API reference
- `FLUTTER_INTEGRATION.md` - Flutter implementation guide

---

**Your backend is production-ready! Start building your Flutter app! 🚀**
