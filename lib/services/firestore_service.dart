import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/trip_plan.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveTripPlan(String userId, TripPlan plan) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('trips')
        .doc(plan.id)
        .set(plan.toMap());
  }

  Stream<List<TripPlan>> getUserTrips(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('trips')
        .orderBy('startDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TripPlan.fromMap(doc.data(), doc.id))
            .toList());
  }
}
