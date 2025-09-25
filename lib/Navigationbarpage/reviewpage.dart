import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mero_kotha/modelclass/modelclass.dart';
import 'package:mero_kotha/stagemanagement/UserProvider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ReviewPage extends StatelessWidget {
  final TextEditingController bookercontroller;
  final TextEditingController locationcontroller;
  final TextEditingController numbercontroller;
  final TextEditingController bookeremailcontroller;
  final TextEditingController offeramountcontroller;
  const ReviewPage({
    super.key,
    required this.post,
    required this.bookercontroller,
    required this.bookeremailcontroller,
    required this.locationcontroller,
    required this.numbercontroller,
    required this.offeramountcontroller,
  });
  final Post post;

  @override
  Widget build(BuildContext context) {
    final controller = PageController();
    print('reviewpage');
    return Scaffold(
      appBar: AppBar(title: Text('Review page')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Consumer<UserProvider>(
                    builder: (context, value, child) {
                      return Container(
                        padding: EdgeInsets.all(3), // border thickness
                        decoration: BoxDecoration(
                          // border color
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: value.profilepic.isNotEmpty
                              ? SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: CachedNetworkImage(
                                    imageUrl: post.profilepicurl,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(
                                      child: CupertinoActivityIndicator(
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
                              : const SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Icon(
                                    Icons.person,
                                    size: 30,
                                    color: Colors.grey,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(post.username, style: TextStyle(fontSize: 14)),
                        Text(
                          post.createdAt.toString().substring(0, 19),
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Bookedbutton(
                    post: post,
                    bookercontroller: bookercontroller,
                    bookeremailcontroller: bookeremailcontroller,
                    locationcontroller: locationcontroller,
                    numbercontroller: numbercontroller,
                    offercontroller: offeramountcontroller,
                  ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CaptionWidget(caption: post.caption.toString()),
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
                    return InteractiveViewer(
                      panEnabled: true, // allows moving the image
                      minScale: 1,
                      maxScale: 4,
                      child: CachedNetworkImage(
                        imageUrl: post.postimg[i],
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Center(child: CupertinoActivityIndicator()),
                        errorWidget: (context, url, error) => Center(
                          child: Icon(Icons.broken_image, color: Colors.red),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            SizedBox(height: 10),
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
            SizedBox(height: 15),
            Column(
              children: [
                OwenerbookerDetails(
                  slots: 'PosterName',
                  values: post.postername,
                ),
                OwenerbookerDetails(
                  slots: 'Amount',
                  values: 'Rs ${post.ammount.toString()} /-',
                ),

                OwenerbookerDetails(
                  slots: 'Email Address',
                  values: post.oweneremail,
                ),
                OwenerbookerDetails(
                  slots: 'Contact Number',
                  values: post.owenernumber.toString(),
                ),
                OwenerbookerDetails(
                  slots: 'Location',
                  values: post.owenerlocation,
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
