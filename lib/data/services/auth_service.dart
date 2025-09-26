import '../../data/models/user_model.dart';

// --- DESIGN PATTERN: SINGLETON ---
// This class ensures that there is only one instance of AuthService in the app.
class AuthService {
  // Private constructor
  AuthService._internal();

  // The single, static instance of the class
  static final AuthService _instance = AuthService._internal();

  // Public getter to access the instance
  static AuthService get instance => _instance;

  // --- DUMMY DATA STORE ---
  // This list will act as our in-memory "users" database.
  // MEHEDI-TODO: This entire list will be removed and replaced by Firestore calls.
  final List<AppUser> _users = [
    AppUser(uid: '1', email: 'admin@app.com', role: UserRole.admin),
    AppUser(uid: '2', email: 'staff@app.com', role: UserRole.staff),
  ];
  final Map<String, String> _passwords = {
    'admin@app.com': 'password',
    'staff@app.com': 'password',
  };


  // --- DUMMY LOGIN LOGIC ---
  Future<AppUser> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    // MEHEDI-TODO: This entire logic block will be replaced by a single call:
    // await FirebaseAuth.instance.signInWithEmailAndPassword(...)
    // You will handle exceptions from Firebase (e.g., user-not-found, wrong-password).
    
    final storedPassword = _passwords[email];
    if (storedPassword == password) {
      final user = _users.firstWhere((user) => user.email == email);
      return user;
    } else {
      throw Exception('Invalid email or password');
    }
  }

  // --- NEW: DUMMY SIGN UP LOGIC ---
  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    // MEHEDI-TODO: This will be replaced by two Firebase calls:
    // 1. `FirebaseAuth.instance.createUserWithEmailAndPassword(...)`
    // 2. A call to Firestore to save the user's details (name, role) in a 'users' collection.

    if (_users.any((user) => user.email == email)) {
      throw Exception('An account with this email already exists.');
    }
    
    // Create a new user and add them to our in-memory lists
    final newUser = AppUser(
      uid: DateTime.now().millisecondsSinceEpoch.toString(), // Dummy UID
      email: email,
      role: role,
    );
    _users.add(newUser);
    _passwords[email] = password;

    print('New user signed up: ${newUser.email}, Role: ${newUser.role}');
  }
}

