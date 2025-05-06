import 'package:smple_app/core/models/user.dart';
import 'package:uuid/uuid.dart';

class Users {
  static List<User> users = [];
  static final uuid = Uuid();

  static void add(String name, String email, String phone) {
    users.add(User(id: uuid.v4(), name: name, email: email, phone: phone));
  }

  static void update(String id, String name, String email, String phone) {
    final index = users.indexWhere((u) => u.id == id);
    if (index != -1) {
      users[index] = User(id: id, name: name, email: email, phone: phone);
    }
  }

  static void delete(String id) {
    users.removeWhere((u) => u.id == id);
  }
}
