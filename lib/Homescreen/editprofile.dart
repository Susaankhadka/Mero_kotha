import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mero_kotha/stagemanagement/statemanagement.dart';
import 'package:provider/provider.dart';

class Editprofile extends StatefulWidget {
  const Editprofile({super.key});

  @override
  State<Editprofile> createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  final _formkey = GlobalKey<FormState>();
  late TextEditingController firstnamecontroller;
  late TextEditingController lastnamecontroller;
  late TextEditingController emailcontroller;
  late TextEditingController agecontroller;
  late TextEditingController sexcontroller;
  late TextEditingController nationalitycontroller;
  late TextEditingController numbercontroller;
  late TextEditingController locationcontroller;

  @override
  void initState() {
    super.initState();
    firstnamecontroller = TextEditingController();
    lastnamecontroller = TextEditingController();
    emailcontroller = TextEditingController();
    agecontroller = TextEditingController();
    sexcontroller = TextEditingController();
    nationalitycontroller = TextEditingController();
    numbercontroller = TextEditingController();
    locationcontroller = TextEditingController();

    final provider = Provider.of<Providerr>(context, listen: false);
    if (provider.profiledetails != null) {
      _setControllers(provider);
    }

    provider.addListener(() {
      if (provider.profiledetails != null) {
        _setControllers(provider);
      }
    });
  }

  void _setControllers(Providerr provider) {
    firstnamecontroller.text = provider.profiledetails?.firstname ?? '';
    lastnamecontroller.text = provider.profiledetails?.lastname ?? '';
    emailcontroller.text = provider.profiledetails?.email ?? '';
    agecontroller.text = provider.profiledetails?.age?.toString() ?? '';
    sexcontroller.text = provider.profiledetails?.sex ?? '';
    nationalitycontroller.text = provider.profiledetails?.nationality ?? '';
    numbercontroller.text = provider.profiledetails?.number?.toString() ?? '';
    locationcontroller.text = provider.profiledetails?.location ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double imageSize = screenWidth * 0.25;
print('editprofile');
    return Scaffold(
      appBar: AppBar(title: const Text('Edit profile')),
      body: SafeArea(
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
                              decoration: BoxDecoration(shape: BoxShape.circle),
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
                          fontSize: MediaQuery.of(context).size.height * 0.022,
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
                              onPressed: () async {
                                await providerr.getprofileimage(
                                  providerr.userid,
                                  providerr.username,
                                );
                              },
                              child: const Text('Upload'),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Consumer<Providerr>(
                builder: (context, value, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          'My person Detail',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => value.iseditable(value.editable),
                        child: Row(
                          children: [
                            Text('Edit'),
                            SizedBox(width: 10),
                            value.editable
                                ? Icon(Icons.edit)
                                : Icon(Icons.edit_off),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('First Name'),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Consumer<Providerr>(
                                  builder: (context, value, child) {
                                    return Textformfield(
                                      labels:
                                          value.profiledetails?.firstname ?? '',
                                      errormessege: 'Enter First Name',
                                      textcontroller: firstnamecontroller,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Last Name'),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Consumer<Providerr>(
                                  builder: (context, value, child) {
                                    return Textformfield(
                                      labels:
                                          value.profiledetails?.lastname ?? '',
                                      errormessege: 'Enter Last Name',
                                      textcontroller: lastnamecontroller,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text('Email Address'),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Consumer<Providerr>(
                          builder: (context, value, child) {
                            return TextFormField(
                              controller: emailcontroller,
                              enabled: value.editable,
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                hintText: value.profiledetails?.email ?? '',
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 12,
                                ),
                                filled: true,
                                fillColor: Color.fromARGB(255, 255, 255, 255),
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
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Age'),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.20,
                                  child: Consumer<Providerr>(
                                    builder: (context, value, child) {
                                      return Textformfield(
                                        labels:
                                            value.profiledetails?.age
                                                .toString() ??
                                            '',
                                        errormessege: 'Enter age',
                                        textcontroller: agecontroller,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nationality'),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Consumer<Providerr>(
                                    builder: (context, valuess, child) {
                                      String? currentValue =
                                          valuess.profiledetails?.sex;

                                      if (currentValue != 'Male' &&
                                          currentValue != 'Female' &&
                                          currentValue != 'Other') {
                                        currentValue = null;
                                      }

                                      return DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                          enabled: valuess.editable,
                                          hintText: 'Select',
                                          isDense: true,
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 8,
                                            horizontal: 12,
                                          ),
                                          filled: true,
                                          fillColor: Color.fromARGB(
                                            255,
                                            255,
                                            255,
                                            255,
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
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
                                        value: currentValue,
                                        items: [
                                          DropdownMenuItem(
                                            value: 'Male',
                                            child: Text('Male'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'Female',
                                            child: Text('Female'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'Other',
                                            child: Text('Other'),
                                          ),
                                        ],
                                        onChanged: valuess.editable
                                            ? (value) {
                                                setState(() {
                                                  valuess.selectedsex = value;
                                                });
                                              }
                                            : null, // disable if not editable
                                        validator: (value) => value == null
                                            ? 'Please select an option'
                                            : null,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nationality'),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Consumer<Providerr>(
                                    builder: (context, valuess, child) {
                                      // Get the current value
                                      String? currentValue =
                                          valuess.profiledetails?.nationality;

                                      // Validate: check if currentValue matches any of the dropdown items
                                      if (currentValue != 'Nepali' &&
                                          currentValue != 'Indian' &&
                                          currentValue != 'Chinese') {
                                        currentValue =
                                            null; // fallback to null if invalid
                                      }

                                      return DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                          enabled: valuess.editable,
                                          hintText: 'Select',
                                          isDense: true,
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 8,
                                            horizontal: 12,
                                          ),
                                          filled: true,
                                          fillColor: Color.fromARGB(
                                            255,
                                            255,
                                            255,
                                            255,
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
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
                                        value: currentValue, // safe value
                                        items: [
                                          DropdownMenuItem(
                                            value: 'Nepali',
                                            child: Text('Nepali'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'Indian',
                                            child: Text('Indian'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'Chinese',
                                            child: Text('Chinese'),
                                          ),
                                        ],
                                        onChanged: valuess.editable
                                            ? (value) {
                                                setState(() {
                                                  valuess.selectedNationality =
                                                      value;
                                                });
                                              }
                                            : null, // disable if not editable
                                        validator: (value) => value == null
                                            ? 'Please select an option'
                                            : null,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text('Phone Number'),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),

                        child: Consumer<Providerr>(
                          builder: (context, value, child) {
                            return TextFormField(
                              controller: numbercontroller,
                              enabled: value.editable,
                              keyboardType: TextInputType.number,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                hintText:
                                    value.profiledetails?.number.toString() ??
                                    '',
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 12,
                                ),

                                filled: true,
                                fillColor: Color.fromARGB(255, 255, 255, 255),
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

                                String pattern = r'^(97|98)\d{8}$';
                                RegExp regex = RegExp(pattern);

                                if (!regex.hasMatch(value)) {
                                  return "Enter a valid 10-digit number starting with 97 or 98";
                                }

                                return null;
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text('Location'),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),

                        child: Consumer<Providerr>(
                          builder: (context, value, child) {
                            return Textformfield(
                              labels: value.profiledetails?.location ?? '',
                              errormessege: 'Enter Location',
                              textcontroller: locationcontroller,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Consumer<Providerr>(
                      builder: (context, value, child) {
                        return TextButton(
                          onPressed: () async {
                            await value.updateProfileInfo(
                              firstnamecontroller,
                              lastnamecontroller,
                              emailcontroller,
                              agecontroller,
                              value.selectedsex ?? '',
                              value.selectedNationality ?? '',
                              numbercontroller,
                              locationcontroller,
                            );

                            value.iseditable(value.editable);
                          },
                          child: Row(
                            children: [
                              Icon(Icons.save_as_outlined),
                              SizedBox(width: 10),
                              Text('Save changes'),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Textformfield extends StatelessWidget {
  const Textformfield({
    required this.labels,
    required this.errormessege,
    super.key,
    required this.textcontroller,
  });
  final String labels;
  final String errormessege;
  final TextEditingController textcontroller;

  @override
  Widget build(BuildContext context) {
    return Consumer<Providerr>(
      builder: (context, value, child) {
        return TextFormField(
          controller: textcontroller,
          enabled: value.editable,

          decoration: InputDecoration(
            hintText: labels,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            filled: true,
            fillColor: Color.fromARGB(255, 255, 255, 255),
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
          style: TextStyle(color: Colors.black),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return errormessege;
            }
            return null;
          },
        );
      },
    );
  }
}
