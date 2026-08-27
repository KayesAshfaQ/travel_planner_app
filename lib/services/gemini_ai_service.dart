import 'dart:convert';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/foundation.dart';
import 'package:travel_planner_app/models/daily_itenary.dart';
import 'package:travel_planner_app/services/places_service.dart';
import '../models/trip_plan.dart';

class GeminiAiService {
  final GenerativeModel _model;
  final PlacesService _placesService;

  GeminiAiService()
    : _model = FirebaseAI.googleAI().generativeModel(
        model: 'gemini-3.6-flash',
      ),
      _placesService = PlacesService();

  Future<TripPlan?> generateTripPlan({
    required String destination,
    required DateTime startDate,
    required DateTime endDate,
    required String budget,
    required List<String> interests,
  }) async {
    final days = endDate.difference(startDate).inDays;

    final placesContext = await _placesService.fetchPlacesContext(
      destination,
      interests,
    );

    final prompt =
        '''
You are an expert travel planner. Create a day-by-day itinerary for a trip to $destination.
The trip is for $days days.
Budget level: $budget.
Interests/Preferences: ${interests.join(', ')}.

Here are some real places you MUST use to build the itinerary (hotels, restaurants, attractions):
$placesContext

Provide a detailed, day-by-day plan incorporating these places. You must return ONLY a JSON array of objects, where each object represents a day and matches the following schema:
[
  {
    "dayNumber": 1,
    "title": "Day 1",
    "morningActivity": "Morning activity",
    "afternoonActivity": "Afternoon activity",
    "eveningActivity": "Evening activity",
    "diningSuggestions": "Dining suggestions",
    "tips": "Tips"
  }
]
''';

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      if (response.text != null) {
        final rawText = response.text!.trim();

        String jsonString = rawText;
        if (jsonString.startsWith('```json')) {
          jsonString = jsonString.substring(7);
          if (jsonString.endsWith('```')) {
            jsonString = jsonString.substring(0, jsonString.length - 3);
          }
        } else if (jsonString.startsWith('```')) {
          jsonString = jsonString.substring(3);
          if (jsonString.endsWith('```')) {
            jsonString = jsonString.substring(0, jsonString.length - 3);
          }
        }

        final dynamic decodedJson = json.decode(jsonString);
        List<dynamic> jsonList = [];
        if (decodedJson is Map && decodedJson.containsKey('dailyItinerary')) {
          jsonList = decodedJson['dailyItinerary'] as List<dynamic>;
        } else if (decodedJson is List) {
          jsonList = decodedJson;
        }

        final List<DailyItenary> parsedItinerary = jsonList
            .map((item) => DailyItenary.fromMap(item as Map<String, dynamic>))
            .toList();

        return TripPlan(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          destination: destination,
          startDate: startDate,
          endDate: endDate,
          itinerary: parsedItinerary,
          budget: budget,
          interests: interests,
        );
      }
    } catch (e) {
      debugPrint('Error generating trip plan: $e');
    }
    return null;
  }
}
