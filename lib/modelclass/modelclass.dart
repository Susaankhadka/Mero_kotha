import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mero_kotha/Navigationbarpage/reviewpage.dart';
import 'package:mero_kotha/stagemanagement/statemanagement.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Profiledetails {
  int id;
  int? age;
  String? lastname;
  String? firstname;
  String? nationality;
  String? sex;
  String? email;
  String? location;
  int? number;

  Profiledetails({
    required this.id,
    this.age,
    this.email,
    this.firstname,
    this.lastname,
    this.location,
    this.nationality,
    this.number,
    this.sex,
  });
}

class Post {
  final int id;
  final int ammount;
  final String postername;
  final String userid;
  final String username;
  final String profilepicurl;
  final String oweneremail;
  final String owenerlocation;
  final String owenernumber;
  final List<String> postimg; // URLs
  final List<String> imagePaths; // storage paths
  final String caption;

  final DateTime createdAt;

  Post({
    required this.id,
    required this.ammount,
    required this.postername,
    required this.userid,
    required this.username,
    required this.profilepicurl,
    required this.oweneremail,
    required this.owenerlocation,
    required this.owenernumber,
    required this.postimg,
    required this.imagePaths,
    required this.caption,
    required this.createdAt,
  });
}

class BookedPost {
  final int id;
  final int amount;
  final String postername;
  final String oweneremail;
  final String owenerlocation;
  final String owenernumber;
  final String ownername;
  final String bookeraccount;
  final String bookerlocation;
  final String bookernumber;
  final String bookergmail;
  final String bookername;
  final List<String> postimg; // URLs
  final String profilrurl;
  final String caption;
  final DateTime bookdate;
  final DateTime createdAt;

  BookedPost({
    required this.id,
    required this.amount,
    required this.postername,
    required this.oweneremail,
    required this.owenerlocation,
    required this.owenernumber,
    required this.bookeraccount,
    required this.bookergmail,
    required this.bookerlocation,
    required this.ownername,
    required this.bookername,
    required this.postimg,
    required this.bookernumber,
    required this.caption,
    required this.profilrurl,
    required this.bookdate,
    required this.createdAt,
  });
}

class Place {
  final String placename;
  final String placeimg;
  Place({required this.placename, required this.placeimg});
}

List<Place> placelist = [
  Place(placename: 'Kathmandu', placeimg: 'assets/images/IMG_4768.jpg'),
  Place(
    placename: 'Bhaktapur',
    placeimg: 'assets/images/tallest-temple-of-nepal.jpg',
  ),
  Place(
    placename: 'Lalitpur',
    placeimg: 'assets/images/Durbar-Square-Lalitpur-Nepal.jpg.webp',
  ),
  Place(placename: 'Pokhara', placeimg: 'assets/images/pokhara-socoal.webp'),
  Place(placename: 'Kalinchok', placeimg: 'assets/images/licensed-image.jpeg'),
  Place(placename: 'Chitwan', placeimg: 'assets/images/thumb.php.jpeg'),
];

class AllRecentPost extends StatefulWidget {
  final List postlist;
  final int postcount;
  const AllRecentPost({
    required this.postlist,
    required this.postcount,
    super.key,
  });

  @override
  State<AllRecentPost> createState() => _AllRecentPostState();
}

class _AllRecentPostState extends State<AllRecentPost> {
  final bookercontroller = TextEditingController();

  final locationcontroller = TextEditingController();

  final numbercontroller = TextEditingController();
  final bookeremailcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<Providerr>(
      builder: (context, value, child) {
        return widget.postlist.isEmpty
            ? const Center(child: CupertinoActivityIndicator())
            : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.postcount,
                itemBuilder: (context, index) {
                  final controller = PageController();
                  final post = widget.postlist[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: Card(
                      color: Color.fromARGB(255, 248, 248, 248),

                      shape: BeveledRectangleBorder(),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                            child: value.profilepic.isNotEmpty
                                                ? SizedBox(
                                                    width: 50,
                                                    height: 50,
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          post.profilepicurl,
                                                      fit: BoxFit.cover,
                                                      placeholder:
                                                          (
                                                            context,
                                                            url,
                                                          ) => const Center(
                                                            child:
                                                                CupertinoActivityIndicator(
                                                                  radius: 12,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            post.username,
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          Text(
                                            post.createdAt.toString().substring(
                                              0,
                                              19,
                                            ),
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
                                      icon: Icon(Icons.more_vert, size: 22),
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20),
                                            ),
                                          ),
                                          builder: (BuildContext context) {
                                            final supabase =
                                                Supabase.instance.client;
                                            return Container(
                                              padding: EdgeInsets.all(16),
                                              height:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.height *
                                                  0.12,
                                              width: double.infinity,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  post.userid ==
                                                          supabase
                                                              .auth
                                                              .currentUser!
                                                              .id
                                                      ? TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                              context,
                                                            );

                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (
                                                                    BuildContext
                                                                    context,
                                                                  ) {
                                                                    return AlertDialog(
                                                                      shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                              16,
                                                                            ),
                                                                      ),
                                                                      title: Text(
                                                                        "Delete Post",
                                                                      ),
                                                                      content: Text(
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
                                                                          onPressed: () async {
                                                                            // ✅ Do your delete action here
                                                                            value.deletePost(
                                                                              post,
                                                                            );

                                                                            // Close dialog after delete
                                                                            Navigator.pop(
                                                                              context,
                                                                            );
                                                                          },

                                                                          style: ElevatedButton.styleFrom(
                                                                            backgroundColor:
                                                                                Colors.red,
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
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                context,
                                                              ),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons.close,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 15,
                                                                  ),
                                                                  Text('close'),
                                                                ],
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
                            shape: RoundedRectangleBorder(),
                            child: SizedBox(
                              height: 300,
                              width: double.infinity,
                              child: PageView.builder(
                                controller: controller,
                                itemCount: post.postimg.length,
                                itemBuilder: (context, i) {
                                  return CachedNetworkImage(
                                    imageUrl: post.postimg[i],
                                    fit: BoxFit.contain,
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
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(120, 35),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  backgroundColor: Color.fromARGB(
                                    255,
                                    141,
                                    6,
                                    231,
                                  ),
                                  foregroundColor: Color.fromARGB(
                                    255,
                                    255,
                                    255,
                                    255,
                                  ),
                                ),
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      pageBuilder:
                                          (
                                            context,
                                            animation,
                                            secondaryAnimation,
                                          ) => ReviewPage(
                                            post: post,
                                            bookercontroller: bookercontroller,
                                            bookeremailcontroller:
                                                bookeremailcontroller,
                                            locationcontroller:
                                                locationcontroller,
                                            numbercontroller: numbercontroller,
                                          ),
                                      transitionsBuilder:
                                          (
                                            context,
                                            animation,
                                            secondaryAnimation,
                                            child,
                                          ) {
                                            return FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            );
                                          },
                                    ),
                                  );
                                },
                                child: Text(
                                  'Review',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
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
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  );
                },
              );
      },
    );
  }
}

class CaptionWidget extends StatefulWidget {
  final String caption;
  const CaptionWidget({super.key, required this.caption});

  @override
  State<CaptionWidget> createState() => _CaptionWidgetState();
}

class _CaptionWidgetState extends State<CaptionWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.caption,
          maxLines: isExpanded ? null : 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 14),
        ),
        if (widget.caption.length > 100)
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded; // toggle
              });
            },
            child: Text(
              isExpanded ? 'See less' : 'See more',
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}

class SettingBlocks extends StatelessWidget {
  final String settingname;
  final Icon icons;
  final VoidCallback? onclick;
  const SettingBlocks({
    required this.settingname,
    required this.icons,
    this.onclick,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onclick,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            icons,
            SizedBox(width: 10),
            Text(settingname),
            Spacer(),
            Icon(Icons.arrow_forward_ios, size: 15),
          ],
        ),
      ),
    );
  }
}

class OwenerbookerDetails extends StatelessWidget {
  final String slots;
  final String values;
  const OwenerbookerDetails({
    required this.slots,
    required this.values,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: Text(
                slots,
                style: TextStyle(
                  color: Color.fromARGB(233, 250, 155, 2),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Text(': '),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.55,
            child: Text(values),
          ),
        ],
      ),
    );
  }
}

class Bookedbutton extends StatelessWidget {
  final Post post;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController bookercontroller;

  final TextEditingController locationcontroller;

  final TextEditingController numbercontroller;

  final TextEditingController bookeremailcontroller;
  Bookedbutton({
    super.key,
    required this.post,
    required this.bookercontroller,
    required this.bookeremailcontroller,
    required this.locationcontroller,
    required this.numbercontroller,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<Providerr>(
      builder: (context, value, child) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(120, 35),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            backgroundColor: Color.fromARGB(255, 33, 126, 8),
            foregroundColor: Color.fromARGB(255, 255, 255, 255),
          ),
          onPressed: () async {
            showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
              ),
              builder: (BuildContext context) {
                return SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.65,
                    width: double.infinity,
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Fill Details',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            TextButton(
                              style: TextButton.styleFrom(
                                overlayColor: Colors.transparent,
                              ),
                              onPressed: () {
                                if (_formkey.currentState!.validate()) {
                                  Navigator.pop(context);

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        title: Text("Book now"),
                                        content: Text(
                                          "Are you sure you want to Book this space?",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(
                                                context,
                                              ); //  Cancel, just close
                                            },
                                            child: Text("Cancel"),
                                          ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              await value.bookedspace(
                                                post,
                                                bookercontroller.text
                                                    .toString(),
                                                locationcontroller.text
                                                    .toString(),
                                                numbercontroller.text
                                                    .toString(),
                                                bookeremailcontroller.text
                                                    .toString(),
                                              );
                                              if (!context.mounted) return;
                                              bookercontroller.clear();
                                              bookeremailcontroller.clear();
                                              numbercontroller.clear();
                                              locationcontroller.clear();
                                              Navigator.pop(context);
                                            },

                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                            ),
                                            child: Text("Book"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.send,
                                    color: Color.fromARGB(255, 1, 88, 26),
                                    size: 22,
                                  ),
                                  SizedBox(width: 10),

                                  Text(
                                    'Submit',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                            key: _formkey,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: TextFormField(
                                    controller: bookercontroller,

                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.person),
                                      labelText: 'Enter your Name',
                                      filled: true,
                                      fillColor: Color.fromARGB(
                                        255,
                                        255,
                                        255,
                                        255,
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your Name';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: TextFormField(
                                    controller: bookeremailcontroller,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.email),
                                      labelText: 'Email Address',
                                      filled: true,
                                      fillColor: Color.fromARGB(
                                        255,
                                        255,
                                        255,
                                        255,
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Email is required";
                                      }
                                      // ✅ Regular email pattern
                                      String pattern =
                                          r'^[a-zA-Z0-9._%+-]+@gmail\.com$';
                                      RegExp regex = RegExp(pattern);

                                      if (!regex.hasMatch(value)) {
                                        return "Enter a valid Gmail address";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),

                                  child: TextFormField(
                                    controller: numbercontroller,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.phone),
                                      labelText: 'Phone Number',
                                      filled: true,
                                      fillColor: Color.fromARGB(
                                        255,
                                        255,
                                        255,
                                        255,
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Phone number is required";
                                      }

                                      // ✅ Regex for 10 digits starting with 97 or 98
                                      String pattern = r'^(97|98)\d{8}$';
                                      RegExp regex = RegExp(pattern);

                                      if (!regex.hasMatch(value)) {
                                        return "Enter a valid 10-digit number starting with 97 or 98";
                                      }

                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(height: 10),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),

                                  child: TextFormField(
                                    controller: locationcontroller,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.location_on),
                                      labelText: 'Location',
                                      filled: true,
                                      fillColor: Color.fromARGB(
                                        255,
                                        255,
                                        255,
                                        255,
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your location';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
          child: Text(
            'Book Now',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}

Color textfillcolor = Color.fromARGB(255, 215, 209, 209);

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.backgroundColor = Colors.white,
    this.iconColor = Colors.blue,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.15,
        width: MediaQuery.of(context).size.width * 0.28,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(136, 158, 158, 158),
              spreadRadius: 2,
              blurRadius: 6,
              offset: Offset(0, 3), // shadow position
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: MediaQuery.of(context).size.height * 0.040,
              color: iconColor,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.height * 0.018,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
