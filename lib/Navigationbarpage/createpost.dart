import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mero_kotha/stagemanagement/statemanagement.dart';
import 'package:provider/provider.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a new post', style: TextStyle(fontSize: 20)),
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
                                      content: Text(
                                        'Please select images and enter a caption',
                                      ),
                                    ),
                                  );
                                }
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
                  hintText: 'Write a caption',

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
                      child: Container(
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
                          child: Row(
                            mainAxisSize:
                                MainAxisSize.min, // row fits its content
                            children: const [
                              Icon(Icons.image, size: 30),
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
            const SizedBox(height: 16),

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
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: TextFormField(
                                    controller: owenercontroller,

                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.person),
                                      hintText: 'Name',
                                      border: OutlineInputBorder(),
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
                                      hintText: 'Email',
                                      border: OutlineInputBorder(),
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
                                      border: OutlineInputBorder(),
                                      hintText: 'Phone Number',
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
                                      border: OutlineInputBorder(),
                                      hintText: 'Location',
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
                                      border: OutlineInputBorder(),
                                      hintText: 'Amount',
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
    );
  }
}
