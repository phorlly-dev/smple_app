import 'package:flutter/material.dart';

class NavLink {
  static next(BuildContext context, {required Widget slug}) {
    return Navigator.push(context, MaterialPageRoute(builder: (_) => slug));
  }

  static nextReplace(BuildContext context, {required Widget slug}) {
    return Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => slug),
    );
  }

  static nextName(BuildContext context, {required String slug}) {
    Navigator.pushNamed(context, slug);
  }

  static nextRepalceName(BuildContext context, {required String slug}) {
    return Navigator.pushReplacementNamed(context, slug);
  }

  static back(BuildContext context) {
    return Navigator.pop(context);
  }

  static backUntil(BuildContext context, {required String slug}) {
    return Navigator.popUntil(context, ModalRoute.withName(slug));
  }
}
