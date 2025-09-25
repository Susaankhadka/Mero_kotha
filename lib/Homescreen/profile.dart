import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mero_kotha/Homescreen/editprofile.dart';
import 'package:mero_kotha/Navigationbarpage/createpost.dart';
import 'package:mero_kotha/modelclass/modelclass.dart';
import 'package:mero_kotha/stagemanagement/UiProvider.dart';
import 'package:mero_kotha/stagemanagement/UserProvider.dart';
import 'package:mero_kotha/stagemanagement/postprovider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Myprofile extends StatefulWidget {
  const Myprofile({super.key});

  @override
  State<Myprofile> createState() => _MyprofileState();
}

class _MyprofileState extends State<Myprofile> {
  final Map<int, PageController> pageControllers = {};
  final Map<int, ValueNotifier<int>> pageIndexes = {};

  final bookercontroller = TextEditingController();
  final locationcontroller = TextEditingController();
  final numbercontroller = TextEditingController();
  final bookeremailcontroller = TextEditingController();
  final offeramountcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<PostProvider>().fetchmyPosts();
    });
  }

  @override
  void dispose() {
    bookercontroller.dispose();
    locationcontroller.dispose();
    numbercontroller.dispose();
    bookeremailcontroller.dispose();
    offeramountcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double imageSize = screenWidth * 0.25;

    return Scaffold(
      appBar: AppBar(title: const Text('My profile')),
      body: Consumer3<UserProvider, PostProvider, UiProvider>(
        builder: (context, userprovider, postprovider, uiProvider, child) {
          final postlist = postprovider.mypostlist;

          return RefreshIndicator(
            onRefresh: () => postprovider.fetchmyPosts(),
            child: CustomScrollView(
              slivers: [
                // Profile Header
                SliverToBoxAdapter(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () async {
                          await userprovider.getprofileimage(
                            userprovider.userid,
                            userprovider.username,
                          );
                        },
                        child: Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(
                                child: userprovider.profilepic.isNotEmpty
                                    ? SizedBox(
                                        width: imageSize,
                                        height: imageSize,
                                        child: CachedNetworkImage(
                                          imageUrl: userprovider.profilepic,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              const Center(
                                                child:
                                                    CupertinoActivityIndicator(
                                                      radius: 12,
                                                    ),
                                              ),
                                          errorWidget: (context, url, error) =>
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
                            ),
                            Container(
                              height: 32,
                              width: 32,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Container(
                                  height: 28,
                                  width: 28,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color.fromARGB(255, 234, 230, 230),
                                  ),
                                  child: const Icon(Icons.camera_alt, size: 15),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        userprovider.username.isNotEmpty
                            ? userprovider.username
                            : "Loading...",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.021,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 1,
                                backgroundColor: const Color.fromARGB(
                                  244,
                                  15,
                                  39,
                                  223,
                                ),
                                foregroundColor: Colors.white,
                                minimumSize: Size(screenWidth * 0.3, 35),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CreatePostpage(),
                                  ),
                                );
                              },
                              child: const Text('Add a post'),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 1,
                                backgroundColor: const Color.fromARGB(
                                  244,
                                  205,
                                  208,
                                  232,
                                ),
                                foregroundColor: Colors.black,
                                minimumSize: Size(screenWidth * 0.3, 35),
                              ),
                              onPressed: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Editprofile(),
                                  ),
                                );
                              },
                              child: const Text('Edit Profile'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'My post',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Post list
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final post = postlist[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: Card(
                        color: const Color.fromARGB(255, 248, 248, 248),
                        shape: BeveledRectangleBorder(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Post header
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  ClipOval(
                                    child: post.profilepicurl.isNotEmpty
                                        ? SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: CachedNetworkImage(
                                              imageUrl: post.profilepicurl,
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
                                                      const Icon(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(post.username),
                                      Text(
                                        post.createdAt.toString().substring(
                                          0,
                                          19,
                                        ),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Postsettingoption(post: post),
                                ],
                              ),
                            ),

                            // Caption
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: CaptionWidget(
                                caption: post.caption.toString(),
                              ),
                            ),

                            // Post images
                            SizedBox(
                              height: 350,
                              width: double.infinity,
                              child: PageView.builder(
                                controller: PageController(),
                                itemCount: post.postimg.length,

                                itemBuilder: (context, i) => CachedNetworkImage(
                                  imageUrl: post.postimg[i],
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CupertinoActivityIndicator(
                                      radius: 12,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(
                                        Icons.broken_image,
                                        color: Colors.red,
                                      ),
                                ),
                              ),
                            ),

                            // Page indicator
                            // if (post.postimg.length > 1)
                            //   Padding(
                            //     padding: const EdgeInsets.all(8.0),
                            //     child: SmoothPageIndicator(
                            //       controller: PageController(),
                            //       count: post.postimg.length,
                            //       effect: WormEffect(
                            //         dotHeight: 8,
                            //         dotWidth: 8,
                            //         activeDotColor: Colors.blue,
                            //         dotColor: Colors.grey.shade300,
                            //       ),
                            //     ),
                            //   ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    );
                  }, childCount: postlist.length),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
