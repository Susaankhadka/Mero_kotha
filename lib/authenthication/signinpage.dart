// import 'package:flutter/cupertino.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mero_kotha/Homescreen/Homepage.dart';
import 'package:mero_kotha/stagemanagement/UiProvider.dart';
import 'package:mero_kotha/authenthication/signuppage.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Signinpage extends StatefulWidget {
  const Signinpage({super.key});

  @override
  State<Signinpage> createState() => _SigninpageState();
}

class _SigninpageState extends State<Signinpage> {
  final _formkey = GlobalKey<FormState>();
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final repasswordcontroller = TextEditingController();
  final supabase = Supabase.instance.client;
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    final providerr = Provider.of<UiProvider>(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(250, 246, 255, 251),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              controller: providerr.scrollController,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 30,
                              left: 15,
                              child: Text(
                                'Find your Room \nFast and \nSecure',
                                style: const TextStyle(
                                  fontFamily: 'Sansita',
                                  fontSize: 22,
                                ),
                              ),
                            ),
                            SizedBox.expand(
                              child: Image.asset(
                                'assets/images/location-symbol-with-building.png',
                                height:
                                    MediaQuery.of(context).size.height * 0.10,
                                width: MediaQuery.of(context).size.width * 0.10,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Form(
                                key: _formkey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: emailcontroller,
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(Icons.email),
                                        hintText: 'Email',
                                        border: OutlineInputBorder(),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          isloading = false;
                                          return 'Please enter your email';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      onChanged: (value) => setState(() {}),
                                      controller: passwordcontroller,
                                      obscureText: providerr.triger,
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(Icons.lock),
                                        border: const OutlineInputBorder(),
                                        suffixIcon: IconButton(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          color: Color.fromARGB(98, 0, 0, 4),
                                          onPressed: () => providerr.trigers(
                                            providerr.triger,
                                          ),
                                          icon:
                                              passwordcontroller.text
                                                  .toString()
                                                  .isNotEmpty
                                              ? providerr.triger
                                                    ? Icon(
                                                        Icons.visibility_off,
                                                        size: 22,
                                                      )
                                                    : Icon(
                                                        Icons.visibility,
                                                        size: 22,
                                                      )
                                              : SizedBox.shrink(),
                                        ),
                                        labelText: 'Password',
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          isloading = false;
                                          return 'Please enter your Password';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {},
                                  child: const Text('Forget Password?'),
                                ),
                              ),
                              const SizedBox(height: 10),

                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    isloading = true;
                                    setState(() {});

                                    if (_formkey.currentState!.validate()) {
                                      final supabase = Supabase.instance.client;
                                      try {
                                        await supabase.auth.signInWithPassword(
                                          email: emailcontroller.text.trim(),
                                          password: passwordcontroller.text
                                              .trim(),
                                        );
                                        if (!context.mounted) return;
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => const HomePage(),
                                          ),
                                        );
                                        context.read<UiProvider>().setIndex(0);
                                      } on AuthException catch (e) {
                                        if (!context.mounted) return;

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(e.message),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      } finally {
                                        setState(() => isloading = false);
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromARGB(
                                      255,
                                      73,
                                      121,
                                      241,
                                    ),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: isloading
                                      ? const CupertinoActivityIndicator(
                                          radius: 10,
                                          color: Colors.white,
                                        )
                                      : const Text(
                                          'Login',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                ),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Don't have an account?"),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        PageRouteBuilder(
                                          transitionDuration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          pageBuilder:
                                              (
                                                context,
                                                animation,
                                                secondaryAnimation,
                                              ) => const Signuppage(),
                                          transitionsBuilder:
                                              (
                                                context,
                                                animation,
                                                secondaryAnimation,
                                                child,
                                              ) {
                                                return FadeTransition(
                                                  opacity: animation,
                                                  child: child,
                                                );
                                              },
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Signup',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                backgroundColor: Color.fromARGB(
                                  255,
                                  73,
                                  121,
                                  241,
                                ),
                                foregroundColor: Color.fromARGB(
                                  255,
                                  255,
                                  255,
                                  255,
                                ),
                              ),
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => const Center(
                                    child: CupertinoActivityIndicator(
                                      radius: 18,
                                    ),
                                  ),
                                );

                                try {
                                  const webClientId =
                                      '1090892314451-4omeohmhafsjmsnhvg64s9uhma3oej1v.apps.googleusercontent.com';
                                  const iosClientId =
                                      '1090892314451-frvd0410aognf49n2hrk0iqgagj9co2r.apps.googleusercontent.com';

                                  final GoogleSignIn googleSignIn =
                                      GoogleSignIn(
                                        clientId: iosClientId,
                                        serverClientId: webClientId,
                                      );

                                  final googleUser = await googleSignIn
                                      .signIn();

                                  if (googleUser == null) {
                                    // User cancelled
                                    if (context.mounted) {
                                      Navigator.pop(context); // remove loading
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Google sign-in cancelled',
                                          ),
                                          backgroundColor: Colors.orange,
                                        ),
                                      );
                                    }
                                    return;
                                  }

                                  final googleAuth =
                                      await googleUser.authentication;

                                  final accessToken = googleAuth.accessToken;
                                  final idToken = googleAuth.idToken;

                                  if (accessToken == null || idToken == null) {
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Missing Google credentials',
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                    return;
                                  }

                                  final response = await supabase.auth
                                      .signInWithIdToken(
                                        provider: OAuthProvider.google,
                                        idToken: idToken,
                                        accessToken: accessToken,
                                      );

                                  final user = response.user;

                                  if (user != null) {
                                    await createprofile(
                                      user.id.toString(),
                                      user.userMetadata?['full_name'] ?? '',
                                      user.userMetadata?['avatar_url'] ?? '',
                                    );

                                    if (context.mounted) {
                                      Navigator.pop(context);
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const HomePage(),
                                        ),
                                      );
                                      context.read<UiProvider>().setIndex(0);
                                    }
                                  } else {
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Google sign-in failed',
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Error: $e'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5,
                                      ),
                                      child: Image.asset(
                                        'assets/images/images.png',
                                        height: 35,
                                        width: 35,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Continue With Google  ',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
