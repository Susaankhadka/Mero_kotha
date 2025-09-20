// import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/utils.dart';
import 'package:mero_kotha/Homescreen/Homepage.dart';
import 'package:mero_kotha/authenthication/googleservice.dart';
import 'package:mero_kotha/stagemanagement/statemanagement.dart';
import 'package:mero_kotha/authenthication/signuppage.dart';

import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  bool isloading = false;
  @override
  void initState() {
    super.initState();
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      final session = data.session;
      if (event == AuthChangeEvent.signedIn && session != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            );
            context.read<Providerr>().setIndex(0);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final providerr = Provider.of<Providerr>(context);

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
                      // 🔹 Top Section (Image + Heading)
                      Expanded(
                        flex: 2,
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

                      // 🔹 Middle Section (Form)
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'Sansita',
                                ),
                              ),
                              const SizedBox(height: 10),
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

                              // 🔹 Login Button
                              ElevatedButton(
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

                                      // Don't navigate here, let onAuthStateChange handle it
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
                                style: ButtonStyle(
                                  minimumSize: WidgetStatePropertyAll(
                                    Size(
                                      MediaQuery.sizeOf(context).width * 0.9,
                                      MediaQuery.sizeOf(context).width * 0.12,
                                    ),
                                  ),
                                  backgroundColor: const WidgetStatePropertyAll(
                                    Color.fromARGB(238, 21, 168, 87),
                                  ),
                                  foregroundColor: const WidgetStatePropertyAll(
                                    Color.fromARGB(218, 254, 254, 254),
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

                      // 🔹 Bottom Section (Social Login)
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Expanded(
                                    child: Divider(
                                      thickness: 1,
                                      color: Colors.grey,
                                      endIndent: 10,
                                    ),
                                  ),
                                  Text('   Continue with    '),
                                  Expanded(
                                    child: Divider(
                                      thickness: 1,
                                      color: Colors.grey,
                                      endIndent: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  borderRadius: BorderRadius.circular(45),
                                  onTap: () async {
                                    try {
                                      await authenticateWithGoogle();
                                      // No need to navigate here, onAuthStateChange will handle it
                                    } catch (e) {
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Google login failed: $e',
                                          ),
                                        ),
                                      );
                                    }
                                  },

                                  child: SvgPicture.asset(
                                    'assets/svg/google-icon-logo-svgrepo-com.svg',
                                    height: 28,
                                    width: 28,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.facebook_sharp,
                                    size: 33,
                                    color: Color.fromARGB(255, 41, 0, 243),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.apple, size: 35),
                                ),
                              ],
                            ),
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
