import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mero_kotha/modelclass/modelclass.dart';
import 'package:mero_kotha/stagemanagement/statemanagement.dart';
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
        Provider.of<Providerr>(context, listen: false).fetchbookedspace();
      });
    });
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
              onRefresh: () => value.fetchbookedspace(),
              child: SingleChildScrollView(
                controller: value.scrollController,
                child: value.bookedlist.isEmpty
                    ? SizedBox(
                        height: MediaQuery.of(context).size.width,

                        child: const Center(child: Text("No one Booked Yet")),
                      )
                    : ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: value.bookedlist.length,
                        itemBuilder: (context, index) {
                          final controller = PageController();
                          final post = value.bookedlist[index];
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
                                                        ? SizedBox(
                                                            width: 50,
                                                            height: 50,
                                                            child: CachedNetworkImage(
                                                              imageUrl: post
                                                                  .profilrurl,
                                                              fit: BoxFit.cover,
                                                              placeholder:
                                                                  (
                                                                    context,
                                                                    url,
                                                                  ) => const Center(
                                                                    child:
                                                                        CupertinoActivityIndicator(
                                                                          radius:
                                                                              12,
                                                                        ),
                                                                  ),
                                                              errorWidget:
                                                                  (
                                                                    context,
                                                                    url,
                                                                    error,
                                                                  ) => const Center(
                                                                    child: Icon(
                                                                      Icons
                                                                          .broken_image,
                                                                      color: Colors
                                                                          .red,
                                                                    ),
                                                                  ),
                                                            ),
                                                          )
                                                        : const SizedBox(
                                                            width: 50,
                                                            height: 50,
                                                            child: Icon(
                                                              Icons.person,
                                                              size: 30,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
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

                                                                            style: ElevatedButton.styleFrom(
                                                                              backgroundColor: Colors.red,
                                                                            ),
                                                                            child: Text(
                                                                              "Delete",
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
                                      height: 300,
                                      width: double.infinity,
                                      child: PageView.builder(
                                        controller: controller,
                                        itemCount: post.postimg.length,
                                        itemBuilder: (context, i) {
                                          return CachedNetworkImage(
                                            imageUrl: post.postimg[i],
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
                                          );
                                        },
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (post.postimg.isNotEmpty)
                                        SmoothPageIndicator(
                                          controller: controller,
                                          count: post.postimg.length,
                                          effect: WormEffect(
                                            dotHeight: 8,
                                            dotWidth: 8,
                                            activeDotColor: Colors.blue,
                                            dotColor: Colors.grey.shade300,
                                          ),
                                        )
                                      else
                                        SizedBox.shrink(), // or leave empty space
                                    ],
                                  ),
                                  SizedBox(height: 10),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Booker info',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        OwenerbookerDetails(
                                          slots: 'Amount',
                                          values:
                                              'Rs ${post.amount.toString()} /-',
                                        ),

                                        OwenerbookerDetails(
                                          slots: 'Name',
                                          values: post.bookername,
                                        ),
                                        OwenerbookerDetails(
                                          slots: 'Account Name',
                                          values: value.username,
                                        ),
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
