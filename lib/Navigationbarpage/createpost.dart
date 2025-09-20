import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mero_kotha/modelclass/modelclass.dart';

import 'package:mero_kotha/stagemanagement/statemanagement.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CreatePostpage extends StatefulWidget {
  const CreatePostpage({super.key});

  @override
  State<CreatePostpage> createState() => _PostpageState();
}

class _PostpageState extends State<CreatePostpage> {
  final captionController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  final owenercontroller = TextEditingController();

  final owenerlocationcontroller = TextEditingController();

  final owenernumbercontroller = TextEditingController();
  final oweneremailcontroller = TextEditingController();
  final amountcontroller = TextEditingController();

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final providerr = Provider.of<Providerr>(context, listen: false);
    final controller = PageController();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Create a new post',
            style: TextStyle(fontSize: 20),
          ),
          leading: IconButton(
            onPressed: () {
              context.read<Providerr>().setIndex(0);
              providerr.selectedimages.clear();
              captionController.clear();
              owenercontroller.clear();
              oweneremailcontroller.clear();
              owenerlocationcontroller.clear();
              owenernumbercontroller.clear();
              amountcontroller.clear();
            },
            icon: Icon(Icons.close),
          ),
          actions: [
            Consumer<Providerr>(
              builder: (context, value, child) {
                return value.selectedimages.isNotEmpty
                    ? TextButton(
                        onPressed: value.isLoading
                            ? null
                            : () async {
                                if (_formkey.currentState!.validate()) {
                                  if (providerr.selectedimages.isNotEmpty) {
                                    // Upload and create post
                                    await providerr.addpost(
                                      captionController.text.trim(),
                                      int.parse(amountcontroller.text.trim()),
                                      owenercontroller.text.toString(),
                                      owenerlocationcontroller.text.toString(),
                                      owenernumbercontroller.text.toString(),
                                      oweneremailcontroller.text.toString(),
                                    );

                                    // Clear the caption field
                                    captionController.clear();
                                    owenercontroller.clear();
                                    oweneremailcontroller.clear();
                                    owenernumbercontroller.clear();
                                    owenerlocationcontroller.clear();
                                    amountcontroller.clear();
                                    // Go back to previous screen after posting
                                  } else {
                                    // Show error/snackbar if no images or caption
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Please select images'),
                                      ),
                                    );
                                  }
                                  if (!context.mounted) return;
                                  context.read<Providerr>().setIndex(0);
                                }
                              },
                        child: value.isLoading
                            ? const CupertinoActivityIndicator()
                            : // show loader instead of text
                              const Text(
                                'Post',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(228, 0, 154, 31),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      )
                    : SizedBox();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  maxLines: 10,
                  minLines: 1,

                  controller: captionController,
                  decoration: InputDecoration(
                    hintText: 'Say about your space',
                    hintStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Consumer<Providerr>(
                  builder: (context, value, child) {
                    if (value.selectedimages.isEmpty) {
                      return Center(
                        child: SizedBox(
                          width: 300,
                          height: 300, // set your desired width
                          child: TextButton(
                            onPressed: () async {
                              providerr.getpost();
                            },
                            style: ButtonStyle(
                              overlayColor: WidgetStateProperty.all(
                                Colors.transparent,
                              ),
                            ),
                            child: Column(
                              mainAxisSize:
                                  MainAxisSize.min, // row fits its content
                              children: const [
                                Icon(Icons.image, size: 80),
                                SizedBox(width: 8),
                                Text(
                                  'Add Photos',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    return PageView.builder(
                      itemCount: value.selectedimages.length,
                      controller: controller,
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.file(
                            value.selectedimages[i],
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              Consumer<Providerr>(
                builder: (context, value, child) {
                  return value.selectedimages.isNotEmpty
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SmoothPageIndicator(
                              controller: controller,
                              count: providerr.selectedimages.length,
                              effect: WormEffect(
                                dotHeight: 8,
                                dotWidth: 8,
                                activeDotColor: Colors.blue,
                                dotColor: Colors.grey.shade300,
                              ),
                            ),
                          ],
                        )
                      : SizedBox.shrink();
                },
              ),
              SizedBox(height: 10),

              Consumer<Providerr>(
                builder: (context, value, child) {
                  return value.selectedimages.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                'Fill Details',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Form(
                              key: _formkey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Padding(
                                  //   padding: const EdgeInsets.fromLTRB(
                                  //     22,
                                  //     8,
                                  //     0,
                                  //     8,
                                  //   ),
                                  //   child: Text(
                                  //     'Name',
                                  //     style: TextStyle(
                                  //       fontWeight: FontWeight.w600,
                                  //     ),
                                  //   ),
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: TextFormField(
                                      controller: owenercontroller,
                                      onTapOutside: (event) => FocusManager
                                          .instance
                                          .primaryFocus
                                          ?.unfocus(),
                                      onFieldSubmitted: (value) => FocusManager
                                          .instance
                                          .primaryFocus
                                          ?.unfocus(),
                                      decoration: InputDecoration(
                                        filled: true,
                                        prefixIcon: Icon(Icons.person),
                                        labelText: 'Enter your Name',
                                        fillColor: Color.fromARGB(
                                          255,
                                          255,
                                          255,
                                          255,
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),

                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
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
                                      controller: oweneremailcontroller,
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
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
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
                                      controller: owenernumbercontroller,
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
                                        hoverColor: Color.fromARGB(
                                          232,
                                          9,
                                          230,
                                          49,
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
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
                                      controller: owenerlocationcontroller,
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
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
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

                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),

                                    child: TextFormField(
                                      controller: amountcontroller,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.currency_rupee),
                                        labelText: 'Amount',
                                        filled: true,

                                        fillColor: Color.fromARGB(
                                          255,
                                          255,
                                          255,
                                          255,
                                        ),

                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(
                                              255,
                                              255,
                                              6,
                                              6,
                                            ),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return "Number is required";
                                        }

                                        if (!RegExp(
                                          r'^[0-9]+$',
                                        ).hasMatch(value)) {
                                          return "Only numbers are allowed";
                                        }

                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
