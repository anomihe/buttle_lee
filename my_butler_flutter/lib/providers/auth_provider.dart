import 'package:flutter/foundation.dart';
import 'package:my_butler_client/my_butler_client.dart';
import '../services/notification_service.dart';

class AuthProvider with ChangeNotifier {
  final Client client;
  UserProfile? _userProfile;
  bool _isAuthenticated = false;
  bool _isLoading = true;

  AuthProvider({required this.client});

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  UserProfile? get userProfile => _userProfile;

  /// Check if user is already logged in (call on app startup)
  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Check if we have a stored authentication key
      final storedKey = await client.authenticationKeyManager?.get();
      debugPrint(
          'Checking stored auth key: ${storedKey != null ? "exists" : "none"}');

      if (storedKey != null && storedKey.isNotEmpty) {
        // Try to load user profile to verify the session is still valid
        final profile = await client.auth.getUserProfile();

        if (profile != null) {
          debugPrint('Session restored for user: ${profile.fullName}');
          _userProfile = profile;
          _isAuthenticated = true;
        } else {
          // Session expired or invalid, clear it
          debugPrint('Session invalid, clearing stored key');
          await client.authenticationKeyManager?.remove();
          _isAuthenticated = false;
        }
      } else {
        _isAuthenticated = false;
      }
    } catch (e) {
      debugPrint('Error checking auth status: $e');
      _isAuthenticated = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Register a new user
  Future<String?> register({
    required String email,
    required String password,
    required String fullName,
    String? profileImageUrl,
  }) async {
    try {
      debugPrint('Attempting to register user: $email');

      // Use our custom registration endpoint that creates user and profile directly
      final profile = await client.auth.registerWithProfile(
        email,
        password,
        fullName,
        profileImageUrl,
      );

      debugPrint('registerWithProfile result: ${profile?.email}');

      if (profile == null) {
        debugPrint('Registration failed - profile is null');
        return 'Failed to create account. Email may already be in use.';
      }

      debugPrint('Profile created successfully!');

      // Authenticate to get a valid session token
      final authResponse = await client.modules.auth.email.authenticate(
        email,
        password,
      );

      debugPrint(
          'Authentication result: success=${authResponse.success}, keyId=${authResponse.keyId}, key=${authResponse.key}');

      if (!authResponse.success) {
        return 'Account created but login failed. Please try logging in.';
      }

      // Manually ensure the key is stored (workaround for potential issue)
      if (client.authenticationKeyManager != null &&
          authResponse.keyId != null &&
          authResponse.key != null) {
        final formattedKey = '${authResponse.keyId}:${authResponse.key}';
        await client.authenticationKeyManager!.put(formattedKey);
        debugPrint('Manually stored key: $formattedKey');
      }

      // Verify key is stored
      final storedKey = await client.authenticationKeyManager!.get();
      debugPrint('Stored key after login: $storedKey');

      _userProfile = profile;
      _isAuthenticated = true;
      notifyListeners();
      return null; // Success
    } catch (e) {
      debugPrint('Registration error: $e');
      return e.toString();
    }
  }

  /// Login user
  Future<String?> login(String email, String password) async {
    try {
      final authResponse = await client.modules.auth.email.authenticate(
        email,
        password,
      );

      debugPrint(
          'Login result: success=${authResponse.success}, keyId=${authResponse.keyId}');

      if (authResponse.success) {
        // Manually ensure the key is stored (workaround for potential issue)
        if (client.authenticationKeyManager != null &&
            authResponse.keyId != null &&
            authResponse.key != null) {
          final formattedKey = '${authResponse.keyId}:${authResponse.key}';
          await client.authenticationKeyManager!.put(formattedKey);
          debugPrint('Manually stored login key: $formattedKey');
        }

        _isAuthenticated = true;
        await loadUserProfile();

        // Subscribe to user-specific FCM topic for notifications
        if (_userProfile != null) {
          await NotificationService()
              .subscribeToTopic('user_${_userProfile!.userInfoId}');
        }

        notifyListeners();
        return null; // Success
      } else {
        return authResponse.failReason?.toString() ?? 'Login failed';
      }
    } catch (e) {
      return e.toString();
    }
  }

  /// Load user profile
  Future<void> loadUserProfile() async {
    try {
      debugPrint('Loading user profile...');
      final profile = await client.auth.getUserProfile();
      debugPrint('UserProfile loaded: $profile');
      if (profile != null) {
        debugPrint('UserProfile name: ${profile.fullName}');
        debugPrint('UserProfile email: ${profile.email}');
      } else {
        debugPrint('UserProfile is NULL');
      }
      _userProfile = profile;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading profile: $e');
    }
  }

  /// Update profile image
  Future<String?> updateProfileImage(String imageUrl) async {
    try {
      final profile = await client.auth.updateProfileImage(imageUrl);
      if (profile != null) {
        _userProfile = profile;
        notifyListeners();
        return null;
      }
      return 'Failed to update profile image';
    } catch (e) {
      return e.toString();
    }
  }

  /// Check if email exists
  Future<bool> checkEmailExists(String email) async {
    try {
      return await client.auth.checkEmailExists(email);
    } catch (e) {
      debugPrint('Error checking email: $e');
      return false;
    }
  }

  /// Reset password (Direct)
  Future<bool> resetPassword(String email, String newPassword) async {
    try {
      return await client.auth.resetPassword(email, newPassword);
    } catch (e) {
      debugPrint('Error resetting password: $e');
      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    // Clear the stored authentication key
    await client.authenticationKeyManager?.remove();
    _isAuthenticated = false;
    _userProfile = null;
    notifyListeners();
  }

  /// Update focus stats
  Future<void> updateFocusStats(int completed, int givenUp) async {
    try {
      if (_userProfile != null) {
        // Update local state immediately for UI responsiveness
        _userProfile = _userProfile!.copyWith(
          focusCompleted: (_userProfile!.focusCompleted) + completed,
          focusGivenUp: (_userProfile!.focusGivenUp) + givenUp,
        );
        notifyListeners();

        // Sync with server
        await client.userProfile.updateFocusStats(
          _userProfile!.focusCompleted,
          _userProfile!.focusGivenUp,
        );
      }
    } catch (e) {
      debugPrint('Error updating focus stats: $e');
    }
  }
}
