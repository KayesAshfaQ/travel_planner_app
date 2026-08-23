import 'package:flutter/material.dart';
import '../models/trip_plan.dart';
import '../services/firestore_service.dart';
import '../services/gemini_ai_service.dart';

class TravelPlannerProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final GeminiAiService _aiService = GeminiAiService();
  
  bool _isGenerating = false;
  bool get isGenerating => _isGenerating;

  Future<TripPlan?> generateAndSaveTrip(
    String userId, {
    required String destination,
    required DateTime startDate,
    required DateTime endDate,
    required String budget,
  }) async {
    _isGenerating = true;
    notifyListeners();

    final plan = await _aiService.generateTripPlan(
      destination: destination,
      startDate: startDate,
      endDate: endDate,
      budget: budget,
    );

    if (plan != null) {
      await _firestoreService.saveTripPlan(userId, plan);
    }

    _isGenerating = false;
    notifyListeners();
    return plan;
  }

  Stream<List<TripPlan>> getUserTrips(String userId) {
    return _firestoreService.getUserTrips(userId);
  }
}
