import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mero_kotha/modelclass/modelclass.dart';
import 'package:mero_kotha/stagemanagement/statemanagement.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ReviewPage extends StatelessWidget {
  final TextEditingController bookercontroller;

  final TextEditingController locationcontroller;

  final TextEditingController numbercontroller;

  final TextEditingController bookeremailcontroller;
  const ReviewPage({
    super.key,
    required this.post,
    required this.bookercontroller,
    required this.bookeremailcontroller,
    required this.locationcontroller,
    required this.numbercontroller,
  });
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Review page')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Consumer<Providerr>(
                    builder: (context, value, child) {
                      return Container(
                        padding: EdgeInsets.all(3), // border thickness
                        decoration: BoxDecoration(
                          // border color
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: value.profilepic.isNotEmpty
                              ? Image.network(
                                  post.profilepicurl,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return const Center(
                                          child: CupertinoActivityIndicator(
                                            radius: 12,
                                          ),
                                        );
                                      },
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Icon(
                                        Icons.broken_image,
                                        color: Colors.red,
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
                height: 250,
                width: double.infinity,
                child: PageView.builder(
                  controller: PageController(),
                  itemCount: post.postimg.length,
                  itemBuilder: (context, i) {
                    return Image.network(
                      post.postimg[i],
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: CupertinoActivityIndicator(radius: 12),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.broken_image, color: Colors.red),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 10),
            SmoothPageIndicator(
              controller: PageController(),
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
                Row(
                  children: [
                    OwenerbookerDetails(
                      slots: 'Ammount Rs',
                      values: post.ammount.toString(),
                    ),
                    Text('/-'),
                  ],
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
                Bookedbutton(
                  post: post,
                  bookercontroller: bookercontroller,
                  bookeremailcontroller: bookeremailcontroller,
                  locationcontroller: locationcontroller,
                  numbercontroller: numbercontroller,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
