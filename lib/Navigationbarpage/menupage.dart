import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mero_kotha/Homescreen/editprofile.dart';
import 'package:mero_kotha/Homescreen/profile.dart';
import 'package:mero_kotha/Navigationbarpage/bookedpage.dart';
import 'package:mero_kotha/modelclass/modelclass.dart';
import 'package:mero_kotha/stagemanagement/BookingProvider.dart';
import 'package:mero_kotha/stagemanagement/UiProvider.dart';
import 'package:mero_kotha/stagemanagement/UserProvider.dart';
import 'package:mero_kotha/stagemanagement/postprovider.dart';
import 'package:mero_kotha/authenthication/signinpage.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Menupage extends StatefulWidget {
  const Menupage({super.key});

  @override
  State<Menupage> createState() => _MenupageState();
}

class _MenupageState extends State<Menupage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double imageSize = screenWidth * 0.16;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: const Text(
                  'Profile',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Myprofile(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              Consumer<UserProvider>(
                                builder: (context, value, child) {
                                  return Container(
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipOval(
                                      child: value.profilepic.isNotEmpty
                                          ? SizedBox(
                                              width: imageSize,
                                              height: imageSize,
                                              child: CachedNetworkImage(
                                                imageUrl: value.profilepic,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    const Center(
                                                      child:
                                                          CupertinoActivityIndicator(
                                                            radius: 12,
                                                          ),
                                                    ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Center(
                                                          child: Icon(
                                                            Icons.broken_image,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                              ),
                                            )
                                          : SizedBox(
                                              width: imageSize,
                                              height: imageSize,
                                              child: const Icon(
                                                Icons.person,
                                                size: 30,
                                                color: Colors.grey,
                                              ),
                                            ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(width: 15),
                              Consumer<UserProvider>(
                                builder: (context, providerr, child) {
                                  String fullName = providerr.username;
                                  List<String> parts = fullName.trim().split(
                                    ' ',
                                  );
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        providerr.username.isNotEmpty
                                            ? 'Hi, ${parts.first}'
                                            : "Loading...",
                                        style: TextStyle(
                                          fontSize:
                                              MediaQuery.of(
                                                context,
                                              ).size.height *
                                              0.025,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2),
                                        child: Text(
                                          providerr.username.isNotEmpty
                                              ? 'View profile'
                                              : "",
                                          style: TextStyle(
                                            fontSize:
                                                MediaQuery.of(
                                                  context,
                                                ).size.height *
                                                0.016,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              const Spacer(),
                              const Icon(Icons.arrow_forward_ios, size: 15),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.all(15),
                child: const Text('Settings', style: TextStyle(fontSize: 20)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(15, 8, 0, 0),
                      //   child: Text('Personalized', style: TextStyle(fontSize: 16)),
                      // ),
                      SettingBlocks(
                        settingname: 'Edit Profile',
                        icons: const Icon(Icons.person),
                        onclick: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Editprofile(),
                            ),
                          );

                          Future.delayed(
                            const Duration(milliseconds: 1000),
                            () {
                              if (!context.mounted) return;
                              context.read<UserProvider>().fetchprofileinfo();
                            },
                          );
                        },
                      ),
                      const Divider(),
                      SettingBlocks(
                        settingname: 'Password',
                        icons: const Icon(Icons.lock_outline_rounded),
                        onclick: () {},
                      ),

                      const Divider(),

                      SettingBlocks(
                        settingname: 'Booker space',
                        icons: const Icon(Icons.admin_panel_settings),
                        onclick: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Bookedpage(),
                            ),
                          );
                        },
                      ),

                      // : SizedBox();
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(15, 8, 0, 0),
                      //   child: Text('Personalized', style: TextStyle(fontSize: 16)),
                      // ),
                      SettingBlocks(
                        settingname: 'Notification',
                        icons: const Icon(Icons.notifications),
                        onclick: () {},
                      ),
                      Divider(),
                      SettingBlocks(
                        settingname: 'Rate & Review',
                        icons: const Icon(Icons.reviews_outlined),
                        onclick: () {},
                      ),
                      Divider(),
                      SettingBlocks(
                        settingname: 'Help',
                        icons: const Icon(Icons.help_outline),
                        onclick: () {},
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SettingBlocks(
                        settingname: 'Contact Us',
                        icons: const Icon(Icons.call),
                        onclick: () {},
                      ),
                      Divider(),

                      SettingBlocks(
                        settingname: 'Log Out',
                        icons: const Icon(Icons.logout_outlined),
                        onclick: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                title: const Text("Log out"),
                                content: const Text(
                                  "Are you sure you want to Log out?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(
                                        context,
                                      ); //  Cancel, just close
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  LogOutwidget(),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LogOutwidget extends StatelessWidget {
  const LogOutwidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: //providerr.isLoggingOut
          //  ? null :
          () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) =>
                  const Center(child: CupertinoActivityIndicator(radius: 18)),
            );
            // providerr.isLoggingOut = true;

            Future.microtask(() async {
              final supabase = Supabase.instance.client;
              try {
                await supabase.auth.signOut(); // works for email & Google

                // Only disconnect if logged in via Google
                final GoogleSignIn googleSignIn = GoogleSignIn();
                try {
                  await googleSignIn.disconnect();
                } catch (_) {} // ignore if not logged in via Google

                if (!context.mounted) {
                  return;
                }
                context.read<UserProvider>().clearprofilename();
                context.read<BookingProvider>().bookedlist.clear();
                context.read<BookingProvider>().bookinglist.clear();
                context.read<PostProvider>().mypostlist.clear();
                context.read<UserProvider>().clearprofilename();

                context.read<UiProvider>().setIndex(0);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => Signinpage()),
                );
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Logout failed: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              } //finally {
              //   if (context.mounted) {
              //     providerr.isLoggingOut =
              //         false;
              //   }
              // }
            });
          },

      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 225, 27, 13),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      child:
          // providerr.isLoggingOut
          //     ? SizedBox(
          //         width:
          //             MediaQuery.of(
          //               context,
          //             ).size.width *
          //             0.16,
          //         child:
          //             CupertinoActivityIndicator(
          //               color: Color.fromARGB(
          //                 255,
          //                 255,
          //                 255,
          //                 255,
          //               ),
          //             ),
          //       )
          //     :
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.16,
            child: const Center(child: Text('Logout')),
          ),
    );
  }
}
