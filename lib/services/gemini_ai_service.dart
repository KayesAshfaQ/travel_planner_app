import 'package:firebase_ai/firebase_ai.dart';
import '../models/trip_plan.dart';

class GeminiAiService {
  final GenerativeModel _model;

  GeminiAiService()
    : _model = FirebaseAI.googleAI().generativeModel(model: 'gemini-3.1-flash-lite');

  Future<TripPlan?> generateTripPlan({
    required String destination,
    required DateTime startDate,
    required DateTime endDate,
    required String budget,
  }) async {
    final days = endDate.difference(startDate).inDays;

    final prompt =
        '''
You are an expert travel planner. Create a day-by-day itinerary for a trip to $destination.
The trip is for $days days.
Budget level: $budget.

Provide a detailed, day-by-day plan including activities, suggested restaurants, and travel tips.
Format the output as a JSON object with the following structure:
{
  "dailyItinerary": [
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
}
''';

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      if (response.text != null) {
        return TripPlan(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          destination: destination,
          startDate: startDate,
          endDate: endDate,
          itinerary: response.text!,
          budget: budget,
        );
      }
    } catch (e) {
      print('Error generating trip plan: $e');
    }
    return null;
  }
}
