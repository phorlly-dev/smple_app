import 'package:flutter/material.dart';
import 'package:smple_app/core/services/user_service.dart';
import 'package:smple_app/views/widgets/topbar.dart';

class UserPage extends StatefulWidget {
  final String title;
  const UserPage({super.key, required this.title});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final _userService = UserService();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Topbar(
        title: widget.title,
        content: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Users',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Expanded(child: _userService.userStreamBuilder(context)),
            ],
          ),
        ),
        button: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _userService.showForm(context, null),
        ),
      ),
    );
  }
}
