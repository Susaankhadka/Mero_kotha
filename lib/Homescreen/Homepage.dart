import 'package:flutter/material.dart';
import 'package:mero_kotha/Homescreen/frontscreen.dart';
import 'package:mero_kotha/Navigationbarpage/createpost.dart';
import 'package:mero_kotha/Navigationbarpage/mappage.dart';
import 'package:mero_kotha/Navigationbarpage/menupage.dart';
import 'package:mero_kotha/Navigationbarpage/postpage.dart';
import 'package:mero_kotha/stagemanagement/statemanagement.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _pages = [
    Homescreen(),
    Postpage(),

    CreatePostpage(),
    Mappage(),
    Menupage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: context.watch<Providerr>().selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: buttonnavigation(),
    );
  }

  BottomNavigationBar buttonnavigation() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: context.watch<Providerr>().selectedIndex,

      onTap: (index) {
        context.read<Providerr>().setIndex(index);
      },

      unselectedItemColor: Color.fromARGB(255, 0, 0, 5),
      selectedItemColor: Color.fromARGB(243, 237, 4, 4),

      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.maps_home_work_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.post_add), label: 'Feeds'),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Create'),
        BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Maps'),
        BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
      ],
    );
  }
}
