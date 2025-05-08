import 'package:flutter/material.dart';
import 'package:smple_app/core/models/user.dart';
import 'package:smple_app/views/widgets/sample.dart';
import 'package:uuid/uuid.dart';

class UserForm extends StatefulWidget {
  final User? user;

  const UserForm({super.key, this.user});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  List<User> users = [];
  final uuid = Uuid();

  void addUser(String name, String email, String phone) {
    setState(() {
      users.add(User(id: uuid.v4(), name: name, email: email, phone: phone));
    });
  }

  void updateUser(String id, String name, String email, String phone) {
    setState(() {
      final index = users.indexWhere((u) => u.id == id);
      if (index != -1) {
        users[index] = User(id: id, name: name, email: email, phone: phone);
      }
    });
  }

  void deleteUser(String id) {
    setState(() {
      users.removeWhere((u) => u.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final name = TextEditingController(text: widget.user?.name ?? '');
    final email = TextEditingController(text: widget.user?.email ?? '');
    final phone = TextEditingController(text: widget.user?.phone ?? '');

    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          const Text("User Card"),
          const SizedBox(height: 20),
          Input(
            label: "Name",
            name: name,
            icon: Icons.person,
            hint: "Enter your name",
          ),
          Input(
            label: "Email",
            name: email,
            icon: Icons.email,
            hint: "Enter your email",
            type: TextInputType.emailAddress,
          ),
          Input(
            label: "Phone",
            name: phone,
            icon: Icons.phone,
            hint: "Enter your phone",
            type: TextInputType.phone,
          ),

          const SizedBox(height: 20),
          Button(
            label: 'Send',
            click: () {
              // Handle the button click event here
              if (widget.user == null) {
                addUser(name.text, email.text, phone.text);
              } else {
                // updateUser(widget.user.id, name.text, email.text, phone.text);
              }
            },
            icon: Icons.send,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
