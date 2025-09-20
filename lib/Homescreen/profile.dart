import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mero_kotha/Homescreen/editprofile.dart';
import 'package:mero_kotha/modelclass/modelclass.dart';
import 'package:mero_kotha/stagemanagement/statemanagement.dart';
import 'package:provider/provider.dart';

class Myprofile extends StatefulWidget {
  const Myprofile({super.key});

  @override
  State<Myprofile> createState() => _MyprofileState();
}

class _MyprofileState extends State<Myprofile> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (!mounted) return;
        Provider.of<Providerr>(context, listen: false).fetchmyPosts();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print('abcd');
    final screenWidth = MediaQuery.of(context).size.width;
    final double imageSize = screenWidth * 0.25;

    return Scaffold(
      appBar: AppBar(title: const Text('My profile')),
      body: SafeArea(
        child: Consumer<Providerr>(
          builder: (context, value, child) {
            return RefreshIndicator(
              elevation: 0,
              backgroundColor: Colors.transparent,
              onRefresh: () => value.fetchmyPosts(),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () async {
                            await value.getprofileimage(
                              value.userid,
                              value.username,
                            );
                          },
                          child: Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: ClipOval(
                                  child: value.profilepic.isNotEmpty
                                      ? SizedBox(
                                          width: imageSize,
                                          height: imageSize,
                                          child: CachedNetworkImage(
                                            imageUrl: value.profilepic,
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
                                          ),
                                        )
                                      : SizedBox(
                                          width: imageSize,
                                          height: imageSize,
                                          child: Icon(
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
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Container(
                                    height: 28,
                                    width: 28,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,

                                      color: Color.fromARGB(255, 234, 230, 230),
                                    ),
                                    child: Icon(Icons.camera_alt, size: 15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Consumer<Providerr>(
                          builder: (context, providerr, child) {
                            return Text(
                              providerr.username.isNotEmpty
                                  ? providerr.username
                                  : "Loading...",
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.021,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Consumer<Providerr>(
                                builder: (context, providerr, child) {
                                  return ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(10),
                                      ),
                                      elevation: 1,
                                      backgroundColor: Color.fromARGB(
                                        244,
                                        15,
                                        39,
                                        223,
                                      ),
                                      foregroundColor: Color.fromARGB(
                                        255,
                                        255,
                                        255,
                                        255,
                                      ),
                                      minimumSize: Size(screenWidth * 0.3, 35),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      context.read<Providerr>().setIndex(2);
                                    },
                                    child: const Text('Add a post'),
                                  );
                                },
                              ),
                              Consumer<Providerr>(
                                builder: (context, providerr, child) {
                                  return ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(10),
                                      ),
                                      elevation: 1,
                                      backgroundColor: Color.fromARGB(
                                        244,
                                        205,
                                        208,
                                        232,
                                      ),
                                      foregroundColor: Color.fromARGB(
                                        255,
                                        0,
                                        0,
                                        0,
                                      ),
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
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        'My post',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Consumer<Providerr>(
                      builder: (context, providerr, child) {
                        return AllRecentPost(
                          postlist: providerr.mypostlist,
                          postcount: providerr.mypostlist.length,
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
