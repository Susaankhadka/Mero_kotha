import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mero_kotha/modelclass/modelclass.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class Providerr with ChangeNotifier {
  ScrollController scrollController = ScrollController();

  void scrollToTop() {
    scrollController.animateTo(
      0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  int selectedIndex = 0;

  void setIndex(int index) {
    if (selectedIndex == index) {
      // 👇 same "re-tap" logic
      if (index == 0 || index == 1) {
        scrollToTop();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          fetchPosts();
        });
      }
    } else {
      selectedIndex = index;
      notifyListeners();
    }
    notifyListeners();
  }

  final List<Post> _postlist = [];
  List<Post> get postlist => _postlist;
  final List<Post> _mypostlist = [];
  List<Post> get mypostlist => _mypostlist;
  final List<BookedPost> _bookedlist = [];
  List<BookedPost> get bookedlist => _bookedlist;
  final List<BookedPost> _bookinglist = [];
  List<BookedPost> get bookinglist => _bookinglist;

  final List<File> _images = [];
  List<File> get images => _images;

  final List<File> _selectedimages = [];
  List<File> get selectedimages => _selectedimages;

  String _username = "";
  String get username => _username;
  String _userid = "";
  String get userid => _userid;

  String _userrole = "";
  String get userrole => _userrole;

  File? _profilepicture;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  final bool _isbookedmore = false;
  bool get isbookedmore => _isbookedmore;

  bool ismore() {
    return bookedlist.length > 5 ? true : false;
  }

  Future<void> getpost() async {
    final picker = ImagePicker();
    try {
      final pickedimages = await picker.pickMultiImage(imageQuality: 20);
      if (pickedimages.isEmpty) return;

      _selectedimages.clear();
      _selectedimages.addAll(pickedimages.map((x) => File(x.path)));

      _images.addAll(_selectedimages);
    } catch (e) {}
    ;
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
        }
      }
    } catch (e) {
      print("Error picking image: $e");
    }
    notifyListeners();
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
    fetchPosts();
    fetchbookedspace();
    fetchmyPosts();
  }

  void setUserRole(String role) {
    _userrole = role;
    notifyListeners(); // ⚡ This tells UI to rebuild
  }

  bool isAdmin() => _userrole == 'admin';

  Future<void> addpost(
    String caption,
    int amount,
    String owenernmae,
    String owenerlocation,
    String owenernumber,
    String oweneremail,
  ) async {
    // Upload all selected images and save posts in DB
    // await createPost(caption);
    final supabase = Supabase.instance.client;
    List<String> uploadedUrls = [];
    List<String> uploadedPaths = [];

    try {
      notifyListeners();
      _isLoading = true;
      for (var img in _selectedimages) {
        final filename = DateTime.now().millisecondsSinceEpoch.toString();
        final path = 'uploads/$username/posts/$filename.jpg';

        await supabase.storage.from('rentpost').upload(path, img);

        final url = supabase.storage.from('rentpost').getPublicUrl(path);
        uploadedUrls.add(url);
        uploadedPaths.add(path);
      }

      // Insert one post with image_urls as array
      await supabase.from('posts').insert({
        'userid': userid,
        'amount': amount,

        'poster_name': owenernmae,
        'oweneremail': oweneremail,
        'caption': caption,
        'owenerlocation': owenerlocation,
        'owenernumber': owenernumber,
        'image_urls': uploadedUrls,
        'image_paths': uploadedPaths, // store paths too
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
    } finally {
      _isLoading = false;
    }

    // Clear local selection after upload
    _selectedimages.clear();
    _images.clear();

    // Fetch posts with URLs from DB and update _postlist
    await fetchPosts();

    notifyListeners();
  }

  Future<void> fetchPosts() async {
    try {
      final response = await Supabase.instance.client
          .from('posts')
          .select('''
    id, amount, caption, created_at, image_urls, image_paths, userid,
    poster_name, oweneremail, owenerlocation, owenernumber,
    profile:userid (username, profile_pic)
  ''')
          .order('created_at', ascending: false);

      _postlist.clear();
      for (var item in response) {
        final profile = item['profile'] ?? {};
        _postlist.add(
          Post(
            id: item['id'],
            ammount: item['amount'],
            postername: item['poster_name'],
            userid: item['userid'],
            username: profile['username'] ?? '',
            profilepicurl: profile['profile_pic'] ?? '',
            oweneremail: item['oweneremail'],
            owenerlocation: item['owenerlocation'],
            owenernumber: item['owenernumber'],
            postimg: List<String>.from(item['image_urls'] ?? []),
            imagePaths: List<String>.from(item['image_paths'] ?? []),
            caption: item['caption'] ?? '',
            createdAt: DateTime.parse(item['created_at']),
          ),
        );
      }

      notifyListeners();
    } catch (e) {
      print("Error fetching user: $e");
    }
  }

  Future<void> fetchmyPosts() async {
    final supabase = Supabase.instance.client;
    try {
      final response = await Supabase.instance.client
          .from('posts')
          .select('''
          id, amount, caption, created_at, image_urls, image_paths, userid,
          poster_name, oweneremail, owenerlocation, owenernumber,
           profile:userid (username, profile_pic)
          ''')
          .eq('userid', supabase.auth.currentUser!.id.toString())
          .order('created_at', ascending: false);

      _mypostlist.clear();
      for (var item in response) {
        final profile = item['profile'] ?? {};
        _mypostlist.add(
          Post(
            id: item['id'],
            ammount: item['amount'],
            postername: item['poster_name'],
            userid: item['userid'],
            username: profile['username'] ?? '',
            profilepicurl: profile['profile_pic'] ?? '',
            oweneremail: item['oweneremail'],
            owenerlocation: item['owenerlocation'],
            owenernumber: item['owenernumber'],
            postimg: List<String>.from(item['image_urls'] ?? []),
            imagePaths: List<String>.from(item['image_paths'] ?? []),
            caption: item['caption'] ?? '',
            createdAt: DateTime.parse(item['created_at']),
          ),
        );
      }

      notifyListeners();
    } catch (e) {
      print("Error fetching user: $e");
    }
  }

  String _profilepic = "";
  String get profilepic => _profilepic;
  void clearprofilename() {
    _profilepic = "";
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
            .eq('userid', user.id) // use Firebase UID here
            .maybeSingle();

        if (userdata != null) {
          _username = userdata['username'];
          _userid = userdata['userid'];
          _profilepic = userdata['profile_pic'];
          setUserRole(userdata['role']);
        }
      }
    } catch (e) {
      print('no data fetch');
    }
    notifyListeners();
  }

  Future<void> deletePost(Post post) async {
    try {
      final supabase = SupabaseClient(
        'https://pozwkivluwprpmervieo.supabase.co',
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBvendraXZsdXdwcnBtZXJ2aWVvIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1NDgwNzM3MiwiZXhwIjoyMDcwMzgzMzcyfQ.1jqy3Y5X2yVBLsrwMU8lhSKyYeO5uZiuGxUksPmJwy8', // full access
      );

      // 1. Delete images from storage
      if (post.imagePaths.isNotEmpty) {
        await supabase.storage.from('rentpost').remove(post.imagePaths);
      }

      // 2. Delete post row from table
      await supabase.from('posts').delete().eq('id', post.id);

      // 3. Remove locally
      _postlist.removeWhere((p) => p.id == post.id);

      notifyListeners();
    } catch (e) {
      'failed to delete';
    }
  }

  Future<void> bookedspace(
    Post post,
    String bookername,
    String location,
    String bookernumber,
    String bookeremail,
  ) async {
    try {
      final supa = Supabase.instance.client;
      final user = supa.auth.currentUser;
      final supabase = SupabaseClient(
        'https://pozwkivluwprpmervieo.supabase.co',
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBvendraXZsdXdwcnBtZXJ2aWVvIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1NDgwNzM3MiwiZXhwIjoyMDcwMzgzMzcyfQ.1jqy3Y5X2yVBLsrwMU8lhSKyYeO5uZiuGxUksPmJwy8', // full access
      );
      await supabase.from('bookedspace').insert({
        'postid': post.id,
        'owener_name': post.username,
        'owener_id': post.userid,

        'booker_name': bookername,
        'booker_account': user!.email,

        'booker_location': location,
        'booker_gmail': bookeremail,
        'booker_number': bookernumber,
      });

      notifyListeners();
    } catch (e) {
      print('failed to book$e');
    }
    fetchbookedspace();
  }

  Future<void> fetchbookedspace() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    try {
      final bookeddata = await Supabase.instance.client
          .from('bookedspace')
          .select('''
      id,
      booker_name,
      booker_account,
      booker_location,
      booker_gmail,
      booker_number,
      owener_id,
      profile:owener_id(username,profile_pic),
      posts:postid(
        owenernumber,
        owenerlocation,
        oweneremail,
        poster_name,
        amount,
        caption,
        image_urls,
        created_at
      )
    ''')
          .eq('owener_id', user!.id)
          .order('id', ascending: false);

      if (bookeddata != null) {
        _bookedlist.clear();
        for (var item in bookeddata) {
          final profile = item['profile'] ?? {};
          final posts = item['posts'] ?? {};
          _bookedlist.add(
            BookedPost(
              id: item['id'],
              amount: posts['amount'],
              postername: posts['poster_name'],
              oweneremail: posts['oweneremail'],
              owenerlocation: posts['owenerlocation'],
              owenernumber: posts['owenernumber'],
              bookeraccount: item['booker_account'],
              bookergmail: item['booker_gmail'],
              bookerlocation: item['booker_location'],
              ownername: profile['username'],
              bookername: item['booker_name'],
              postimg: List<String>.from(posts['image_urls'] ?? []),
              bookernumber: item['booker_number'],
              caption: posts['caption'],
              profilrurl: profile['profile_pic'] ?? '',
              createdAt: DateTime.parse(posts['created_at']),
            ),
          );
        }
      }
    } catch (e) {
      print('No data fetch: $e');
    }

    notifyListeners();
  }

  Future<void> fetchMybookedspace() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    try {
      final bookeddata = await Supabase.instance.client
          .from('bookedspace')
          .select('''
      id,
      booker_name,
      booker_account,
      booker_location,
      booker_gmail,
      booker_number,
      owener_id,
      profile:owener_id(username,profile_pic),
      posts:postid(
        owenernumber,
        owenerlocation,
        oweneremail,
        poster_name,
        amount,
        caption,
        image_urls,
        created_at
      )
    ''')
          .eq('booker_account', user!.email.toString())
          .order('id', ascending: false);

      if (bookeddata != null) {
        _bookinglist.clear();
        for (var item in bookeddata) {
          final profile = item['profile'] ?? {};
          final posts = item['posts'] ?? {};
          _bookinglist.add(
            BookedPost(
              id: item['id'],
              amount: posts['amount'],
              postername: posts['poster_name'],
              oweneremail: posts['oweneremail'],
              owenerlocation: posts['owenerlocation'],
              owenernumber: posts['owenernumber'],
              bookeraccount: item['booker_account'],
              bookergmail: item['booker_gmail'],
              bookerlocation: item['booker_location'],
              ownername: profile['username'],
              bookername: item['booker_name'],
              postimg: List<String>.from(posts['image_urls'] ?? []),
              bookernumber: item['booker_number'],
              caption: posts['caption'],
              profilrurl: profile['profile_pic'] ?? '',
              createdAt: DateTime.parse(posts['created_at']),
            ),
          );
        }
      }
    } catch (e) {
      print('No data fetch: $e');
    }

    notifyListeners();
  }

  Future<void> deleteBookedpost(BookedPost post) async {
    try {
      final supabase = SupabaseClient(
        'https://pozwkivluwprpmervieo.supabase.co',
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBvendraXZsdXdwcnBtZXJ2aWVvIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1NDgwNzM3MiwiZXhwIjoyMDcwMzgzMzcyfQ.1jqy3Y5X2yVBLsrwMU8lhSKyYeO5uZiuGxUksPmJwy8', // full access
      );

      // 1. Delete images from storage

      // 2. Delete post row from table
      await supabase.from('bookedspace').delete().eq('id', post.id);
      final check = await supabase
          .from('bookedspace')
          .select()
          .eq('id', post.id);
      print(check);

      // 3. Remove locally
      _bookedlist.removeWhere((p) => p.id == post.id);

      notifyListeners();
    } catch (e) {
      'failed to delete';
    }
  }
}
