import 'package:flutter/material.dart';
import 'package:smple_app/common/global.dart';
import 'package:smple_app/core/models/user.dart';
import 'package:smple_app/views/widgets/simple.dart';
import 'package:uuid/uuid.dart';

class UserPage extends StatefulWidget {
  final String title;
  const UserPage({super.key, required this.title});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<User> users = [];
  final uuid = Uuid();

  void add(String name, String email, String phone) {
    setState(() {
      users.add(User(id: uuid.v4(), name: name, email: email, phone: phone));
    });
  }

  void update(String id, String name, String email, String phone) {
    setState(() {
      final index = users.indexWhere((u) => u.id == id);
      if (index != -1) {
        users[index] = User(id: id, name: name, email: email, phone: phone);
      }
    });
  }

  void delete(String id) {
    setState(() {
      users.removeWhere((u) => u.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            title: Text(user.name ?? 'No Name'),
            subtitle: Text('${user.email} | ${user.phone}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => showForm(user: user),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            'Delete User',
                            textAlign: TextAlign.center,
                          ),
                          content: Text(
                            'Are you sure you want to delete this ${user.name}?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                delete(user.id!);
                                Global.message(
                                  context,
                                  message: 'User deleted successfully!',
                                  bgColor: Colors.red,
                                );
                                Navigator.of(context).pop();
                              },
                              child: Text('Delete'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => showForm(),
      ),
    );
  }

  void showForm({User? user}) {
    final formKey = GlobalKey<FormState>();
    final name = TextEditingController(text: user?.name);
    final email = TextEditingController(text: user?.email);
    final phone = TextEditingController(text: user?.phone);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          alignment: Alignment.center,
          title: Text(
            user == null ? 'Add User' : 'Edit User',
            textAlign: TextAlign.center,
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Input(
                  label: "Name",
                  name: name,
                  icon: Icons.person,
                  hint: "Enter your name",
                  changed: (value) => value!.isEmpty ? 'Enter Name' : null,
                ),
                Input(
                  label: "Email",
                  name: email,
                  icon: Icons.email,
                  hint: "Enter your email",
                  changed: (value) => value!.isEmpty ? 'Enter email' : null,
                ),
                Input(
                  label: "Phone",
                  name: phone,
                  icon: Icons.phone,
                  hint: "Enter your phone",
                  changed: (value) => value!.isEmpty ? 'Enter phone' : null,
                ),
              ],
            ),
          ),
          actions: [
            Center(
              child: Button(
                click: () {
                  if (formKey.currentState!.validate()) {
                    final newUser = User(
                      id: user?.id,
                      name: name.text,
                      email: email.text,
                      phone: phone.text,
                    );
                    if (user == null) {
                      add(newUser.name!, newUser.email!, newUser.phone!);
                      //use snackbar to show success message
                      Global.message(
                        context,
                        message: 'User added successfully!',
                        bgColor: Colors.green,
                      );
                    } else {
                      update(
                        user.id!,
                        newUser.name!,
                        newUser.email!,
                        newUser.phone!,
                      );
                      Global.message(
                        context,
                        message: 'User updated successfully!',
                        bgColor: Colors.green,
                      );
                    }
                    Navigator.of(context).pop();
                  }
                },
                label: user == null ? 'Save' : 'Update',
                icon: user == null ? Icons.save : Icons.update,
              ),
            ),
          ],
        );
      },
    );
  }
}
