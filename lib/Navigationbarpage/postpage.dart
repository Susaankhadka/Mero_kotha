import 'package:flutter/material.dart';
import 'package:mero_kotha/modelclass/modelclass.dart';
import 'package:mero_kotha/stagemanagement/postprovider.dart';
import 'package:provider/provider.dart';

class Postpage extends StatelessWidget {
  const Postpage({super.key});

  @override
  Widget build(BuildContext context) {
    print('postpage');
    return Scaffold(
      appBar: AppBar(title: Text('Recent post')),
      body: Consumer<PostProvider>(
        builder: (context, providerr, child) {
          return AllRecentPost(
            postcount: providerr.postlist.length,
            postlist: providerr.postlist,
          );
        },
      ),
    );
  }
}
