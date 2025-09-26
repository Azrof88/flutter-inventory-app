enum UserRole { admin, staff }

class AppUser {
  final String uid;
  final String email;
  final UserRole role;

  AppUser({required this.uid, required this.email, required this.role});

  // Factory constructor to create a AppUser from a Map (Firestore data)
  factory AppUser.fromMap(Map<String, dynamic> data, String documentId) {
    return AppUser(
      uid: documentId,
      email: data['email'] ?? '',
      // Convert string from Firestore to enum
      role: UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.${data['role']}',
        orElse: () => UserRole.staff, // Default to staff if role is missing
      ),
    );
  }

  // Method to convert AppUser to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'role': role.name, // Convert enum to string
    };
  }
}