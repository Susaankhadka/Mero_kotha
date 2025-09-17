import 'package:flutter/material.dart';
import 'package:mero_kotha/Navigationbarpage/bookedpage.dart';
import 'package:mero_kotha/Navigationbarpage/mybooking.dart';

import 'package:mero_kotha/modelclass/modelclass.dart';
import 'package:mero_kotha/stagemanagement/statemanagement.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final supabase = Supabase.instance.client;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Providerr>().fetchPosts();
      context.read<Providerr>().fetchuser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final providerr = Provider.of<Providerr>(context);
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          elevation: 0,
          backgroundColor: Colors.transparent,
          onRefresh: () => Future.microtask(
            () => Provider.of<Providerr>(context, listen: false).fetchPosts(),
          ),
          child: SingleChildScrollView(
            controller: providerr.scrollController,
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Find Your Right Space\nAt Right place ',
                        style: TextStyle(fontSize: 20),
                      ),

                      Image.asset(
                        'assets/images/loaction.png',
                        height: 100,
                        width: 100,
                      ),
                    ],
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Container(
                //     height: 45,
                //     decoration: BoxDecoration(
                //       boxShadow: [
                //         BoxShadow(
                //           color: const Color.fromARGB(
                //             152,
                //             0,
                //             0,
                //             0,
                //           ).withAlpha(40),
                //           blurRadius: 10,
                //           spreadRadius: 2,
                //         ),
                //       ],
                //       borderRadius: BorderRadius.circular(25),
                //       color: Color.fromARGB(255, 255, 255, 255),
                //     ),
                //     child: InkWell(
                //       child: TextField(
                //         onTapOutside: (event) =>
                //             FocusManager.instance.primaryFocus?.unfocus(),
                //         onSubmitted: (_) => FocusScope.of(context).unfocus(),
                //         decoration: InputDecoration(
                //           hintText: 'Search Items',

                //           border: OutlineInputBorder(
                //             borderRadius: BorderRadius.circular(20),
                //           ),
                //           prefixIcon: Icon(Icons.search, size: 25),

                //           suffixIcon: Icon(Icons.filter_alt, size: 25),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ActionButton(
                        icon: Icons.add,
                        label: 'Post Room',
                        onTap: () {
                          context.read<Providerr>().setIndex(2);
                        },
                        backgroundColor: Colors.blue.shade50,
                        iconColor: Colors.blue,
                      ),
                      ActionButton(
                        icon: Icons.book,
                        label: 'Book Room',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Bookedpage(),
                            ),
                          );
                        },
                        backgroundColor: Colors.green.shade50,
                        iconColor: Colors.green,
                      ),

                      ActionButton(
                        icon: Icons.list,
                        label: 'My Bookings',
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   PageRouteBuilder(
                          //     transitionDuration: const Duration(
                          //       milliseconds: 300,
                          //     ),
                          //     pageBuilder:
                          //         (context, animation, secondaryAnimation) =>
                          //             Bookedpage(book: providerr.bookinglist),
                          //     transitionsBuilder:
                          //         (
                          //           context,
                          //           animation,
                          //           secondaryAnimation,
                          //           child,
                          //         ) {
                          //           return FadeTransition(
                          //             opacity: animation,
                          //             child: child,
                          //           );
                          //         },
                          //   ),
                          // );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyBookedpage(),
                            ),
                          );
                        },
                        backgroundColor: Colors.orange.shade50,
                        iconColor: Colors.orange,
                      ),
                      ActionButton(
                        icon: Icons.near_me,
                        label: 'Nearby room',
                        onTap: () {},
                        backgroundColor: Colors.red.shade50,
                        iconColor: Colors.red,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Recent Post',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),

                AllRecentPost(postcount: 1, postlist: providerr.postlist),
                // showpost(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
