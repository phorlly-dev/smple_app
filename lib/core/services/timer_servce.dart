import 'package:smple_app/core/models/timer_item.dart';
import 'package:smple_app/core/services/service.dart';

class TimerServce {
  // Add a new
  Future<void> store(TimerItem object) async {
    await Service.create<TimerItem>(
      model: object,
      collectionName: 'timers',
      toMap: (value) => value.toMap(),
    );
  }

  // Update an existing
  Future<void> update(TimerItem object) async {
    // Update the timer in Firestore
    await Service.update(
      collectionName: 'timers',
      docId: object.id,
      toMap: object.toMap(),
    );
  }

  // Delete an timer by its ID
  Future<void> remove(String id) async {
    await Service.delete(collectionName: 'timers', docId: id);
  }
}
