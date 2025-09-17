import 'package:flutter/material.dart';

class Bookingspace extends StatelessWidget {
  const Bookingspace({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Form(
            child: TextFormField(decoration: InputDecoration(hintText: 'Name')),
          ),
        ],
      ),
    );
  }
}
