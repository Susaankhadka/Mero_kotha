// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:mero_kotha/modelclass/modelclass.dart';

// import 'package:supabase_flutter/supabase_flutter.dart';

// class Pr with ChangeNotifier {
//   ScrollController scrollController = ScrollController();

//   Future<void> fetchAll(double adsHeight) async {
//     try {
//       await Future.wait([
//         fetchPosts(),
//         fetchuser(),
//         fetchsavePost(),
//         fetchAds(adsHeight),
//       ]);
//     } catch (e) {
//       debugPrint('Error fetching data: $e');
//     }
//   }

//   //top
//   void scrollToTop() {
//     scrollController.animateTo(
//       0,
//       duration: Duration(milliseconds: 500),
//       curve: Curves.easeInOut,
//     );
//   }

//   //bott
//   int selectedIndex = 0;

//   void setIndex(int index) {
//     if (selectedIndex == index) {
//       if (index == 0 || index == 1) {
//         scrollToTop();
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           fetchPosts();
//         });
//       }
//     } else {
//       selectedIndex = index;
//       notifyListeners();
//     }
//     notifyListeners();
//   }

//   bool _triger = true;
//   bool get triger => _triger;

//   void trigers(bool x) {
//     if (x == true) {
//       _triger = false;
//     } else {
//       _triger = true;
//     }
//     notifyListeners();
//   }

//   bool _editable = false;
//   bool get editable => _editable;

//   void iseditable(bool x) {
//     if (x == true) {
//       _editable = false;
//     } else {
//       _editable = true;
//     }
//     notifyListeners();
//   }

//   final List<Post> _postlist = [];
//   List<Post> get postlist => _postlist;
//   final List<Post> _mypostlist = [];
//   List<Post> get mypostlist => _mypostlist;
//   final List<BookedPost> _bookedlist = [];
//   List<BookedPost> get bookedlist => _bookedlist;
//   final List<BookedPost> _bookinglist = [];
//   List<BookedPost> get bookinglist => _bookinglist;
//   Profiledetails? profiledetails;
//   final List<File> _images = [];
//   List<File> get images => _images;

//   final List<File> _selectedimages = [];
//   List<File> get selectedimages => _selectedimages;
//   //top
//   String _username = "";
//   String get username => _username;
//   String _userid = "";
//   String get userid => _userid;
//   //bott
//   String _userrole = "";
//   String get userrole => _userrole;

//   File? _profilepicture;

//   String? selectedNationality;

//   String? selectedsex;

//   bool _isLoggingOut = false;
//   bool get isLoggingOut => _isLoggingOut;

//   set isLoggingOut(bool value) {
//     _isLoggingOut = value;
//     notifyListeners();
//   }

//   // void setdetail(String name, String photoUrl) {
//   //   _username = name;
//   //   _profilepic = photoUrl;
//   //   notifyListeners(); // update UI
//   // }
//   //top
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;
//   void setLoading(bool value) {
//     _isLoading = value;
//     notifyListeners();
//   }

//   //botto
//   final bool _isbookedmore = false;
//   bool get isbookedmore => _isbookedmore;

//   bool ismore() {
//     return bookedlist.length > 5 ? true : false;
//   }

//   //top
//   Future<void> getpost() async {
//     final picker = ImagePicker();
//     try {
//       final pickedimages = await picker.pickMultiImage(imageQuality: 20);
//       if (pickedimages.isEmpty) return;

//       _selectedimages.clear();
//       _selectedimages.addAll(pickedimages.map((x) => File(x.path)));

//       _images.addAll(_selectedimages);
//     } catch (e) {}
//     ;
//     notifyListeners();
//   }

//   //bott
//   //////start
//   Future<void> getprofileimage(String userId, String username) async {
//     final picker = ImagePicker();

//     try {
//       final pickedImage = await picker.pickImage(
//         source: ImageSource.gallery,
//         imageQuality: 10,
//       );
//       if (pickedImage != null) {
//         _profilepicture = File(pickedImage.path);

//         // Upload and get the public URL
//         final imageUrl = await uploadProfilePic(
//           userId,
//           username,
//           _profilepicture!,
//         );

//         if (imageUrl != null) {
//           // Now update profile table
//           await updateProfilePic(userId, imageUrl);
//         }
//       }
//     } catch (e) {
//       print("Error picking image: $e");
//     }
//     notifyListeners();
//   }

//   Future<String?> uploadProfilePic(
//     String userId,
//     String username,
//     File image,
//   ) async {
//     final supabase = Supabase.instance.client;

//     final fileExt = image.path.split('.').last;
//     //final time = DateTime.now().millisecondsSinceEpoch.toString();
//     final fileName = '$userId.$fileExt';

//     final path = 'uploads/$username/Profile/$fileName';

//     try {
//       // Make sure bucket name is correct (use one bucket, not mixed!)
//       await supabase.storage
//           .from('rentpost') // 👈 your bucket name
//           .upload(path, image, fileOptions: FileOptions(upsert: true));

//       final publicUrl = supabase.storage.from('rentpost').getPublicUrl(path);
//       final updatedUrl =
//           '$publicUrl?ts=${DateTime.now().millisecondsSinceEpoch}';

//       return updatedUrl;
//     } catch (e) {
//       print('Upload failed: $e');
//       return null;
//     }
//   }

//   Future<void> updateProfilePic(String userId, String imageUrl) async {
//     final supabase = Supabase.instance.client;

//     await supabase
//         .from('profile')
//         .update({'profile_pic': imageUrl})
//         .eq('userid', userId);

//     fetchuser();
//     fetchPosts();
//     fetchbookedspace();
//     fetchmyPosts();
//   }

//   void setUserRole(String role) {
//     _userrole = role;
//     notifyListeners();
//   }

//   //bottttttttt
//   bool isAdmin() => _userrole == 'admin';
//   //top
//   Future<void> addpost(
//     String caption,
//     int amount,
//     String owenernmae,
//     String owenerlocation,
//     String owenernumber,
//     String oweneremail,
//   ) async {
//     final supabase = Supabase.instance.client;
//     List<String> uploadedUrls = [];
//     List<String> uploadedPaths = [];

//     try {
//       notifyListeners();
//       _isLoading = true;
//       for (var img in _selectedimages) {
//         final filename = DateTime.now().millisecondsSinceEpoch.toString();
//         final path = 'uploads/$username/posts/$filename.jpg';

//         await supabase.storage.from('rentpost').upload(path, img);

//         final url = supabase.storage.from('rentpost').getPublicUrl(path);
//         uploadedUrls.add(url);
//         uploadedPaths.add(path);
//       }

//       await supabase.from('posts').insert({
//         'userid': userid,
//         'amount': amount,
//         'poster_name': owenernmae,
//         'oweneremail': oweneremail,
//         'caption': caption,
//         'owenerlocation': owenerlocation,
//         'owenernumber': owenernumber,
//         'image_urls': uploadedUrls,
//         'image_paths': uploadedPaths,
//         'is_sold': false,
//         'created_at': DateTime.now().toIso8601String(),
//       });
//     } catch (e) {
//     } finally {
//       _isLoading = false;
//     }

//     // Clear local selection after upload
//     _selectedimages.clear();
//     _images.clear();

//     // Fetch posts with URLs from DB and update _postlist
//     await fetchPosts();

//     notifyListeners();
//   }

//   //bott

//   // Future<void> fetchPosts() async {
//   //   try {
//   //     final response = await Supabase.instance.client
//   //         .from('posts')
//   //         .select('''
//   //   id, amount,is_saved,caption, created_at, image_urls, image_paths, userid,
//   //   poster_name, oweneremail, owenerlocation, owenernumber,
//   //   profile:userid (username, profile_pic)
//   // ''')
//   //         .order('created_at', ascending: false);

//   //     _postlist.clear();
//   //     for (var item in response) {
//   //       final profile = item['profile'] ?? {};
//   //       _postlist.add(
//   //         Post(
//   //           id: item['id'],
//   //           ammount: item['amount'],
//   //           postername: item['poster_name'],
//   //           userid: item['userid'],
//   //           username: profile['username'] ?? '',
//   //           profilepicurl: profile['profile_pic'] ?? '',
//   //           oweneremail: item['oweneremail'],
//   //           owenerlocation: item['owenerlocation'],
//   //           owenernumber: item['owenernumber'],
//   //           postimg: List<String>.from(item['image_urls'] ?? []),
//   //           imagePaths: List<String>.from(item['image_paths'] ?? []),
//   //           caption: item['caption'] ?? '',
//   //           issaved: item['is_saved'],
//   //           createdAt: DateTime.parse(item['created_at']),
//   //         ),
//   //       );
//   //     }

//   //     notifyListeners();
//   //   } catch (e) {
//   //     print("Error fetching user: $e");
//   //   }
//   // }
//   //////top
//   Future<void> fetchmyPosts() async {
//     final supabase = Supabase.instance.client;
//     try {
//       final response = await Supabase.instance.client
//           .from('posts')
//           .select('''
//           id, amount,is_sold,caption, created_at, image_urls, image_paths, userid,
//           poster_name, oweneremail, owenerlocation, owenernumber,
//            profile:userid (username, profile_pic)
//           ''')
//           .eq('userid', supabase.auth.currentUser!.id.toString())
//           .order('created_at', ascending: false);

//       _mypostlist.clear();
//       for (var item in response) {
//         final profile = item['profile'] ?? {};
//         _mypostlist.add(
//           Post(
//             id: item['id'],
//             ammount: item['amount'],
//             postername: item['poster_name'],
//             userid: item['userid'],
//             username: profile['username'] ?? '',
//             profilepicurl: profile['profile_pic'] ?? '',
//             oweneremail: item['oweneremail'],
//             owenerlocation: item['owenerlocation'],
//             owenernumber: item['owenernumber'],
//             postimg: List<String>.from(item['image_urls'] ?? []),
//             imagePaths: List<String>.from(item['image_paths'] ?? []),
//             caption: item['caption'] ?? '',
//             issold: item['is_sold'],
//             createdAt: DateTime.parse(item['created_at']),
//           ),
//         );
//       }

//       notifyListeners();
//     } catch (e) {
//       print("Error fetching user: $e");
//     }
//   }

//   ////bott
//   //////top
//   String _profilepic = "";
//   String get profilepic => _profilepic;
//   void clearprofilename() {
//     _profilepic = "";
//     notifyListeners();
//   }

//   ///bott
//   //top
//   Future<void> fetchuser() async {
//     final supabase = Supabase.instance.client;
//     final user = supabase.auth.currentUser;

//     try {
//       if (user != null) {
//         final userdata = await Supabase.instance.client
//             .from('profile')
//             .select('username,role,userid,profile_pic')
//             .eq('userid', user.id)
//             .maybeSingle();
//         print(userdata);
//         if (userdata != null) {
//           _username = userdata['username'];
//           _userid = userdata['userid'];
//           _profilepic = userdata['profile_pic'];
//           setUserRole(userdata['role']);
//         }
//         // print(userid);
//       }
//     } catch (e) {
//       print('no data fetch');
//     }
//     notifyListeners();
//   }

//   //bott
//   //top
//   Future<void> deletePost(Post post) async {
//     try {
//       final supabase = SupabaseClient(
//         'https://pozwkivluwprpmervieo.supabase.co',
//         'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBvendraXZsdXdwcnBtZXJ2aWVvIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1NDgwNzM3MiwiZXhwIjoyMDcwMzgzMzcyfQ.1jqy3Y5X2yVBLsrwMU8lhSKyYeO5uZiuGxUksPmJwy8', // full access
//       );

//       if (post.imagePaths.isNotEmpty) {
//         await supabase.storage.from('rentpost').remove(post.imagePaths);
//       }

//       await supabase.from('posts').delete().eq('id', post.id);

//       _postlist.removeWhere((p) => p.id == post.id);

//       notifyListeners();
//     } catch (e) {
//       'failed to delete';
//     }
//   }

//   //bot
//   ///top
//   Future<void> bookedspace(
//     Post post,
//     String bookername,
//     String location,
//     String bookernumber,
//     String bookeremail,
//     String? bookeroffer,
//   ) async {
//     try {
//       final supa = Supabase.instance.client;
//       final user = supa.auth.currentUser;
//       final supabase = SupabaseClient(
//         'https://pozwkivluwprpmervieo.supabase.co',
//         'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBvendraXZsdXdwcnBtZXJ2aWVvIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1NDgwNzM3MiwiZXhwIjoyMDcwMzgzMzcyfQ.1jqy3Y5X2yVBLsrwMU8lhSKyYeO5uZiuGxUksPmJwy8', // full access
//       );
//       await supabase.from('bookedspace').insert({
//         'offer_amount': bookeroffer != null && bookeroffer.isNotEmpty
//             ? int.parse(bookeroffer)
//             : 0,
//         'postid': post.id,
//         'owener_name': post.username,
//         'owener_id': post.userid,

//         'booker_name': bookername,
//         'booker_account': user!.email,

//         'booker_location': location,
//         'booker_gmail': bookeremail,
//         'booker_number': bookernumber,
//         'bookdate': DateTime.now().toIso8601String(),
//       });

//       notifyListeners();
//     } catch (e) {
//       print('failed to book$e');
//     }
//   }

//   //bottt
//   //top
//   Future<void> fetchbookedspace() async {
//     final supabase = Supabase.instance.client;
//     final user = supabase.auth.currentUser;
//     try {
//       final bookeddata = await Supabase.instance.client
//           .from('bookedspace')
//           .select('''
//       id,
//       booker_name,
//       booker_account,
//       booker_location,
//       booker_gmail,
//       booker_number,
//       owener_id,
//       bookdate,
//       offer_amount,
//       profile:owener_id(username,profile_pic),
//       posts:postid(
//         owenernumber,
//         owenerlocation,
//         oweneremail,
//         poster_name,
//         amount,
//         caption,
//         image_urls,created_at
        
//       )
//     ''')
//           .eq('owener_id', user!.id)
//           .order('bookdate', ascending: false);

//       if (bookeddata != null) {
//         _bookedlist.clear();
//         for (var item in bookeddata) {
//           final profile = item['profile'] ?? {};
//           final posts = item['posts'] ?? {};
//           _bookedlist.add(
//             BookedPost(
//               id: item['id'],
//               amount: posts['amount'],
//               offeramount: item['offer_amount'] ?? 0,
//               postername: posts['poster_name'],
//               oweneremail: posts['oweneremail'],
//               owenerlocation: posts['owenerlocation'],
//               owenernumber: posts['owenernumber'],
//               bookeraccount: item['booker_account'],
//               bookergmail: item['booker_gmail'],
//               bookerlocation: item['booker_location'],
//               ownername: profile['username'],
//               bookername: item['booker_name'],
//               postimg: List<String>.from(posts['image_urls'] ?? []),
//               bookernumber: item['booker_number'],
//               caption: posts['caption'],
//               profilrurl: profile['profile_pic'] ?? '',
//               bookdate: DateTime.parse(item['bookdate']),
//               createdAt: DateTime.parse(posts['created_at']),
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       print('No data fetch: $e');
//     }

//     notifyListeners();
//   }

//   //bott
//   //top
//   Future<void> fetchMybookedspace() async {
//     final supabase = Supabase.instance.client;
//     final user = supabase.auth.currentUser;
//     try {
//       final bookeddata = await Supabase.instance.client
//           .from('bookedspace')
//           .select('''
//       id,
//       booker_name,
//       booker_account,
//       booker_location,
//       booker_gmail,
//       booker_number,
//       owener_id,
//       bookdate,
//       offer_amount,
//       profile:owener_id(username,profile_pic),
//       posts:postid(
//         owenernumber,
//         owenerlocation,
//         oweneremail,
//         poster_name,
//         amount,
//         caption,
//         image_urls,
//       created_at
//       )
//     ''')
//           .eq('booker_account', user!.email.toString())
//           .order('bookdate', ascending: false);

//       if (bookeddata != null) {
//         _bookinglist.clear();
//         for (var item in bookeddata) {
//           final profile = item['profile'] ?? {};
//           final posts = item['posts'] ?? {};

//           _bookinglist.add(
//             BookedPost(
//               id: item['id'],

//               amount: posts['amount'],
//               offeramount: item['offer_amount'] ?? 0,
//               postername: posts['poster_name'],
//               oweneremail: posts['oweneremail'],
//               owenerlocation: posts['owenerlocation'],
//               owenernumber: posts['owenernumber'],
//               bookeraccount: item['booker_account'],
//               bookergmail: item['booker_gmail'],
//               bookerlocation: item['booker_location'],
//               ownername: profile['username'],
//               bookername: item['booker_name'],
//               postimg: List<String>.from(posts['image_urls'] ?? []),
//               bookernumber: item['booker_number'],
//               caption: posts['caption'],
//               profilrurl: profile['profile_pic'] ?? '',
//               bookdate: DateTime.parse(item['bookdate']),
//               createdAt: DateTime.parse(posts['created_at']),
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       print('No data fetch: $e');
//     }

//     notifyListeners();
//   }

//   //bott
//   //top
//   Future<void> deleteBookedpost(BookedPost post) async {
//     try {
//       final supabase = Supabase.instance.client;

//       await supabase.from('bookedspace').delete().eq('id', post.id);

//       _bookedlist.removeWhere((p) => p.id == post.id);

//       notifyListeners();
//     } catch (e) {
//       'failed to delete';
//     }
//   }

//   //bott
//   //top
//   Future<void> updateProfileInfo(
//     TextEditingController firstname,
//     TextEditingController lastname,
//     TextEditingController email,
//     TextEditingController age,
//     String sex,
//     String nationality,
//     TextEditingController phone,
//     TextEditingController location,
//   ) async {
//     try {
//       final supa = Supabase.instance.client;
//       final user = supa.auth.currentUser;
//       final existing = await supa
//           .from('profileDetails')
//           .select()
//           .eq('userid', user!.id);

//       if (existing.isEmpty) {
//         await supa.from('profileDetails').insert({
//           'userid': user.id,
//           'firstname': firstname.text,
//           'lastname': lastname.text,
//           'email_address': email.text,
//           'age': int.tryParse(age.text),
//           'sex': sex,
//           'Nationality': nationality,
//           'phonenumber': int.tryParse(phone.text),
//           'location': location.text,
//         });
//       } else {
//         await supa
//             .from('profileDetails')
//             .update({
//               'firstname': firstname.text,
//               'lastname': lastname.text,
//               'email_address': email.text,
//               'age': int.tryParse(age.text),
//               'sex': sex,
//               'Nationality': nationality,
//               'phonenumber': int.tryParse(phone.text),
//               'location': location.text,
//             })
//             .eq('userid', user.id);
//       }
//     } catch (e) {
//       print('Failed to update profile: $e');
//     }
//     await fetchprofileinfo();
//   }

//   //bott
//   //top
//   Future<void> fetchprofileinfo() async {
//     final supabase = Supabase.instance.client;
//     final user = supabase.auth.currentUser;
//     try {
//       final userprofiledata = await Supabase.instance.client
//           .from('profileDetails')
//           .select()
//           .eq('userid', user!.id);

//       if (userprofiledata != null && userprofiledata.isNotEmpty) {
//         for (var item in userprofiledata) {
//           profiledetails = Profiledetails(
//             id: item['id'],
//             age: item['age'] != null ? int.tryParse(item['age'].toString()) : 0,
//             email: item['email_address'] ?? '',
//             firstname: item['firstname'] ?? '',
//             lastname: item['lastname'] ?? '',
//             sex: item['sex'] ?? '',
//             location: item['location'] ?? '',
//             nationality: item['Nationality'] ?? '',
//             number: item['phonenumber'] != null
//                 ? int.tryParse(item['phonenumber'].toString())
//                 : 0,
//           );
//         }
//       }
//     } catch (e) {
//       print('No data fetch: $e');
//     }

//     notifyListeners();
//   }

//   //bott
//   final List<Advertisements> _advertisement = [];
//   List<Advertisements> get advertisement => _advertisement;
//   //top
//   Future<void> fetchAds(double defaultHight) async {
//     try {
//       final ads = await Supabase.instance.client
//           .from('Advertisement_data')
//           .select('photo_Url,hight');

//       if (ads != null && ads.isNotEmpty) {
//         _advertisement.clear();

//         for (var items in ads) {
//           _advertisement.add(
//             Advertisements(
//               adImg: items['photo_Url'],
//               hight: items['hight'] ?? defaultHight,
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       print('Error fetching the ads :$e');
//     }
//     print('yyyyyy');
//     notifyListeners();
//   }

//   //bott
//   //top
//   Future<bool> issaved(Post post) async {
//     final supabase = Supabase.instance.client;
//     final user = supabase.auth.currentUser;
//     final existing = await supabase
//         .from('savedpost')
//         .select()
//         .eq('userid', user!.id)
//         .eq('postid', post.id)
//         .order('created_at')
//         .maybeSingle();
//     if (existing!['is_saved'] == null || existing['is_saved'] == false) {
//       return false;
//     } else {
//       return true;
//     }
//   }

//   //bott
//   //top
//   Future<String> favouritePost(Post posts) async {
//     // bool? issaved;

//     // void isSaved(bool x) {
//     //   if (x == false) {
//     //     issaved = true;
//     //   } else {
//     //     issaved = false;
//     //   }
//     //   notifyListeners();
//     // }

//     // isSaved(post);
//     try {
//       final supa = Supabase.instance.client;
//       final user = supa.auth.currentUser;

//       //   final existing = await supabase
//       //       .from('savedpost')
//       //       .update({'is_saved': issaved})
//       //       .eq('id', post.id);
//       final existing = await supa
//           .from('savedpost')
//           .select()
//           .eq('userid', user!.id)
//           .eq('postid', posts.id)
//           .order('created_at')
//           .maybeSingle();

//       if (existing == null) {
//         await supa.from('savedpost').insert({
//           'postid': posts.id,
//           'postowenerid': posts.userid,
//           'userid': user.id,
//           'is_saved': 'true',
//           'created_at': DateTime.now().toIso8601String(),
//         });
//         posts.issaved = true;
//         notifyListeners();
//         fetchsavePost();

//         return 'saved';
//       } else {
//         await supa
//             .from('savedpost')
//             .delete()
//             .eq('userid', user.id)
//             .eq('postid', posts.id);
//         posts.issaved = false;
//         notifyListeners();
//         fetchsavePost();
//         return 'unsaved';
//       }
//     } catch (e) {
//       return 'something wrong';
//     }
//   }

//   //bott
//   ///top
//   Future<void> fetchPosts() async {
//     try {
//       final supabase = Supabase.instance.client;
//       final user = supabase.auth.currentUser;
//       if (user == null) return;

//       final response = await supabase
//           .from('posts')
//           .select('''
//           id, amount,is_sold,caption, created_at, image_urls, image_paths, userid,
//           poster_name, oweneremail, owenerlocation, owenernumber,
//           profile:userid (username, profile_pic),
//           savedpost!left(userid)   -- bring in related savedpost rows
//         ''')
//           .order('created_at', ascending: false);

//       _postlist.clear();

//       for (var item in response) {
//         final profile = item['profile'] ?? {};
//         final saved = item['savedpost'] ?? [];
//         final isSaved = saved.any((s) => s['userid'] == user.id);

//         _postlist.add(
//           Post(
//             id: item['id'],
//             ammount: item['amount'],
//             postername: item['poster_name'],
//             userid: item['userid'],
//             username: profile['username'] ?? '',
//             profilepicurl: profile['profile_pic'] ?? '',
//             oweneremail: item['oweneremail'],
//             owenerlocation: item['owenerlocation'],
//             owenernumber: item['owenernumber'],
//             postimg: List<String>.from(item['image_urls'] ?? []),
//             imagePaths: List<String>.from(item['image_paths'] ?? []),
//             caption: item['caption'] ?? '',
//             issaved: isSaved,
//             issold: item['is_sold'],
//             createdAt: DateTime.parse(item['created_at']),
//           ),
//         );
//       }

//       notifyListeners();
//     } catch (e) {
//       print("Error fetching posts: $e");
//     }
//   }

//   //BOTTOMDONE
//   //top
//   Future<void> soldPost(Post post) async {
//     try {
//       final supabase = Supabase.instance.client;

//       final existing = await supabase
//           .from('posts')
//           .select()
//           .eq('userid', post.userid)
//           .eq('id', post.id)
//           .maybeSingle();

//       if (existing!['is_sold'] == false) {
//         await supabase
//             .from('posts')
//             .update({'is_sold': true})
//             .eq('userid', post.userid)
//             .eq('id', post.id);
//       } else if (existing['is_sold'] == true) {
//         await supabase
//             .from('posts')
//             .update({'is_sold': false})
//             .eq('userid', post.userid)
//             .eq('id', post.id);
//       } else {}
//     } catch (e) {
//       print('failed $e');
//     }
//   }

//   //bott
//   final List<Post> _savepost = [];
//   List<Post> get savepost => _savepost;
//   //top
//   Future<void> fetchsavePost() async {
//     try {
//       final supabase = Supabase.instance.client;

//       final user = supabase.auth.currentUser;
//       final existing = await supabase
//           .from('savedpost')
//           .select('''
//       userid,is_saved,
//       posts:postid (
//         id,
//         amount,
//         is_sold,
//         caption,
//         created_at,
//         image_urls,
//         image_paths,
//         userid,
//         poster_name,
//         oweneremail,
//         owenerlocation,
//         owenernumber,
//         profile:userid (
//           username,
//           profile_pic
//         )
//       )
//     ''')
//           .eq('userid', user!.id);
//       _savepost.clear();
//       for (var items in existing) {
//         final posts = items['posts'] ?? {};
//         final profile = posts['profile'] ?? {};
//         final isSaved = true;
//         _savepost.add(
//           Post(
//             id: posts['id'],
//             ammount: posts['amount'],
//             postername: posts['poster_name'],
//             userid: posts['userid'],
//             username: profile['username'] ?? '',
//             profilepicurl: profile['profile_pic'] ?? '',
//             oweneremail: posts['oweneremail'],
//             owenerlocation: posts['owenerlocation'],
//             owenernumber: posts['owenernumber'],
//             postimg: List<String>.from(posts['image_urls'] ?? []),
//             imagePaths: List<String>.from(posts['image_paths'] ?? []),
//             caption: posts['caption'] ?? '',
//             issaved: isSaved,
//             issold: posts['is_sold'],
//             createdAt: DateTime.parse(posts['created_at']),
//           ),
//         );
//       }
//     } catch (e) {
//       print('failed $e');
//     }
//   }

//   //bott
// }



// //   Future<void> fetchfavouritePost(Post post) async {
// //     bool? issaved;

// //     void isSaved(Post post) {
// //       if (post.issaved == false) {
// //         issaved = true;
// //       } else {
// //         issaved = false;
// //       }
// //       notifyListeners();
// //     }

// //     isSaved(post);
// //     try {
// //       final supa = Supabase.instance.client;
// //       final user = supa.auth.currentUser;
// //      

// //       final existing = await supabase
// //           .from('savedpost')
// //           .select()
// //           .eq('userid', userid)
// //           .eq('postid', post.id)
// //           .order('created_at');

// //       _favouritepost.clear();
// //       for (var items in existing) {
// //         _favouritepost.add(Savedpost(issaved: items['is_saved'] ?? false));
// //       }

// //       notifyListeners();
// //       print(issaved);
// //       print('malaoooo');
// //     } catch (e) {
// //       print('failed to saved$e');
// //     }
// //   }
// // }


// // async {
// //   final supabase = Supabase.instance.client;

// //   final existing = await supabase.from('posts').select().eq('userid', userid).eq('postid', post.id);

// //   if (existing['is_sold']==null) {
// //     await supabase.from('posts').insert({
// //        'is_sold': true,

// //         
// //     });
// //   } else if(existing['is_sold']==true){
// //     await supabase
// //         .from('savedpost')
// //         .update({'is_sold':false})
// //         .eq('userid', userid).eq('postid', post.id);
// //   }else{await supabase
// //         .from('savedpost')
// //         .update({'is_sold':false})
// //         .eq('userid', userid).eq('postid', post.id);}
// // }