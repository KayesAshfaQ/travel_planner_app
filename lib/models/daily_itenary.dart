class DailyItenary {
  final int dayNumber;
  final String title;
  final String morningActivity;
  final String eveningActivity;
  final String afternoonActivity;
  final String diningSuggestions;
  final String tips;

  DailyItenary({
    required this.dayNumber,
    required this.title,
    required this.morningActivity,
    required this.eveningActivity,
    required this.afternoonActivity,
    required this.diningSuggestions,
    required this.tips,
  });

  factory DailyItenary.fromMap(Map<String, dynamic> map) {
    return DailyItenary(
      dayNumber: map['dayNumber'] as int,
      title: map['title'] as String,
      morningActivity: map['morningActivity'] as String,
      eveningActivity: map['eveningActivity'] as String,
      afternoonActivity: map['afternoonActivity'] as String,
      diningSuggestions: map['diningSuggestions'] as String,
      tips: map['tips'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dayNumber': dayNumber,
      'title': title,
      'morningActivity': morningActivity,
      'eveningActivity': eveningActivity,
      'afternoonActivity': afternoonActivity,
      'diningSuggestions': diningSuggestions,
      'tips': tips,
    };
  }
}
