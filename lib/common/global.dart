import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smple_app/common/nav_link.dart';
import 'package:smple_app/views/pages/home.dart';
import 'package:smple_app/views/pages/user_list.dart';
import 'package:smple_app/views/pages/weight_calculator.dart';

class Global {
  static Widget text(
    String title, {
    double size = 14,
    Color color = Colors.black,
    TextAlign textAlign = TextAlign.center,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return Text(
      title,
      style: TextStyle(fontSize: size, fontWeight: fontWeight, color: color),
      textAlign: textAlign,
    );
  }

  static message(
    BuildContext context, {
    String message = 'Posted!',
    Color bgColor = Colors.blue,
  }) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, textAlign: TextAlign.center),
        backgroundColor: bgColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static confirmDelete(
    BuildContext context, {
    required String message,
    required VoidCallback confirmed,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete the: $message', textAlign: TextAlign.center),
          content: Text('Are you sure you want to delete:\n $message?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(onPressed: confirmed, child: Text('Delete')),
          ],
        );
      },
    );
  }

  static BottomNavigationBar bottomBar(BuildContext context) {
    // Bottom navigation bar with two items: Home and Settings
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'User'),
        BottomNavigationBarItem(
          icon: Icon(Icons.calculate),
          label: 'Calculator',
        ),

        // BottomNavigationBarItem(
        //   icon: Icon(Icons.calendar_month),
        //   label: 'Calendar',
        // ),
        // BottomNavigationBarItem(icon: Icon(Icons.music_note), label: 'Music'),
        // BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Timer'),
        // BottomNavigationBarItem(icon: Icon(Icons.note_add), label: 'Note'),
        // BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
      currentIndex: 0,
      onTap: (index) {
        // Handle bottom navigation bar tap
        if (index == 0) {
          NavLink.next(context, widget: HomePage(title: "Home Page"));
        } else if (index == 1) {
          NavLink.next(context, widget: UserPage(title: "User List"));
        } else if (index == 2) {
          NavLink.next(context, widget: WeightCalculator());
        }
        //  else if (index == 3) {
        //   NavLink.next(context, widget: CalendarPage(title: "Calendar"));
        // } else if (index == 4) {
        //   NavLink.next(context, widget: MusicPage(title: "Music"));
        // } else if (index == 5) {
        //   NavLink.next(context, widget: TimerPage(title: "Timer"));
        // } else if (index == 6) {
        //   NavLink.next(context, widget: NotePage(title: "Note"));
        // } else if (index == 7) {
        //   NavLink.next(context, widget: SettingsPage(title: "Settings"));
        // }
      },
    );
  }

  static dateTimeFormat(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy, hh:mm a').format(dateTime);
  }

  static Widget showDateTimePicker(
    BuildContext context, {
    required String label,
    required DateTime selected,
    required ValueChanged<DateTime> changed,
  }) {
    return ListTile(
      title: Text(label),
      subtitle: Text(dateTimeFormat(selected)),
      trailing: const Icon(Icons.date_range),
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selected,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (date != null && context.mounted) {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(selected),
          );
          if (time != null) {
            final newDateTime = DateTime(
              date.year,
              date.month,
              date.day,
              time.hour,
              time.minute,
            );
            changed(newDateTime);
          }
        }
      },
    );
  }

  static showModal(
    BuildContext context, {
    required String title,
    model,
    required List<Widget> children,
    VoidCallback? onDelete,
    VoidCallback? onSave,
    VoidCallback? onUpdate,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                model == null ? 'Add New $title' : 'Edit The $title',
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: children,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Global.text('Cancel'),
                ),

                if (model != null)
                  TextButton(
                    onPressed: () {
                      onDelete?.call();

                      Navigator.pop(context);
                      Global.message(
                        context,
                        message: '$title deleted successfully!',
                      );
                    },
                    child: Global.text('Delete', color: Colors.red),
                  ),

                TextButton(
                  onPressed: () {
                    if (model == null) {
                      onSave?.call();

                      Navigator.pop(context);
                      Global.message(
                        context,
                        message: '$title created successfully!',
                      );
                    } else {
                      onUpdate?.call();

                      Navigator.pop(context);
                      Global.message(
                        context,
                        message: '$title updated successfully!',
                        bgColor: Colors.green,
                      );
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
