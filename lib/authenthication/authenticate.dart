import 'package:flutter/material.dart';

import 'package:mero_kotha/authenthication/introscreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Isauthenticate extends StatelessWidget {
  const Isauthenticate({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    if (supabase.auth.currentUser != null) {
      return IntroscreenafterLogin();
    } else {
      return Introscreen();
    }
  }
}
