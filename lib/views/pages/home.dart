import 'package:flutter/material.dart';
import 'package:smple_app/views/widgets/sidebar.dart';

class HomePage extends StatelessWidget {
  final String title;
  const HomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Siderbar(
        title: title,
        content: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [const Text("Home Page"), const SizedBox(height: 20)],
          ),
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
