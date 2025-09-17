import 'package:flutter/material.dart';
import 'package:mero_kotha/modelclass/modelclass.dart';
import 'package:mero_kotha/stagemanagement/statemanagement.dart';
import 'package:provider/provider.dart';

class Postpage extends StatelessWidget {
  const Postpage({super.key});

  @override
  Widget build(BuildContext context) {
    final providerr = Provider.of<Providerr>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Recent post')),
      body: SingleChildScrollView(
        controller: providerr.scrollController,
        child: AllRecentPost(
          postcount: providerr.postlist.length,
          postlist: providerr.postlist,
        ),
      ),
    );
  }
}
