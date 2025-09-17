import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
    Future.microtask(
      () => Provider.of<Providerr>(context, listen: false).fetchmyPosts(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double imageSize = screenWidth * 0.25;

    return Scaffold(
      appBar: AppBar(title: const Text('My profile')),
      body: SafeArea(
        child: RefreshIndicator(
          elevation: 0,
          backgroundColor: Colors.transparent,
          onRefresh: () => Future.microtask(
            () => Provider.of<Providerr>(context, listen: false).fetchmyPosts(),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 20),
                    Consumer<Providerr>(
                      builder: (context, value, child) {
                        return GestureDetector(
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
                                      ? Image.network(
                                          value.profilepic,
                                          width: imageSize,
                                          height: imageSize,
                                          fit: BoxFit.cover,
                                          loadingBuilder:
                                              (
                                                context,
                                                child,
                                                loadingProgress,
                                              ) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                }
                                                return Container(
                                                  width: imageSize,
                                                  height: imageSize,
                                                  alignment: Alignment.center,
                                                  child:
                                                      const CupertinoActivityIndicator(),
                                                );
                                              },
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Container(
                                                  width: imageSize,
                                                  height: imageSize,
                                                  child: SvgPicture.asset(
                                                    'assets/images/profile.svg',
                                                  ),
                                                );
                                              },
                                        )
                                      : Container(
                                          width: imageSize,
                                          height: imageSize,
                                          child: SvgPicture.asset(
                                            'assets/images/profile.svg',
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
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Consumer<Providerr>(
                      builder: (context, providerr, child) {
                        return Text(
                          providerr.username.isNotEmpty
                              ? providerr.username
                              : "Loading...",
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height * 0.02,
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
                                    borderRadius: BorderRadiusGeometry.circular(
                                      10,
                                    ),
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
                                    borderRadius: BorderRadiusGeometry.circular(
                                      10,
                                    ),
                                  ),
                                  elevation: 1,
                                  backgroundColor: Color.fromARGB(
                                    244,
                                    205,
                                    208,
                                    232,
                                  ),
                                  foregroundColor: Color.fromARGB(255, 0, 0, 0),
                                  minimumSize: Size(screenWidth * 0.3, 35),
                                ),
                                onPressed: () async {},
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
        ),
      ),
    );
  }
}
