import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mero_kotha/modelclass/modelclass.dart';
import 'package:mero_kotha/stagemanagement/BookingProvider.dart';
import 'package:mero_kotha/stagemanagement/UiProvider.dart';
import 'package:mero_kotha/stagemanagement/UserProvider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Bookedpage extends StatefulWidget {
  const Bookedpage({super.key});

  @override
  State<Bookedpage> createState() => _BookedpageState();
}

class _BookedpageState extends State<Bookedpage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (!mounted) return;
        context.read<BookingProvider>().fetchbookedspace();
      });
    });
  }

  final Map<int, ValueNotifier<int>> pageIndexes = {};

  @override
  Widget build(BuildContext context) {
    // final providerr = Provider.of<Providerr>(context, listen: false);
    print('bookpost');
    return Scaffold(
      appBar: AppBar(title: const Text('Booked Space')),
      body: SafeArea(
        child: Consumer2<BookingProvider, UserProvider>(
          builder: (context, bookingprovider, userprovider, child) {
            final bookedList = bookingprovider.bookedlist;
            print(bookedList);
            if (bookedList.isEmpty) {
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: const Center(child: Text("No one Booked Yet")),
              );
            }

            return RefreshIndicator(
              onRefresh: () => bookingprovider.fetchbookedspace(),
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: bookedList.length,
                itemBuilder: (context, index) {
                  pageIndexes.putIfAbsent(index, () => ValueNotifier<int>(0));

                  final post = bookedList[index];

                  return BookedPostItem(
                    post: post,
                    pageNotifier: pageIndexes[index]!,
                    username: userprovider.username,
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: context.watch<BookingProvider>().ismore()
          ? FloatingActionButton(
              onPressed: () {
                context.read<UiProvider>().scrollToTop();
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              highlightElevation: 0,
              splashColor: Colors.transparent,
              child: const Icon(
                Icons.arrow_upward,
                color: Color.fromARGB(255, 251, 13, 0),
              ),
            )
          : null,
    );
  }
}

class BookedPostItem extends StatelessWidget {
  final BookedPost post;
  final ValueNotifier<int> pageNotifier;
  final String username;

  const BookedPostItem({
    super.key,

    required this.post,
    required this.pageNotifier,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Card(
        color: const Color.fromARGB(255, 248, 248, 248),
        shape: BeveledRectangleBorder(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  ClipOval(
                    child: post.profilrurl.isNotEmpty
                        ? SizedBox(
                            width: 50,
                            height: 50,
                            child: CachedNetworkImage(
                              imageUrl: post.profilrurl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CupertinoActivityIndicator(radius: 12),
                              ),
                              errorWidget: (context, url, error) => const Icon(
                                Icons.person,
                                size: 30,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.grey,
                          ),
                  ),
                  const SizedBox(width: 10),
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

            // Image carousel
            SizedBox(
              height: 300,
              width: double.infinity,
              child: PageView.builder(
                onPageChanged: (page) => pageNotifier.value = page,
                itemCount: post.postimg.length,
                itemBuilder: (context, i) => CachedNetworkImage(
                  imageUrl: post.postimg[i],
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CupertinoActivityIndicator(radius: 12),
                  ),
                  errorWidget: (context, url, error) =>
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

            // Booker info
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Booker info', style: TextStyle(fontSize: 18)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OwenerbookerDetails(
                  slots: 'Amount',
                  values: 'Rs ${post.amount} /-',
                ),
                OwenerbookerDetails(
                  slots: 'Booker Offer',
                  values: 'Rs ${post.offeramount} /-',
                ),
                OwenerbookerDetails(slots: 'Name', values: post.bookername),
                OwenerbookerDetails(slots: 'Account Name', values: username),
                OwenerbookerDetails(
                  slots: 'Email Address',
                  values: post.bookergmail,
                ),
                OwenerbookerDetails(
                  slots: 'Contact Number',
                  values: post.bookernumber,
                ),
                OwenerbookerDetails(
                  slots: 'Location',
                  values: post.bookerlocation,
                ),
                OwenerbookerDetails(
                  slots: 'Booked Date',
                  values:
                      'Date: ${post.bookdate.toString().substring(0, 10)}\nTime: ${post.bookdate.toString().substring(11, 19)}',
                ),
              ],
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}

class BookPostSetting extends StatelessWidget {
  const BookPostSetting({super.key, required this.post});

  final BookedPost? post;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete, size: 22),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text("Delete Post"),
              content: const Text("Are you sure you want to delete this post?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); //  Cancel, just close
                  },
                  child: const Text("Cancel"),
                ),

                ElevatedButton(
                  onPressed: () {
                    context.read<BookingProvider>().deleteBookedpost(post!);

                    // Close dialog after delete
                    Navigator.pop(context);
                  },

                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Delete"),
                ),
              ],
            );
          },
        );
        // showModalBottomSheet(
        //   context: context,
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        //   ),
        //   builder: (BuildContext context) {
        //     return Container(
        //       padding: EdgeInsets.all(16),
        //       height: MediaQuery.of(context).size.height * 0.12,
        //       width: double.infinity,
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           TextButton(
        //             onPressed: () {
        //               Navigator.pop(context);

        //               showDialog(
        //                 context: context,
        //                 builder: (BuildContext context) {
        //                   return AlertDialog(
        //                     shape: RoundedRectangleBorder(
        //                       borderRadius: BorderRadius.circular(16),
        //                     ),
        //                     title: const Text("Delete Post"),
        //                     content: const Text(
        //                       "Are you sure you want to delete this post?",
        //                     ),
        //                     actions: [
        //                       TextButton(
        //                         onPressed: () {
        //                           Navigator.pop(context); //  Cancel, just close
        //                         },
        //                         child: const Text("Cancel"),
        //                       ),
        //                       Consumer<Providerr>(
        //                         builder: (context, value, child) {
        //                           return ElevatedButton(
        //                             onPressed: () {
        //                               value.deleteBookedpost(post!);

        //                               // Close dialog after delete
        //                               Navigator.pop(context);
        //                             },

        //                             style: ElevatedButton.styleFrom(
        //                               backgroundColor: Colors.red,
        //                             ),
        //                             child: const Text("Delete"),
        //                           );
        //                         },
        //                       ),
        //                     ],
        //                   );
        //                 },
        //               );
        //             },
        //             child: const Row(
        //               children: [
        //                 Icon(Icons.delete, size: 22),
        //                 SizedBox(width: 10),

        //                 Text(
        //                   'Delete Post',
        //                   style: TextStyle(
        //                     fontWeight: FontWeight.bold,
        //                     fontSize: 16,
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ],
        //       ),
        //     );
        //   },
        // );
        //providerr.deletePost(post); // delete post
      },
    );
  }
}
