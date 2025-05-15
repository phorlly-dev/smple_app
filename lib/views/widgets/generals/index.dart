import 'package:flutter/material.dart';
import 'package:smple_app/core/functions/index.dart';

class Common {
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

  static Widget showDateTimePicker(
    BuildContext context, {
    required String label,
    required DateTime selected,
    required ValueChanged<DateTime> changed,
  }) {
    return ListTile(
      title: Text(label, textAlign: TextAlign.start),
      subtitle: Text(Funcs.dateTimeFormat(selected)),
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

  static Widget elevated({
    required VoidCallback pressed,
    String text = "Add New",
    Color? color,
    Color? textColor,
    double width = 100,
    double height = 50,
    double border = 10.0,
  }) {
    return ElevatedButton(
      onPressed: pressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: Size(width, height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(border),
        ),
      ),
      child: Text(text, style: TextStyle(color: textColor)),
    );
  }

  static Widget outlined({
    required VoidCallback pressed,
    String text = "Add New",
    Color? color,
    Color? textColor,
    double width = 100,
    double height = 50,
    double border = 10.0,
  }) {
    return OutlinedButton(
      onPressed: pressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: color,
        minimumSize: Size(width, height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(border),
        ),
      ),
      child: Text(text, style: TextStyle(color: textColor)),
    );
  }

  static Widget btnText({
    required VoidCallback pressed,
    String text = "Add New",
    Color? color,
    Color? textColor,
    double width = 100,
    double height = 50,
    double border = 10.0,
  }) {
    return TextButton(
      onPressed: pressed,
      style: TextButton.styleFrom(
        backgroundColor: color,
        minimumSize: Size(width, height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(border),
        ),
      ),
      child: Text(text, style: TextStyle(color: textColor)),
    );
  }

  static Widget icon({
    required VoidCallback pressed,
    IconData icon = Icons.add,
    Color color = Colors.black,
    double width = 50,
    // double border = 10.0,
  }) {
    return IconButton(
      onPressed: pressed,
      icon: Icon(icon),
      color: color,
      iconSize: width,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          const Color.fromARGB(255, 218, 217, 217),
        ),
      ),
      // padding: EdgeInsets.all(2),
    );
  }

  static Widget floating({
    required VoidCallback pressed,
    required Icon icon,
    Color? color,
    double width = 100,
    double height = 50,
    double border = 10.0,
  }) {
    return FloatingActionButton(
      onPressed: pressed,
      backgroundColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(border),
      ),
      child: icon,
    );
  }
}
