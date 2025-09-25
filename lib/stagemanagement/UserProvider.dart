import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../modelclass/modelclass.dart';

class UserProvider with ChangeNotifier {
  ScrollController scrollController = ScrollController();
  String _username = "";
  String get username => _username;
  int selectedIndex = 0;
  String _userid = "";
  String get userid => _userid;

  String _userrole = "";
  String get userrole => _userrole;

  File? _profilepicture;
  String _profilepic = "";
  String get profilepic => _profilepic;
  String? selectedNationality;

  String? selectedsex;

  void clearprofilename() {
    _profilepic = "";
    notifyListeners();
  }

  Profiledetails? profiledetails;

  void scrollToTop() {
    scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void setIndex(int index) {
    if (selectedIndex == index) {
      if (index == 0 || index == 1) {
        scrollToTop();
      }
    } else {
      selectedIndex = index;
      notifyListeners();
    }
    notifyListeners();
  }

  Future<void> updateProfileInfo(
    TextEditingController firstname,
    TextEditingController lastname,
    TextEditingController email,
    TextEditingController age,
    String sex,
    String nationality,
    TextEditingController phone,
    TextEditingController location,
  ) async {
    try {
      final supa = Supabase.instance.client;
      final user = supa.auth.currentUser;
      final existing = await supa
          .from('profileDetails')
          .select()
          .eq('userid', user!.id);

      if (existing.isEmpty) {
        await supa.from('profileDetails').insert({
          'userid': user.id,
          'firstname': firstname.text,
          'lastname': lastname.text,
          'email_address': email.text,
          'age': int.tryParse(age.text),
          'sex': sex,
          'Nationality': nationality,
          'phonenumber': int.tryParse(phone.text),
          'location': location.text,
        });
      } else {
        await supa
            .from('profileDetails')
            .update({
              'firstname': firstname.text,
              'lastname': lastname.text,
              'email_address': email.text,
              'age': int.tryParse(age.text),
              'sex': sex,
              'Nationality': nationality,
              'phonenumber': int.tryParse(phone.text),
              'location': location.text,
            })
            .eq('userid', user.id);
      }
    } catch (e) {
      print('Failed to update profile: $e');
    }
    await fetchprofileinfo();
  }

  Future<void> fetchprofileinfo() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    try {
      final userprofiledata = await Supabase.instance.client
          .from('profileDetails')
          .select()
          .eq('userid', user!.id);

      if (userprofiledata != null && userprofiledata.isNotEmpty) {
        for (var item in userprofiledata) {
          profiledetails = Profiledetails(
            id: item['id'],
            age: item['age'] != null ? int.tryParse(item['age'].toString()) : 0,
            email: item['email_address'] ?? '',
            firstname: item['firstname'] ?? '',
            lastname: item['lastname'] ?? '',
            sex: item['sex'] ?? '',
            location: item['location'] ?? '',
            nationality: item['Nationality'] ?? '',
            number: item['phonenumber'] != null
                ? int.tryParse(item['phonenumber'].toString())
                : 0,
          );
        }
      }
    } catch (e) {
      print('No data fetch: $e');
    }

    notifyListeners();
  }

  Future<void> fetchuser() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    try {
      if (user != null) {
        final userdata = await Supabase.instance.client
            .from('profile')
            .select('username,role,userid,profile_pic')
            .eq('userid', user.id)
            .maybeSingle();
        print(userdata);
        if (userdata != null) {
          _username = userdata['username'];
          _userid = userdata['userid'];
          _profilepic = userdata['profile_pic'];
          setUserRole(userdata['role']);
        }
        // print(userid);
      }
    } catch (e) {
      print('no data fetch');
    }
    notifyListeners();
  }

  Future<void> getprofileimage(String userId, String username) async {
    final picker = ImagePicker();

    try {
      final pickedImage = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 10,
      );
      if (pickedImage != null) {
        _profilepicture = File(pickedImage.path);

        // Upload and get the public URL
        final imageUrl = await uploadProfilePic(
          userId,
          username,
          _profilepicture!,
        );

        if (imageUrl != null) {
          // Now update profile table
          await updateProfilePic(userId, imageUrl);
          notifyListeners();
        }
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<String?> uploadProfilePic(
    String userId,
    String username,
    File image,
  ) async {
    final supabase = Supabase.instance.client;

    final fileExt = image.path.split('.').last;
    //final time = DateTime.now().millisecondsSinceEpoch.toString();
    final fileName = '$userId.$fileExt';

    final path = 'uploads/$username/Profile/$fileName';

    try {
      // Make sure bucket name is correct (use one bucket, not mixed!)
      await supabase.storage
          .from('rentpost') // 👈 your bucket name
          .upload(path, image, fileOptions: FileOptions(upsert: true));

      final publicUrl = supabase.storage.from('rentpost').getPublicUrl(path);
      final updatedUrl =
          '$publicUrl?ts=${DateTime.now().millisecondsSinceEpoch}';

      return updatedUrl;
    } catch (e) {
      print('Upload failed: $e');
      return null;
    }
  }

  Future<void> updateProfilePic(String userId, String imageUrl) async {
    final supabase = Supabase.instance.client;

    await supabase
        .from('profile')
        .update({'profile_pic': imageUrl})
        .eq('userid', userId);
    fetchuser();
    notifyListeners();
    // fetchuser();
    // fetchPosts();
    //fetchbookedspace();
    // fetchmyPosts();
  }

  void setUserRole(String role) {
    _userrole = role;
    notifyListeners();
  }

  bool isAdmin() => _userrole == 'admin';
}
