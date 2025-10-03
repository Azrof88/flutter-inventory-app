import 'package:cloud_firestore/cloud_firestore.dart'; // <-- ADDED: Import Firestore
import '../models/user_model.dart';
import 'data_change_notifier.dart';

// --- DESIGN PATTERN: SINGLETON ---
class UserService {
  UserService._internal();
  static final UserService _instance = UserService._internal();
  static UserService get instance => _instance;

  // <-- CHANGED: Reference to the 'users' collection in Firestore -->
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  /// Fetches a list of all users from Firestore.
  Future<List<AppUser>> getUsers() async {
    try {
      // <-- CHANGED: Get a snapshot of the entire 'users' collection -->
      final snapshot = await _usersCollection.get();
      
      // Map the documents to a list of AppUser objects
      return snapshot.docs.map((doc) => AppUser.fromFirestore(doc)).toList();
    } catch (e) {
      // Handle potential errors, e.g., permissions issues
      print('Error fetching users: $e');
      return [];
    }
  }

  /// Changes a user's role from staff to admin in Firestore.
  Future<void> promoteToAdmin({required String userId}) async {
    try {
      // <-- CHANGED: Update the 'role' field in the specific user's document -->
      await _usersCollection.doc(userId).update({'role': 'admin'});
      dataChangeNotifier.notify(); // Notify listeners of the change
    } catch (e) {
      print('Error promoting user: $e');
    }
  }

  /// Deletes a user's document from Firestore.
  Future<void> deleteUser({required String userId}) async {
    try {
      // <-- CHANGED: Delete the specific user's document from the collection -->
      await _usersCollection.doc(userId).delete();
      dataChangeNotifier.notify(); // Notify listeners of the change
    } catch (e) {
      print('Error deleting user: $e');
    }
  }
}