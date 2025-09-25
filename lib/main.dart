import 'package:flutter/material.dart';
import 'package:mero_kotha/stagemanagement/Adprovider.dart';
import 'package:mero_kotha/stagemanagement/BookingProvider.dart';
import 'package:mero_kotha/stagemanagement/UiProvider.dart';
import 'package:mero_kotha/stagemanagement/UserProvider.dart';
import 'package:mero_kotha/stagemanagement/postprovider.dart';
import 'package:mero_kotha/authenthication/authenticate.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://pozwkivluwprpmervieo.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBvendraXZsdXdwcnBtZXJ2aWVvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ4MDczNzIsImV4cCI6MjA3MDM4MzM3Mn0.FaaV1X8Nopya3QMqTpIrxx4l0QNCnW6jMviC20WA3ms",
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => UiProvider()),
        ChangeNotifierProvider(create: (_) => PostProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => AdProvider()),
      ],
      child: const Myapp(),
    ),
  );
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Isauthenticate(),
      debugShowCheckedModeBanner: false,
    );
  }
}
