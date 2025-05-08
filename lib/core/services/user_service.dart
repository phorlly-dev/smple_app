import 'package:flutter/material.dart';
import 'package:smple_app/common/global.dart';
import 'package:smple_app/core/models/user.dart';
import 'package:smple_app/core/services/service.dart';
import 'package:smple_app/views/forms/sample_form.dart';
import 'package:smple_app/views/widgets/sample.dart';

class UserService {
  // Add a new event
  Future<void> store(User object) async {
    await Service.create<User>(
      model: object,
      collectionName: 'users',
      toMap: (user) => user.toMap(),
    );
  }

  // Update an existing User
  Future<void> update(User object) async {
    // Update the user in Firestore
    await Service.update(
      collectionName: 'users',
      docId: object.id,
      toMap: object.toMap(),
    );
  }

  // Delete an User by its ID
  Future<void> remove(String id) async {
    await Service.delete(collectionName: 'users', docId: id);
  }

  // Future<User?> getUserById(String id) async {
  //   final doc = await _firestore.collection('users').doc(id).get();
  //   if (doc.exists) {
  //     return User.fromMap(doc.data()!, doc.id);
  //   }
  //   return null;
  // }

  // Stream builder for reusable widget
  userStreamBuilder(BuildContext context) {
    return Service.streamBuilder<User>(
      collectionName: 'users',
      fromMap: (data, docId) => User.fromMap(data, docId),
      builder: (context, data) {
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final object = data[index];

            return ListTile(
              title: Text(object.name),
              subtitle: Text(
                '${object.email}\n ${object.phone}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              trailing: ActionButtons(
                pressedOnDelete: () {
                  Global.confirmDelete(
                    context,
                    message: object.name,
                    confirmed: () {
                      Navigator.of(context).pop();
                      remove(object.id);

                      // Optionally refresh the UI or show a snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Deleted successfully')),
                      );
                    },
                  );
                },
                pressedOnEdit: () {
                  showForm(context, object);
                },
              ),
            );
          },
        );
      },
    );
  }

  // Function to show the form dialog for adding/editing a user
  void showForm(BuildContext context, User? item) {
    FormBuilder.showForm(
      context,
      title: 'User',
      item: item?.toMap(), // or pass item for editing
      listInputs: [
        {
          'label': 'Name',
          'name': 'name',
          'hint': 'Enter your name',
          'type': TextInputType.name,
          'icon': Icons.person,
        },
        {
          'label': 'Email',
          'name': 'email',
          'hint': 'Enter your email',
          'type': TextInputType.emailAddress,
          'icon': Icons.email,
        },
        {
          'label': 'Phone Number',
          'name': 'phone',
          'hint': 'Enter phone number',
          'type': TextInputType.text,
          'icon': Icons.phone,
        },
      ],
      submit: (object) async {
        item == null
            ? await store(
              User(
                id: '',
                name: object['name'],
                email: object['email'],
                phone: object['phone'],
              ),
            )
            : await update(
              User(
                id: item.id,
                name: object['name'],
                email: object['email'],
                phone: object['phone'],
              ),
            );
      },
    );
  }
}
