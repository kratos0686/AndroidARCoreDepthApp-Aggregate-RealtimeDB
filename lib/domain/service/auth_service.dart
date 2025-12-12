import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Authentication service providing Firebase Google Sign-In integration
/// 
/// This service manages user authentication state and provides methods for:
/// - Google Sign-In authentication
/// - Sign out
/// - Current user state monitoring
/// 
/// Usage in IICRC Assistant Screen:
/// 1. Check authentication state using `currentUserStream`
/// 2. Gate UI features requiring authentication
/// 3. Call `signInWithGoogle()` to authenticate users
/// 4. Call `signOut()` when users want to log out
class AuthService {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthService({
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  /// Stream of the current user's authentication state
  /// 
  /// Returns a stream that emits the current [User] when authenticated,
  /// or null when not authenticated.
  /// 
  /// Listen to this stream to update UI based on authentication state:
  /// ```dart
  /// authService.currentUserStream.listen((user) {
  ///   if (user != null) {
  ///     // User is signed in
  ///   } else {
  ///     // User is signed out
  ///   }
  /// });
  /// ```
  Stream<User?> get currentUserStream => _firebaseAuth.authStateChanges();

  /// Get the current user synchronously
  /// 
  /// Returns the currently authenticated [User], or null if not authenticated.
  User? get currentUser => _firebaseAuth.currentUser;

  /// Sign in with Google using Firebase Authentication
  /// 
  /// This method:
  /// 1. Initiates Google Sign-In flow
  /// 2. Obtains Google authentication credentials
  /// 3. Signs in to Firebase with Google credentials
  /// 
  /// Returns: [UserCredential] on successful authentication
  /// 
  /// Throws:
  /// - [AuthException] if sign-in is cancelled or fails
  /// - [FirebaseAuthException] if Firebase authentication fails
  /// 
  /// Example:
  /// ```dart
  /// try {
  ///   final credential = await authService.signInWithGoogle();
  ///   print('Signed in as: ${credential.user?.displayName}');
  /// } catch (e) {
  ///   print('Sign-in failed: $e');
  /// }
  /// ```
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // If the user cancels the sign-in flow
      if (googleUser == null) {
        throw AuthException('Google Sign-In was cancelled by the user');
      }

      // Obtain the auth details from the Google Sign-In
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential for Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      return await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw AuthException(
        'Firebase authentication failed: ${e.message ?? e.code}',
      );
    } catch (e) {
      throw AuthException('Google Sign-In failed: $e');
    }
  }

  /// Sign out the current user
  /// 
  /// This method signs out from both Firebase and Google Sign-In.
  /// 
  /// Throws: [AuthException] if sign-out fails
  /// 
  /// Example:
  /// ```dart
  /// try {
  ///   await authService.signOut();
  ///   print('Successfully signed out');
  /// } catch (e) {
  ///   print('Sign-out failed: $e');
  /// }
  /// ```
  Future<void> signOut() async {
    try {
      // Sign out from both Firebase and Google
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw AuthException('Sign-out failed: $e');
    }
  }

  /// Check if a user is currently signed in
  /// 
  /// Returns: true if a user is signed in, false otherwise
  bool get isSignedIn => currentUser != null;

  /// Get the current user's display name
  /// 
  /// Returns: the display name if available, or null if not signed in
  String? get currentUserDisplayName => currentUser?.displayName;

  /// Get the current user's email
  /// 
  /// Returns: the email if available, or null if not signed in
  String? get currentUserEmail => currentUser?.email;

  /// Get the current user's photo URL
  /// 
  /// Returns: the photo URL if available, or null if not signed in
  String? get currentUserPhotoUrl => currentUser?.photoURL;
}

/// Custom exception for authentication errors
class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}
