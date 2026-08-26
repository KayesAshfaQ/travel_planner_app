import 'package:travel_planner_app/models/daily_itenary.dart';

class TripPlan {
  final String id;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final List<DailyItenary> itinerary;
  final String budget;
  final List<String> interests;

  TripPlan({
    required this.id,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.itinerary,
    required this.budget,
    required this.interests,
  });

  factory TripPlan.fromMap(Map<String, dynamic> data, String documentId) {
    List<DailyItenary> parsedItinerary = (data['itinerary'] as List<dynamic>? ?? [])
        .map((item) => DailyItenary.fromMap(item as Map<String, dynamic>))
        .toList();

    return TripPlan(
      id: documentId,
      destination: data['destination'] ?? '',
      startDate: data['startDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['startDate'])
          : DateTime.now(),
      endDate: data['endDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['endDate'])
          : DateTime.now(),
      itinerary: parsedItinerary,
      budget: data['budget'] ?? '',
      interests: List<String>.from(data['interests'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'destination': destination,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'itinerary': itinerary.map((e) => e.toMap()).toList(),
      'budget': budget,
      'interests': interests,
    };
  }
}
