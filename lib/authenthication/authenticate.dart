import 'package:flutter/material.dart';

import 'package:mero_kotha/authenthication/introscreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Isauthenticate extends StatelessWidget {
  final supabase = Supabase.instance.client;

  Widget build(BuildContext context) {
    if (supabase.auth.currentUser != null) {
      return IntroscreenafterLogin();
    } else {
      return Introscreen();
    }
  }
}
