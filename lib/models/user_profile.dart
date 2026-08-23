class UserProfile {
  final String uid;
  final String email;
  final String? displayName;

  UserProfile({
    required this.uid,
    required this.email,
    this.displayName,
  });

  factory UserProfile.fromMap(Map<String, dynamic> data, String documentId) {
    return UserProfile(
      uid: documentId,
      email: data['email'] ?? '',
      displayName: data['displayName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'displayName': displayName,
    };
  }
}
