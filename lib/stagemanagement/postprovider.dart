import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../modelclass/modelclass.dart';

class PostProvider with ChangeNotifier {
  final List<Post> _postlist = [];
  List<Post> get postlist => _postlist;

  List<Post> _mypostlist = [];
  List<Post> get mypostlist => _mypostlist;

  final List<Post> _savepost = [];
  List<Post> get savepost => _savepost;

  final List<File> _images = []; // temp local images for post upload
  List<File> get images => _images;
  final List<File> _selectedimages = [];
  List<File> get selectedimages => _selectedimages;

  final String _username = "";
  String get username => _username;
  final String _userid = "";
  String get userid => _userid;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  // ScrollController scrollController = ScrollController();

  Future<void> fetchPosts() async {
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;
      if (user == null) return;

      final response = await supabase
          .from('posts')
          .select('''
          id, amount,is_sold,caption, created_at, image_urls, image_paths, userid,
          poster_name, oweneremail, owenerlocation, owenernumber,
          profile:userid (username, profile_pic),
          savedpost!left(userid)  
        ''')
          .order('created_at', ascending: false);

      _postlist.clear();

      for (var item in response) {
        final profile = item['profile'] ?? {};
        final saved = item['savedpost'] ?? [];
        final isSaved = saved.any((s) => s['userid'] == user.id);

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
            issaved: isSaved,
            issold: item['is_sold'],
            createdAt: DateTime.parse(item['created_at']),
          ),
        );
      }

      notifyListeners();
    } catch (e) {
      print("Error fetching posts: $e");
    }
  }

  Future<void> fetchmyPosts() async {
    final supabase = Supabase.instance.client;
    try {
      final response = await Supabase.instance.client
          .from('posts')
          .select('''
          id, amount,is_sold,caption, created_at, image_urls, image_paths, userid,
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
            issold: item['is_sold'],
            createdAt: DateTime.parse(item['created_at']),
          ),
        );
      }

      notifyListeners();
    } catch (e) {
      print("Error fetching user: $e");
    }
  }

  Future<void> deletePost(Post post) async {
    try {
      final supabase = SupabaseClient(
        'https://pozwkivluwprpmervieo.supabase.co',
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBvendraXZsdXdwcnBtZXJ2aWVvIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1NDgwNzM3MiwiZXhwIjoyMDcwMzgzMzcyfQ.1jqy3Y5X2yVBLsrwMU8lhSKyYeO5uZiuGxUksPmJwy8', // full access
      );

      if (post.imagePaths.isNotEmpty) {
        await supabase.storage.from('rentpost').remove(post.imagePaths);
      }

      await supabase.from('posts').delete().eq('id', post.id);

      _postlist.removeWhere((p) => p.id == post.id);

      notifyListeners();
    } catch (e) {
      'failed to delete';
    }
    fetchsavePost();
    fetchPosts();
    notifyListeners();
  }

  Future<String> favouritePost(Post posts) async {
    // bool? issaved;

    // void isSaved(bool x) {
    //   if (x == false) {
    //     issaved = true;
    //   } else {
    //     issaved = false;
    //   }
    //   notifyListeners();
    // }

    // isSaved(post);
    try {
      final supa = Supabase.instance.client;
      final user = supa.auth.currentUser;

      //   final existing = await supabase
      //       .from('savedpost')
      //       .update({'is_saved': issaved})
      //       .eq('id', post.id);
      final existing = await supa
          .from('savedpost')
          .select()
          .eq('userid', user!.id)
          .eq('postid', posts.id)
          .order('created_at')
          .maybeSingle();

      if (existing == null) {
        await supa.from('savedpost').insert({
          'postid': posts.id,
          'postowenerid': posts.userid,
          'userid': user.id,
          'is_saved': 'true',
          'created_at': DateTime.now().toIso8601String(),
        });
        posts.issaved = true;
        await fetchsavePost();
        notifyListeners();

        return 'saved';
      } else {
        await supa
            .from('savedpost')
            .delete()
            .eq('userid', user.id)
            .eq('postid', posts.id);
        posts.issaved = false;

        await fetchsavePost();
        notifyListeners();

        return 'unsaved';
      }
    } catch (e) {
      return 'something wrong';
    }
  }

  Future<void> soldPost(Post post) async {
    try {
      final supabase = Supabase.instance.client;

      final existing = await supabase
          .from('posts')
          .select()
          .eq('userid', post.userid)
          .eq('id', post.id)
          .maybeSingle();

      if (existing!['is_sold'] == false) {
        await supabase
            .from('posts')
            .update({'is_sold': true})
            .eq('userid', post.userid)
            .eq('id', post.id);
        notifyListeners();
      } else if (existing['is_sold'] == true) {
        await supabase
            .from('posts')
            .update({'is_sold': false})
            .eq('userid', post.userid)
            .eq('id', post.id);
        notifyListeners();
      } else {}
    } catch (e) {
      print('failed $e');
    }
    fetchPosts();
    notifyListeners();
  }

  Future<void> fetchsavePost() async {
    try {
      final supabase = Supabase.instance.client;

      final user = supabase.auth.currentUser;
      final existing = await supabase
          .from('savedpost')
          .select('''
      userid,is_saved,
      posts:postid (
        id,
        amount,
        is_sold,
        caption,
        created_at,
        image_urls,
        image_paths,
        userid,
        poster_name,
        oweneremail,
        owenerlocation,
        owenernumber,
        profile:userid (
          username,
          profile_pic
        )
      )
    ''')
          .eq('userid', user!.id);
      _savepost.clear();
      for (var items in existing) {
        final posts = items['posts'] ?? {};
        final profile = posts['profile'] ?? {};
        final isSaved = true;
        _savepost.add(
          Post(
            id: posts['id'],
            ammount: posts['amount'],
            postername: posts['poster_name'],
            userid: posts['userid'],
            username: profile['username'] ?? '',
            profilepicurl: profile['profile_pic'] ?? '',
            oweneremail: posts['oweneremail'],
            owenerlocation: posts['owenerlocation'],
            owenernumber: posts['owenernumber'],
            postimg: List<String>.from(posts['image_urls'] ?? []),
            imagePaths: List<String>.from(posts['image_paths'] ?? []),
            caption: posts['caption'] ?? '',
            issaved: isSaved,
            issold: posts['is_sold'],
            createdAt: DateTime.parse(posts['created_at']),
          ),
        );
      }
      notifyListeners();
    } catch (e) {
      print('failed $e');
    }
  }

  Future<bool> issaved(Post post) async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;
    final existing = await supabase
        .from('savedpost')
        .select()
        .eq('userid', user!.id)
        .eq('postid', post.id)
        .order('created_at')
        .maybeSingle();
    if (existing!['is_saved'] == null || existing['is_saved'] == false) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> addpost(
    String caption,
    int amount,
    String owenernmae,
    String owenerlocation,
    String owenernumber,
    String oweneremail,
  ) async {
    final supabase = Supabase.instance.client;
    List<String> uploadedUrls = [];
    List<String> uploadedPaths = [];

    try {
      _isLoading = true;
      notifyListeners();
      for (var img in _selectedimages) {
        final filename = DateTime.now().millisecondsSinceEpoch.toString();
        final path = 'uploads/$username/posts/$filename.jpg';

        await supabase.storage.from('rentpost').upload(path, img);

        final url = supabase.storage.from('rentpost').getPublicUrl(path);
        uploadedUrls.add(url);
        uploadedPaths.add(path);
      }

      await supabase.from('posts').insert({
        'userid': supabase.auth.currentUser!.id,
        'amount': amount,
        'poster_name': owenernmae,
        'oweneremail': oweneremail,
        'caption': caption,
        'owenerlocation': owenerlocation,
        'owenernumber': owenernumber,
        'image_urls': uploadedUrls,
        'image_paths': uploadedPaths,
        'is_sold': false,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print(e);
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

  Future<void> getpost() async {
    final picker = ImagePicker();
    try {
      final pickedimages = await picker.pickMultiImage(imageQuality: 20);
      if (pickedimages.isEmpty) return;

      _selectedimages.clear();
      _selectedimages.addAll(pickedimages.map((x) => File(x.path)));

      _images.addAll(_selectedimages);
      notifyListeners();
    } catch (e) {}
  }
}
