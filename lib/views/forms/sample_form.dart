import 'package:flutter/material.dart';
import 'package:smple_app/common/global.dart';
import 'package:smple_app/views/widgets/sample.dart';

class FormBuilder {
  static void showForm(
    BuildContext context, {
    required String title,
    Map<String, dynamic>? item,
    required List<Map<String, dynamic>> listInputs,
    required Function(Map<String, dynamic> newData) submit,
  }) {
    final formKey = GlobalKey<FormState>();
    final Map<String, TextEditingController> controllers = {};

    // Initialize controllers with item values or empty
    for (var input in listInputs) {
      final key = input['name'];
      final value = item != null ? item[key] ?? '' : '';
      final controller = TextEditingController(text: value);
      controllers[key] = controller;
      input['controller'] = controller; // inject controller into the input map
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          alignment: Alignment.center,
          title: Text(
            item == null ? 'Add New $title' : 'Edit The $title',
            textAlign: TextAlign.center,
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children:
                    listInputs.map((input) {
                      return Input(
                        label: input['label'],
                        hint: input['hint'],
                        icon: input['icon'],
                        type: input['type'],
                        name: input['controller'], // renamed correctly
                        // saved: (value) {
                        //   // Optional onSaved logic, if needed later
                        // },
                        // checked:
                        //     (value) =>
                        //         value!.isEmpty
                        //             ? 'Enter the ${input['label']}'
                        //             : null,
                        // changed: (value) {
                        //   // Optional: live validation or side effects
                        //   return null;
                        // },
                      );
                    }).toList(),
              ),
            ),
          ),
          actions: [
            Center(
              child: Button(
                click: () {
                  if (formKey.currentState!.validate()) {
                    final newData = <String, dynamic>{};

                    // Extract values from all controllers
                    controllers.forEach((key, controller) {
                      newData[key] = controller.text;
                    });

                    if (item == null) {
                      // If item is null, it's an add operation
                      Global.message(
                        context,
                        message: 'Created successfully!',
                        bgColor: Colors.blue,
                      );
                    } else {
                      // If item is not null, it's an edit operation
                      Global.message(
                        context,
                        message: 'Updated successfully!',
                        bgColor: Colors.green,
                      );
                    }

                    // Call the submit function with the new data
                    submit(newData);
                    Navigator.of(context).pop();
                  }
                },
                label: item == null ? 'Save' : 'Update',
                icon: item == null ? Icons.save : Icons.update,
                color: item == null ? Colors.blue : Colors.green,
              ),
            ),
          ],
        );
      },
    );
  }
}
