import 'package:flutter/material.dart';
import 'package:smple_app/views/widgets/app/sidebar.dart';
import 'package:smple_app/views/widgets/generals/sample.dart';

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
          child: ImageAsset(path: 'assets/images/14.jpg', w: 400, h: 500),
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
