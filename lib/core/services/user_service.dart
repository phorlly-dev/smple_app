import 'package:flutter/material.dart';
import 'package:smple_app/core/dialogs/index.dart';
import 'package:smple_app/core/models/user.dart';
import 'package:smple_app/core/services/service.dart';
import 'package:smple_app/views/forms/user_form.dart';
import 'package:smple_app/views/widgets/generals/sample.dart';

class UserService {
  // Add a new
  static Future<void> store(User object) async {
    await Service.create<User>(
      model: object,
      collectionName: 'users',
      toMap: (value) => value.toMap(),
    );
  }

  // Update an existing
  static Future<void> update(User object) async {
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
  stream(BuildContext context) {
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
                  Popup.confirmDelete(
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
                  UserForm.showForm(context, object);
                },
              ),
            );
          },
        );
      },
    );
  }
}
