import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../modelclass/modelclass.dart';

class BookingProvider with ChangeNotifier {
  List<BookedPost> _bookedlist = [];
  List<BookedPost> get bookedlist => _bookedlist;

  List<BookedPost> _bookinglist = [];
  List<BookedPost> get bookinglist => _bookinglist;

  final bool _isbookedmore = false;
  bool get isbookedmore => _isbookedmore;
  bool ismore() {
    return bookedlist.length > 5 ? true : false;
  }

  Future<void> bookedspace(
    Post post,
    String bookername,
    String location,
    String bookernumber,
    String bookeremail,
    String? bookeroffer,
  ) async {
    try {
      final supa = Supabase.instance.client;
      final user = supa.auth.currentUser;
      final supabase = SupabaseClient(
        'https://pozwkivluwprpmervieo.supabase.co',
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBvendraXZsdXdwcnBtZXJ2aWVvIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1NDgwNzM3MiwiZXhwIjoyMDcwMzgzMzcyfQ.1jqy3Y5X2yVBLsrwMU8lhSKyYeO5uZiuGxUksPmJwy8', // full access
      );
      await supabase.from('bookedspace').insert({
        'offer_amount': bookeroffer != null && bookeroffer.isNotEmpty
            ? int.parse(bookeroffer)
            : 0,
        'postid': post.id,
        'owener_name': post.username,
        'owener_id': post.userid,

        'booker_name': bookername,
        'booker_account': user!.email,

        'booker_location': location,
        'booker_gmail': bookeremail,
        'booker_number': bookernumber,
        'bookdate': DateTime.now().toIso8601String(),
      });

      notifyListeners();
    } catch (e) {
      print('failed to book$e');
    }
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
      bookdate,
      offer_amount,
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
          .order('bookdate', ascending: false);

      if (bookeddata != null) {
        _bookedlist.clear();
        for (var item in bookeddata) {
          final profile = item['profile'] ?? {};
          final posts = item['posts'] ?? {};

          _bookedlist.add(
            BookedPost(
              id: item['id'],

              amount: posts['amount'],
              offeramount: item['offer_amount'] ?? 0,
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
              bookdate: DateTime.parse(item['bookdate']),
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
      bookdate,
      offer_amount,
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
          .order('bookdate', ascending: false);

      if (bookeddata != null) {
        _bookinglist.clear();
        for (var item in bookeddata) {
          final profile = item['profile'] ?? {};
          final posts = item['posts'] ?? {};

          _bookinglist.add(
            BookedPost(
              id: item['id'],

              amount: posts['amount'],
              offeramount: item['offer_amount'] ?? 0,
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
              bookdate: DateTime.parse(item['bookdate']),
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
      final supabase = Supabase.instance.client;

      await supabase.from('bookedspace').delete().eq('id', post.id);

      _bookedlist.removeWhere((p) => p.id == post.id);

      notifyListeners();
    } catch (e) {
      'failed to delete';
    }
  }
}
