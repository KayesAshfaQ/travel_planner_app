class TripPlan {
  final String id;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final String itinerary;
  final String budget;

  TripPlan({
    required this.id,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.itinerary,
    required this.budget,
  });

  factory TripPlan.fromMap(Map<String, dynamic> data, String documentId) {
    return TripPlan(
      id: documentId,
      destination: data['destination'] ?? '',
      startDate: data['startDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['startDate'])
          : DateTime.now(),
      endDate: data['endDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(data['endDate'])
          : DateTime.now(),
      itinerary: data['itinerary'] ?? '',
      budget: data['budget'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'destination': destination,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'itinerary': itinerary,
      'budget': budget,
    };
  }
}
