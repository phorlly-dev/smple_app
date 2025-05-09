import 'package:flutter/material.dart';
import 'package:smple_app/common/global.dart';
import 'package:smple_app/core/models/meeting.dart';
import 'package:smple_app/core/services/service.dart';

class MeetingService {
  // Fetch all meetings from Firestore
  Future<List<Meeting>> index() async {
    final snapshot = await Service.readAll<Meeting>(
      collectionName: 'meetings',
      fromMap: (data, docId) => Meeting.fromMap(data, docId),
    );

    return snapshot;
  }

  // Fetch a single meeting by its ID
  Future<void> store(Meeting object) async {
    await Service.create<Meeting>(
      model: object,
      collectionName: 'meetings',
      toMap: (event) => event.toMap(),
    );
  }

  // Fetch a single meeting by its ID
  Future<void> update(Meeting object) async {
    // Update the data in Firestore
    await Service.update(
      collectionName: 'meetings',
      docId: object.id,
      toMap: object.toMap(),
    );
  }

  // Delete a meeting by its ID
  Future<void> remove(String id) async {
    await Service.delete(collectionName: 'meetings', docId: id);
  }

  // Stream builder for reusable widget
  void showForm(BuildContext context, {Meeting? model, VoidCallback? refresh}) {
    final title = TextEditingController(text: model?.eventName);
    DateTime start = model?.from ?? DateTime.now();
    DateTime end = model?.to ?? DateTime.now().add(const Duration(hours: 1));
    bool isAllDay = model?.isAllDay ?? false;

    Global.showModal(context, title: 'Meeting', children: []);
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                model == null ? 'Add Meeting' : 'Edit Meeting',
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: title,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  Global.showDateTimePicker(
                    context,
                    label: 'From',
                    selected: start,
                    changed: (value) => setState(() => start = value),
                  ),

                  Global.showDateTimePicker(
                    context,
                    label: 'To',
                    selected: end,
                    changed: (value) => setState(() => end = value),
                  ),

                  CheckboxListTile(
                    value: isAllDay,
                    onChanged:
                        (value) => setState(() => isAllDay = value ?? false),
                    title: const Text('All Day'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Global.text('Cancel'),
                ),

                if (model != null)
                  TextButton(
                    onPressed: () async {
                      await remove(model.id);

                      if (context.mounted) {
                        Navigator.pop(context);
                        refresh;
                        Global.message(context, message: 'Meeting deleted');
                      }
                    },
                    child: Global.text('Delete', color: Colors.red),
                  ),

                TextButton(
                  onPressed: () async {
                    if (title.text.isEmpty) {
                      Global.message(
                        context,
                        message: 'Title cannot be empty',
                        bgColor: Colors.red,
                      );
                    } else {
                      final item = Meeting(
                        id: model!.id,
                        eventName: title.text,
                        from: start,
                        to: end,
                        background: Colors.lightGreenAccent,
                        isAllDay: isAllDay,
                      );

                      model.id.isEmpty ? await update(item) : await store(item);

                      if (context.mounted) {
                        Navigator.pop(context);
                        refresh;
                        Global.message(
                          context,
                          message: 'Title cannot be empty',
                          bgColor: Colors.red,
                        );
                      }
                    }
                  },
                  child: Global.text(
                    model == null ? 'Save' : 'Update',
                    color: model == null ? Colors.blue : Colors.green,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
