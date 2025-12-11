import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Service for Firebase Authentication with Google Sign-In
/// 
/// Provides secure authentication flow for the app using Firebase Auth
/// and Google Sign-In. This replaces direct API key usage in the app.
/// 
/// Features:
/// - Google Sign-In integration
/// - User session management
/// - Sign out functionality
/// - Real-time authentication state stream
class AuthService {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  /// Create an AuthService instance
  /// 
  /// [firebaseAuth] - Optional FirebaseAuth instance for testing
  /// [googleSignIn] - Optional GoogleSignIn instance for testing
  AuthService({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(
          scopes: ['email', 'profile'],
        );

  /// Get the current authenticated user
  /// 
  /// Returns: Current [User] or null if not authenticated
  User? get currentUser => _firebaseAuth.currentUser;

  /// Stream of authentication state changes
  /// 
  /// Emits a new [User] whenever the authentication state changes.
  /// Emits null when the user signs out.
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Sign in with Google
  /// 
  /// Opens Google Sign-In flow and authenticates with Firebase.
  /// 
  /// Returns: [UserCredential] on successful sign-in
  /// Throws: [AuthException] if sign-in fails
  /// 
  /// Usage:
  /// ```dart
  /// try {
  ///   final userCredential = await authService.signInWithGoogle();
  ///   print('Signed in as: ${userCredential.user?.displayName}');
  /// } catch (e) {
  ///   print('Sign-in failed: $e');
  /// }
  /// ```
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in flow
        throw AuthException(
          'Sign-in cancelled',
          'User cancelled the Google Sign-In flow.',
        );
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential = await _firebaseAuth.signInWithCredential(credential);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        'Firebase Auth Error',
        'Firebase authentication failed: ${e.code} - ${e.message}',
      );
    } catch (e) {
      throw AuthException(
        'Sign-in Error',
        'An unexpected error occurred during sign-in: $e',
      );
    }
  }

  /// Sign out the current user
  /// 
  /// Signs out from both Firebase and Google Sign-In.
  /// 
  /// Throws: [AuthException] if sign-out fails
  /// 
  /// Usage:
  /// ```dart
  /// await authService.signOut();
  /// print('User signed out successfully');
  /// ```
  Future<void> signOut() async {
    try {
      // Sign out from Firebase
      await _firebaseAuth.signOut();

      // Sign out from Google Sign-In
      await _googleSignIn.signOut();
    } catch (e) {
      throw AuthException(
        'Sign-out Error',
        'Failed to sign out: $e',
      );
    }
  }

  /// Check if a user is currently signed in
  /// 
  /// Returns: true if a user is authenticated, false otherwise
  bool get isSignedIn => _firebaseAuth.currentUser != null;

  /// Get the current user's display name
  /// 
  /// Returns: User's display name or 'Unknown User' if not available
  String get userDisplayName => 
      _firebaseAuth.currentUser?.displayName ?? 'Unknown User';

  /// Get the current user's email
  /// 
  /// Returns: User's email or 'No email' if not available
  String get userEmail => 
      _firebaseAuth.currentUser?.email ?? 'No email';

  /// Get the current user's photo URL
  /// 
  /// Returns: User's photo URL or null if not available
  String? get userPhotoUrl => _firebaseAuth.currentUser?.photoURL;

  /// Get the current user's UID (unique identifier)
  /// 
  /// Returns: User's UID or null if not authenticated
  String? get userId => _firebaseAuth.currentUser?.uid;
}

/// Custom exception for authentication operations
class AuthException implements Exception {
  final String title;
  final String message;

  AuthException(this.title, this.message);

  @override
  String toString() => 'AuthException: $title - $message';
}
