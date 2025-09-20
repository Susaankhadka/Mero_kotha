import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:mero_kotha/authenthication/signinpage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Signuppage extends StatefulWidget {
  const Signuppage({super.key});

  @override
  State<Signuppage> createState() => _SignuppageState();
}

class _SignuppageState extends State<Signuppage> {
  final _formkey = GlobalKey<FormState>();
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final usernamecontroller = TextEditingController();

  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(250, 246, 255, 251),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// 🔹 Top Image
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.23,
                width: double.infinity,
                child: Image.asset(
                  'assets/images/loginbackground.png',
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 20),

              /// 🔹 Signup Form
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const Text(
                      'Register your account',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 116, 2, 254),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: usernamecontroller,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              hintText: 'Username',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please enter username'
                                : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: emailcontroller,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.email),
                              hintText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Email is required";
                              }
                              // ✅ Regular email pattern
                              String pattern =
                                  r'^[a-zA-Z0-9._%+-]+@gmail\.com$';
                              RegExp regex = RegExp(pattern);

                              if (!regex.hasMatch(value)) {
                                return "Enter a valid Gmail address";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: passwordcontroller,
                            obscureText: true,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.lock),
                              hintText: 'Password',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? 'Please enter your password'
                                : null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// 🔹 Register Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() => isloading = true);
                          if (_formkey.currentState!.validate()) {
                            try {
                              final supabase = Supabase.instance.client;
                              final authResponse = await supabase.auth.signUp(
                                email: emailcontroller.text.trim(),
                                password: passwordcontroller.text.trim(),
                              );

                              final userId = authResponse.user?.id;
                              await createprofile(
                                userId.toString(),
                                usernamecontroller.text.trim(),
                              );
                              if (!context.mounted) return;
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Account Registered Successfully',
                                    ),
                                  ),
                                );
                              }

                              /// Clear fields
                              emailcontroller.clear();
                              passwordcontroller.clear();
                              usernamecontroller.clear();

                              if (!context.mounted) return;
                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  transitionDuration: const Duration(
                                    milliseconds: 300,
                                  ),
                                  pageBuilder: (_, a, __) => const Signinpage(),
                                  transitionsBuilder:
                                      (_, animation, __, child) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      },
                                ),
                              );
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      e is AuthException
                                          ? e.message
                                          : "An error occurred",
                                    ),
                                  ),
                                );
                              }
                            }
                          }
                          setState(() => isloading = false);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            238,
                            21,
                            168,
                            87,
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
                                'Register',
                                style: TextStyle(fontSize: 18),
                              ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                transitionDuration: const Duration(
                                  milliseconds: 300,
                                ),
                                pageBuilder: (_, a, __) => const Signinpage(),
                                transitionsBuilder: (_, animation, __, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          child: const Text(
                            'Signin',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// 🔹 Social Login Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Expanded(
                          child: Divider(thickness: 1, color: Colors.grey),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text('Continue with'),
                        ),
                        Expanded(
                          child: Divider(thickness: 1, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(45),
                          onTap: () {},
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
  }
}

Future<void> createprofile(String userid, String username) async {
  final supabase = Supabase.instance.client;
  await supabase.from('profile').insert({
    'userid': userid,
    'username': username,
    'role': 'user',
  });
}








// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:mero_kotha/untitled%20folder/signinpage.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class Signuppage extends StatefulWidget {
//   const Signuppage({super.key});

//   @override
//   State<Signuppage> createState() => _SignuppageState();
// }

// class _SignuppageState extends State<Signuppage> {
//   final _formkey = GlobalKey<FormState>();

//   final emailcontroller = TextEditingController();

//   final passwordcontroller = TextEditingController();

//   final usernamecontroller = TextEditingController();

//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   bool isloading = false;
//   //   String? validateEmail(String? email) {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromARGB(250, 246, 255, 251),

//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             SizedBox(
//               height: MediaQuery.of(context).size.height * 0.30,
//               width: double.infinity,

//               child: Image.asset(
//                 'assets/images/loginbackground.png',
                
//                 fit: BoxFit.cover,
//               ),
//             ),
//             SizedBox(
//               height: MediaQuery.of(context).size.height * 0.49,
//               child: Column(
//                 children: [
//                   SizedBox(height: 15),
//                   Center(
//                     child: Text(
//                       'Register your account',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: Color.fromARGB(255, 116, 2, 254),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 10),
//                   Form(
//                     key: _formkey,
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20),
//                           child: TextFormField(
//                             controller: usernamecontroller,

//                             decoration: InputDecoration(
//                               prefixIcon: Icon(Icons.person),
//                               hintText: 'Username',
//                               border: OutlineInputBorder(),
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please Username';
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20),
//                           child: TextFormField(
//                             controller: emailcontroller,
//                             decoration: InputDecoration(
//                               prefixIcon: Icon(Icons.email),
//                               hintText: 'Email',
//                               border: OutlineInputBorder(),
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter your email';
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                         SizedBox(height: 10),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 20),

//                           child: TextFormField(
//                             controller: passwordcontroller,
//                             decoration: InputDecoration(
//                               prefixIcon: Icon(Icons.lock),
//                               border: OutlineInputBorder(),
//                               hintText: 'Password',
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter your Password';
//                               }
//                               return null;
//                             },
//                           ),
//                         ),
//                         SizedBox(height: 10),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 15),
//                   ElevatedButton(
//                     onPressed: () async {
//                       setState(() {
//                         isloading = true;
//                       });
//                       if (_formkey.currentState!.validate()) {
//                         try {
//                           final authResponse = await _auth
//                               .createUserWithEmailAndPassword(
//                                 email: emailcontroller.text.trim(),
//                                 password: passwordcontroller.text.trim(),
//                               );
//                           final userId = authResponse.user?.uid;
//                           print(userId);
//                           isloading = false;
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text('Account Regester Successful'),
//                             ),
//                           );
//                           createprofile(
//                             userId.toString(),
//                             usernamecontroller.text.toString(),
//                           );
//                           // context.read<Providerr>().setUsername(
//                           //   usernamecontroller.text,
//                           // );
//                           emailcontroller.clear();
//                           passwordcontroller.clear();
//                           usernamecontroller.clear();

//                           Navigator.pushReplacement(
//                             context,
//                             PageRouteBuilder(
//                               transitionDuration: Duration(milliseconds: 300),
//                               pageBuilder:
//                                   (context, animation, secondaryAnimation) =>
//                                       Signinpage(),
//                               transitionsBuilder:
//                                   (
//                                     context,
//                                     animation,
//                                     secondaryAnimation,
//                                     child,
//                                   ) {
//                                     return FadeTransition(
//                                       opacity: animation,
//                                       child: child,
//                                     );
//                                   },
//                             ),
//                           );
//                         } catch (e) {
//                           if (mounted) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text(
//                                   e is FirebaseAuthException
//                                       ? e.message ?? "Signup failed"
//                                       : "An error occurred",
//                                 ),
//                               ),
//                             );
//                           }
//                         }
//                       }
//                     },

//                     style: ButtonStyle(
//                       minimumSize: WidgetStatePropertyAll(
//                         Size(
//                           MediaQuery.sizeOf(context).width * 0.9,
//                           MediaQuery.sizeOf(context).width * 0.11,
//                         ),
//                       ),
//                       backgroundColor: WidgetStatePropertyAll(
//                         Color.fromARGB(238, 21, 168, 87),
//                       ),
//                       foregroundColor: WidgetStatePropertyAll(
//                         Color.fromARGB(218, 254, 254, 254),
//                       ),
//                     ),
//                     child: isloading
//                         ? Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: CupertinoActivityIndicator(
//                               radius: 6,
//                               color: Colors.white,
//                             ),
//                           )
//                         : Text('Register', style: TextStyle(fontSize: 18)),
//                   ),

//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text("Already have an account?"),
//                       TextButton(
//                         onPressed: () {
//                           Navigator.pushReplacement(
//                             context,
//                             PageRouteBuilder(
//                               transitionDuration: Duration(milliseconds: 300),
//                               pageBuilder:
//                                   (context, animation, secondaryAnimation) =>
//                                       Signinpage(),
//                               transitionsBuilder:
//                                   (
//                                     context,
//                                     animation,
//                                     secondaryAnimation,
//                                     child,
//                                   ) {
//                                     return FadeTransition(
//                                       opacity: animation,
//                                       child: child,
//                                     );
//                                   },
//                             ),
//                             // MaterialPageRoute(
//                             //   builder: (context) => Signinpage(),
//                             // ),
//                           );
//                         },
//                         child: Text('Signin', style: TextStyle(fontSize: 15)),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             SizedBox(
//               height: MediaQuery.of(context).size.height * 0.09,

//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   // SizedBox(height: 10),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Expanded(
//                           child: Divider(
//                             thickness: 1,
//                             color: Colors.grey,
//                             endIndent: 10,
//                           ),
//                         ),
//                         Text('   Continue with    '),
//                         Expanded(
//                           child: Divider(
//                             thickness: 1,
//                             color: Colors.grey,
//                             endIndent: 10,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       InkWell(
//                         borderRadius: BorderRadius.circular(45),
//                         onTap: () {},
//                         child: SvgPicture.asset(
//                           'assets/svg/google-icon-logo-svgrepo-com.svg',
//                           height: 28,
//                           width: 28,
//                         ),
//                       ),
//                       IconButton(
//                         onPressed: () {},
//                         icon: Icon(
//                           Icons.facebook_sharp,
//                           size: 33,
//                           color: Color.fromARGB(255, 41, 0, 243),
//                         ),
//                       ),
//                       IconButton(
//                         onPressed: () {},
//                         icon: Icon(Icons.apple, size: 35),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// Future<void> createprofile(String userid, String username) async {
//   final supabase = Supabase.instance.client;
//   final String roles = 'user';
//   await supabase.from('profile').insert({
//     'userid': userid,
//     'username': username,
//     'role': roles,
//   });
// }
