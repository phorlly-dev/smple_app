import 'package:flutter/material.dart';
import 'package:smple_app/core/models/user.dart';
import 'package:smple_app/core/services/user_service.dart';
import 'package:smple_app/views/forms/sample_form.dart';

class UserForm {
  // Function to show the form dialog for adding/editing a user
  static void showForm(BuildContext context, User? item) {
    FormBuilder.showForm(
      context,
      title: 'User',
      item: item?.toMap(), // or pass item for editing
      listInputs: [
        {
          'label': 'Full Name',
          'name': 'name',
          'hint': 'Enter your full name',
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
          'type': TextInputType.phone,
          'icon': Icons.phone,
        },
      ],
      submit: (object) async {
        // log('object: $object');
        item!.id.isEmpty
            ? await UserService.store(
              User(
                id: '',
                name: object['name'],
                email: object['email'],
                phone: object['phone'],
              ),
            )
            : await UserService.update(
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
