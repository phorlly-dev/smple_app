import 'package:flutter/material.dart';

// All button widget that can be used in the app.
class Button {
  static ElevatedButton elevated({
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

  static OutlinedButton outlined({
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

  static TextButton text({
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

  static IconButton icon({
    required VoidCallback pressed,
    IconData icon = Icons.add,
    Color color = Colors.black,
    double width = 40,
    // double border = 10.0,
  }) {
    return IconButton(
      onPressed: pressed,
      icon: Icon(icon),
      color: color,
      iconSize: width,
      // padding: EdgeInsets.all(border),
    );
  }

  static FloatingActionButton floating({
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
