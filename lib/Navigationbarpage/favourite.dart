import 'package:flutter/material.dart';
import 'package:mero_kotha/modelclass/modelclass.dart';
import 'package:mero_kotha/stagemanagement/postprovider.dart';
import 'package:provider/provider.dart';

class FavouritePost extends StatefulWidget {
  const FavouritePost({super.key});

  @override
  State<FavouritePost> createState() => _FavouritePostState();
}

class _FavouritePostState extends State<FavouritePost> {
  final Map<int, ValueNotifier<int>> pageIndexes = {};

  @override
  void dispose() {
    for (final notifier in pageIndexes.values) {
      notifier.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Recent post')),
      body: Consumer<PostProvider>(
        builder: (context, value, child) {
          return AllRecentPost(
            postlist: value.savepost,
            postcount: value.savepost.length,
          );
        },
      ),
    );
  }
}
