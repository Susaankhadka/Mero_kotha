import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mero_kotha/Navigationbarpage/bookedpage.dart';
import 'package:mero_kotha/Navigationbarpage/createpost.dart';
import 'package:mero_kotha/Navigationbarpage/favourite.dart';
import 'package:mero_kotha/Navigationbarpage/mybooking.dart';
import 'package:mero_kotha/modelclass/modelclass.dart';
import 'package:mero_kotha/stagemanagement/Adprovider.dart';
import 'package:mero_kotha/stagemanagement/UiProvider.dart';
import 'package:mero_kotha/stagemanagement/UserProvider.dart';
import 'package:mero_kotha/stagemanagement/postprovider.dart';
import 'package:provider/provider.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen>
//  with AutomaticKeepAliveClientMixin
{
  //@override
  //bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final adsHeight = MediaQuery.of(context).size.height * 0.2;
      context.read<PostProvider>().fetchPosts();
      context.read<UserProvider>().fetchuser();
      context.read<PostProvider>().fetchsavePost();
      context.read<AdProvider>().fetchAds(adsHeight);
    });
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    print('frontprofile');
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          elevation: 0,
          backgroundColor: Colors.transparent,
          onRefresh: () async {
            await context.read<PostProvider>().fetchPosts();
          },
          child: SingleChildScrollView(
            controller: context.read<UiProvider>().scrollController,
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Find Your Right Space\nAt Right place ',
                        style: TextStyle(fontSize: 20),
                      ),
                      Image.asset(
                        'assets/images/logo.png',
                        height: 120,
                        width: 120,
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,

                  child: Row(
                    children: [
                      ActionButton(
                        icon: Icons.add,
                        label: 'Post\nRoom',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreatePostpage(),
                            ),
                          );
                        },
                        backgroundColor: Colors.blue.shade50,
                        iconColor: Colors.blue,
                      ),
                      ActionButton(
                        icon: Icons.book,
                        label: 'Book\nRoom',
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
                        label: 'My\nBookings',
                        onTap: () {
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
                        icon: Icons.favorite,
                        label: 'Saved\nPosts',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FavouritePost(),
                            ),
                          );
                        },
                        backgroundColor: Colors.green.shade50,
                        iconColor: const Color.fromARGB(255, 244, 1, 1),
                      ),
                      ActionButton(
                        icon: Icons.near_me,
                        label: 'Nearby\nroom',
                        onTap: () {},
                        backgroundColor: Colors.red.shade50,
                        iconColor: Colors.red,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Advertisement',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Consumer<AdProvider>(
                  builder: (context, adprovider, child) {
                    return adprovider.advertisement.isEmpty
                        ? const SizedBox.shrink()
                        : ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: adprovider.advertisement.length,
                            itemBuilder: (context, count) {
                              final ads = adprovider.advertisement[count];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                child: FittedBox(
                                  // height: ads.hight,

                                  // width:
                                  //     MediaQuery.of(context).size.width * 0.2,
                                  child: CachedNetworkImage(
                                    imageUrl: ads.adImg,
                                    fit: BoxFit.cover,

                                    errorWidget: (context, url, error) =>
                                        const Center(
                                          child: Icon(
                                            Icons.broken_image,
                                            color: Colors.red,
                                          ),
                                        ),
                                  ),
                                ),
                              );
                            },
                          );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
