import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> authenticateWithGoogle() async {
  final supabase = Supabase.instance.client;

  try {
    await supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      authScreenLaunchMode: LaunchMode.externalApplication,
    );
  } catch (e) {
    print('Error: $e');
  }
}
