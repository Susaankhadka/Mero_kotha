import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mero_kotha/Navigationbarpage/bookedpage.dart';
import 'package:mero_kotha/modelclass/modelclass.dart';
import 'package:mero_kotha/stagemanagement/BookingProvider.dart';
import 'package:mero_kotha/stagemanagement/UiProvider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MyBookedpage extends StatefulWidget {
  const MyBookedpage({super.key});

  @override
  State<MyBookedpage> createState() => _MyBookedpageState();
}

class _MyBookedpageState extends State<MyBookedpage> {
  final Map<int, ValueNotifier<int>> pageIndexes = {};

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch booked spaces after first frame
      context.read<BookingProvider>().fetchMybookedspace();
    });
  }

  @override
  Widget build(BuildContext context) {
    print('setting');
    return Scaffold(
      appBar: AppBar(title: const Text('Booked Space')),
      body: Consumer<BookingProvider>(
        builder: (context, value, child) {
          final list = value.bookinglist;

          if (list.isEmpty) {
            return const Center(child: Text("No Booking Yet"));
          }

          return RefreshIndicator(
            onRefresh: () =>
                context.read<BookingProvider>().fetchMybookedspace(),
            child: ListView.builder(
              // controller: value.scrollController,
              itemCount: list.length,
              itemBuilder: (context, index) {
                // Create controller on demand
                pageIndexes.putIfAbsent(index, () => ValueNotifier<int>(0));

                final post = list[index];

                return BookedPostItem(
                  post: post,
                  pageNotifier: pageIndexes[index]!,
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: context.watch<BookingProvider>().ismore()
          ? FloatingActionButton(
              onPressed: () => context.read<UiProvider>().scrollToTop(),
              backgroundColor: Colors.transparent,
              elevation: 0,
              splashColor: Colors.transparent,
              child: const Icon(Icons.arrow_upward, color: Colors.red),
            )
          : null,
    );
  }
}

// Separate widget for each booked post
class BookedPostItem extends StatelessWidget {
  final BookedPost post; // Your post model
  final ValueNotifier<int> pageNotifier;
  const BookedPostItem({
    super.key,
    required this.post,
    required this.pageNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Card(
        color: const Color.fromARGB(255, 248, 248, 248),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ClipOval(
                    child: post.profilrurl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: post.profilrurl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            placeholder: (_, _) =>
                                const CupertinoActivityIndicator(radius: 12),
                            errorWidget: (_, _, _) =>
                                const Icon(Icons.person, size: 50),
                          )
                        : const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.grey,
                          ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.ownername,
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        post.createdAt.toString().substring(0, 19),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  BookPostSetting(post: post),
                ],
              ),
            ),

            // Caption
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CaptionWidget(caption: post.caption.toString()),
            ),
            SizedBox(
              height: 300,
              width: double.infinity,
              child: PageView.builder(
                onPageChanged: (page) => pageNotifier.value = page,
                itemCount: post.postimg.length,
                itemBuilder: (context, i) => CachedNetworkImage(
                  imageUrl: post.postimg[i],

                  fit: BoxFit.cover,
                  placeholder: (_, _) =>
                      const CupertinoActivityIndicator(radius: 12),
                  errorWidget: (_, _, _) =>
                      const Icon(Icons.broken_image, color: Colors.red),
                ),
              ),
            ),

            if (post.postimg.length > 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: ValueListenableBuilder<int>(
                    valueListenable: pageNotifier,
                    builder: (context, page, _) {
                      return SmoothPageIndicator(
                        controller: PageController(initialPage: page),
                        count: post.postimg.length,
                        effect: WormEffect(
                          dotHeight: 8,
                          dotWidth: 8,
                          activeDotColor: Colors.blue,
                          dotColor: Colors.grey.shade300,
                        ),
                      );
                    },
                  ),
                ),
              ),

            // Owner info
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Owner Info', style: TextStyle(fontSize: 18)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OwenerbookerDetails(
                  slots: 'Amount',
                  values: 'Rs ${post.amount} /-',
                ),
                OwenerbookerDetails(
                  slots: 'My Offer',
                  values: 'Rs ${post.offeramount} /-',
                ),
                OwenerbookerDetails(slots: 'Name', values: post.postername),
                OwenerbookerDetails(
                  slots: 'Account Name',
                  values: post.ownername,
                ),
                OwenerbookerDetails(
                  slots: 'Email Address',
                  values: post.oweneremail,
                ),
                OwenerbookerDetails(
                  slots: 'Contact Number',
                  values: post.owenernumber,
                ),
                OwenerbookerDetails(
                  slots: 'Location',
                  values: post.owenerlocation,
                ),
                OwenerbookerDetails(
                  slots: 'Booked Date & Time',
                  values:
                      'Date: ${post.bookdate.toString().substring(0, 10)}\nTime: ${post.bookdate.toString().substring(11, 19)}',
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

// class Postoption extends StatelessWidget {
//   const Postoption({
//     super.key,
//     required this.post,
//   });

//   final BookedPost post;

//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       icon: const Icon(
//         Icons.more_vert,
//         size: 22,
//       ),
//       onPressed: () {
//         showModalBottomSheet(
//           context: context,
//           shape: RoundedRectangleBorder(
//             borderRadius:
//                 BorderRadius.vertical(
//                   top: Radius.circular(
//                     20,
//                   ),
//                 ),
//           ),
//           builder: (BuildContext context) {
//             return Container(
//               padding:
//                   const EdgeInsets.all(
//                     16,
//                   ),
//               height:
//                   MediaQuery.of(
//                     context,
//                   ).size.height *
//                   0.12,
//               width: double.infinity,
//               child: Column(
//                 crossAxisAlignment:
//                     CrossAxisAlignment
//                         .start,
//                 children: [
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pop(
//                         context,
//                       );
    
//                       showDialog(
//                         context: context,
//                         builder:
//                             (
//                               BuildContext
//                               context,
//                             ) {
//                               return AlertDialog(
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius:
//                                       BorderRadius.circular(
//                                         16,
//                                       ),
//                                 ),
//                                 title: const Text(
//                                   "Delete Post",
//                                 ),
//                                 content:
//                                     const Text(
//                                       "Are you sure you want to delete this post?",
//                                     ),
//                                 actions: [
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.pop(
//                                         context,
//                                       ); //  Cancel, just close
//                                     },
//                                     child: const Text(
//                                       "Cancel",
//                                     ),
//                                   ),
//                                   ElevatedButton(
//                                     onPressed: () {
//                                       value.deleteBookedpost(
//                                         post,
//                                       );
    
//                                       // Close dialog after delete
//                                       Navigator.pop(
//                                         context,
//                                       );
//                                     },
    
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor:
//                                           Colors.red,
//                                     ),
//                                     child: const Text(
//                                       "Delete",
//                                     ),
//                                   ),
//                                 ],
//                               );
//                             },
//                       );
//                     },
//                     child: const Row(
//                       children: [
//                         Icon(
//                           Icons.delete,
//                           size: 22,
//                         ),
//                         SizedBox(
//                           width: 10,
//                         ),
    
//                         Text(
//                           'Delete Post',
//                           style: TextStyle(
//                             fontWeight:
//                                 FontWeight
//                                     .bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//         //providerr.deletePost(post); // delete post
//       },
//     );
//   }
// }
