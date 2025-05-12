import 'package:flutter/material.dart';
import 'package:smple_app/common/general.dart';

class HomePage extends StatelessWidget {
  final String title;
  const HomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Siderbar(
        title: title,
        content: Card(
          margin: EdgeInsets.only(top: 70, left: 12, right: 12),
          child: Image(image: AssetImage('assets/images/14.jpg')),
        ),
        // button: Button.icon(
        //   icon: Icons.add,
        //   pressed: () {
        //     // Add your button action here
        //     NavLink.nextName(context, slug: "/user");
        //   },
        // ),
      ),
    );
  }
}
