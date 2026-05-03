import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bugamed/core/constants/supabase_config.dart';

class SupabaseService {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: SupabaseConfig.supabaseUrl,
      anonKey: SupabaseConfig.supabaseAnonKey,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}

// Global access to Supabase client
final supabase = SupabaseService.client;
