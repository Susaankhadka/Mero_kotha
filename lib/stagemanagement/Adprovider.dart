import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../modelclass/modelclass.dart';

class AdProvider with ChangeNotifier {
  final List<Advertisements> _advertisement = [];
  List<Advertisements> get advertisement => _advertisement;

  Future<void> fetchAds(double defaultHight) async {
    try {
      final ads = await Supabase.instance.client
          .from('Advertisement_data')
          .select('photo_Url,hight')
          .order('id', ascending: false);

      if (ads != null && ads.isNotEmpty) {
        _advertisement.clear();

        for (var items in ads) {
          _advertisement.add(
            Advertisements(
              adImg: items['photo_Url'],
              hight: items['hight'] ?? defaultHight,
            ),
          );
        }
      }
    } catch (e) {
      print('Error fetching the ads :$e');
    }
    print('yyyyyy');
    notifyListeners();
  }
}
