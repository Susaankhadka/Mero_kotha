import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mero_kotha/modelclass/modelclass.dart';
import 'package:mero_kotha/stagemanagement/statemanagement.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MyBookedpage extends StatefulWidget {
  const MyBookedpage({super.key});

  @override
  State<MyBookedpage> createState() => _MyBookedpageState();
}

class _MyBookedpageState extends State<MyBookedpage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<Providerr>(context, listen: false).fetchMybookedspace(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final providerr = Provider.of<Providerr>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text('Booked Space')),
      body: SafeArea(
        child: Consumer<Providerr>(
          builder: (context, value, child) {
            return RefreshIndicator(
              elevation: 0,
              backgroundColor: Colors.transparent,
              onRefresh: () => Future.microtask(
                () => Provider.of<Providerr>(
                  context,
                  listen: false,
                ).fetchMybookedspace(),
              ),
              child: SingleChildScrollView(
                controller: value.scrollController,
                child: value.bookinglist.isEmpty
                    ? SizedBox(
                        height: MediaQuery.of(context).size.width,

                        child: const Center(child: Text("No Booking Yet")),
                      )
                    : ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: value.bookinglist.length,
                        itemBuilder: (context, index) {
                          final controller = PageController();
                          final post = value.bookinglist[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 1),
                            child: Card(
                              color: Color.fromARGB(255, 248, 248, 248),

                              shape: BeveledRectangleBorder(),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Consumer<Providerr>(
                                              builder: (context, value, child) {
                                                return Container(
                                                  padding: EdgeInsets.all(
                                                    3,
                                                  ), // border thickness
                                                  decoration: BoxDecoration(
                                                    // border color
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: ClipOval(
                                                    child:
                                                        post
                                                            .profilrurl
                                                            .isNotEmpty
                                                        ? Image.network(
                                                            post.profilrurl,
                                                            loadingBuilder:
                                                                (
                                                                  context,
                                                                  child,
                                                                  loadingProgress,
                                                                ) {
                                                                  if (loadingProgress ==
                                                                      null) {
                                                                    return child;
                                                                  }
                                                                  return const Center(
                                                                    child:
                                                                        CupertinoActivityIndicator(
                                                                          radius:
                                                                              12,
                                                                        ),
                                                                  );
                                                                },
                                                            errorBuilder:
                                                                (
                                                                  context,
                                                                  error,
                                                                  stackTrace,
                                                                ) {
                                                                  return const Center(
                                                                    child: Icon(
                                                                      Icons
                                                                          .broken_image,
                                                                      color: Colors
                                                                          .red,
                                                                    ),
                                                                  );
                                                                },
                                                            width: 50,
                                                            height: 50,
                                                            fit: BoxFit.cover,
                                                          )
                                                        : CupertinoActivityIndicator(),
                                                  ),
                                                );
                                              },
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(
                                                12.0,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    post.ownername,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  Text(
                                                    post.createdAt
                                                        .toString()
                                                        .substring(0, 19),
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            Spacer(),
                                            IconButton(
                                              icon: Icon(
                                                Icons.more_vert,
                                                size: 22,
                                              ),
                                              onPressed: () {
                                                showModalBottomSheet(
                                                  context: context,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                          top: Radius.circular(
                                                            20,
                                                          ),
                                                        ),
                                                  ),
                                                  builder: (BuildContext context) {
                                                    return Container(
                                                      padding: EdgeInsets.all(
                                                        16,
                                                      ),
                                                      height:
                                                          MediaQuery.of(
                                                            context,
                                                          ).size.height *
                                                          0.12,
                                                      width: double.infinity,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                context,
                                                              );

                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (
                                                                      BuildContext
                                                                      context,
                                                                    ) {
                                                                      return AlertDialog(
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(
                                                                            16,
                                                                          ),
                                                                        ),
                                                                        title: Text(
                                                                          "Delete Post",
                                                                        ),
                                                                        content:
                                                                            Text(
                                                                              "Are you sure you want to delete this post?",
                                                                            ),
                                                                        actions: [
                                                                          TextButton(
                                                                            onPressed: () {
                                                                              Navigator.pop(
                                                                                context,
                                                                              ); //  Cancel, just close
                                                                            },
                                                                            child: Text(
                                                                              "Cancel",
                                                                            ),
                                                                          ),
                                                                          ElevatedButton(
                                                                            onPressed: () {
                                                                              value.deleteBookedpost(
                                                                                post,
                                                                              );

                                                                              // Close dialog after delete
                                                                              Navigator.pop(
                                                                                context,
                                                                              );
                                                                            },
                                                                            child: Text(
                                                                              "Delete",
                                                                            ),
                                                                            style: ElevatedButton.styleFrom(
                                                                              backgroundColor: Colors.red,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      );
                                                                    },
                                                              );
                                                            },
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  Icons.delete,
                                                                  size: 22,
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),

                                                                Text(
                                                                  'Delete Post',
                                                                  style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        16,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                                //providerr.deletePost(post); // delete post
                                              },
                                            ),
                                          ],
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                        ),
                                        child: CaptionWidget(
                                          caption: post.caption.toString(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Card(
                                    child: SizedBox(
                                      height: 200,
                                      width: double.infinity,
                                      child: PageView.builder(
                                        controller: controller,
                                        itemCount: post.postimg.isNotEmpty
                                            ? post.postimg.length
                                            : 1,
                                        itemBuilder: (context, i) {
                                          final imageUrl =
                                              post.postimg.isNotEmpty
                                              ? post.postimg[i]
                                              : "";

                                          if (imageUrl.isEmpty) {
                                            return const Center(
                                              child: Icon(
                                                Icons.broken_image,
                                                color: Colors.red,
                                              ),
                                            );
                                          }

                                          return Image.network(
                                            imageUrl,
                                            fit: BoxFit.cover,
                                            loadingBuilder:
                                                (
                                                  context,
                                                  child,
                                                  loadingProgress,
                                                ) {
                                                  if (loadingProgress == null)
                                                    return child;
                                                  return const Center(
                                                    child:
                                                        CupertinoActivityIndicator(
                                                          radius: 12,
                                                        ),
                                                  );
                                                },
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return const Center(
                                                    child: Icon(
                                                      Icons.broken_image,
                                                      color: Colors.red,
                                                    ),
                                                  );
                                                },
                                          );
                                        },
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SmoothPageIndicator(
                                        controller: controller,
                                        count: post.postimg.length,
                                        effect: WormEffect(
                                          dotHeight: 8,
                                          dotWidth: 8,
                                          activeDotColor: Colors.blue,
                                          dotColor: Colors.grey.shade300,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Owener info',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ],
                                  ),

                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          OwenerbookerDetails(
                                            slots: 'Amount Rs',
                                            values: post.amount.toString(),
                                          ),
                                          Text('/-'),
                                        ],
                                      ),
                                      OwenerbookerDetails(
                                        slots: 'Name',
                                        values: post.postername,
                                      ),
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
                                        slots: 'Booked Date',
                                        values: post.createdAt
                                            .toString()
                                            .substring(0, 19),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: providerr.ismore()
          ? FloatingActionButton(
              onPressed: () {
                context.read<Providerr>().scrollToTop();
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              highlightElevation: 0,
              splashColor: Colors.transparent, // disable ripple

              child: Icon(
                Icons.arrow_upward,
                color: Color.fromARGB(255, 251, 13, 0),
              ),
            )
          : null,
    );
  }
}
