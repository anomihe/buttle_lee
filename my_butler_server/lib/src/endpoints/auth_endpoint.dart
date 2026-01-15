import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import '../generated/protocol.dart';

/// Endpoint for authentication and user profile management
class AuthEndpoint extends Endpoint {
  /// Register a new user with email, password, full name, and profile image
  Future<UserProfile?> registerWithProfile(
    Session session,
    String email,
    String password,
    String fullName,
    String? profileImageUrl,
  ) async {
    try {
      // Create user with serverpod_auth (creates email auth entry with password)
      final userInfo = await Emails.createUser(
        session,
        fullName, // userName
        email,
        password,
      );

      if (userInfo == null) {
        throw Exception('Failed to create user');
      }

      // Create user profile
      final userProfile = UserProfile(
        fullName: fullName,
        email: email,
        profileImageUrl: profileImageUrl,
        userInfoId: userInfo.id!,
      );

      await UserProfile.db.insertRow(session, userProfile);

      return userProfile;
    } catch (e) {
      session.log('Error registering user: $e');
      return null;
    }
  }

  /// Create user profile for an authenticated user (called after Serverpod auth registration)
  Future<UserProfile?> createProfile(
    Session session,
    String fullName,
    String email,
    String? profileImageUrl,
  ) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }

    // Get the integer user ID directly from the session
    final userId = authInfo.userId;

    try {
      // Check if profile already exists
      final existing = await UserProfile.db.findFirstRow(
        session,
        where: (t) => t.userInfoId.equals(userId),
      );

      if (existing != null) {
        return existing; // Profile already exists
      }

      // Create new profile
      final userProfile = UserProfile(
        fullName: fullName,
        email: email,
        profileImageUrl: profileImageUrl,
        userInfoId: userId,
      );

      await UserProfile.db.insertRow(session, userProfile);
      return userProfile;
    } catch (e) {
      session.log('Error creating profile: $e');
      return null;
    }
  }

  /// Get user profile for authenticated user
  Future<UserProfile?> getUserProfile(Session session) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }

    final userId = authInfo.userId;

    final profile = await UserProfile.db.findFirstRow(
      session,
      where: (t) => t.userInfoId.equals(userId),
    );

    return profile;
  }

  /// Update user's profile image
  Future<UserProfile?> updateProfileImage(
    Session session,
    String profileImageUrl,
  ) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }

    final userId = authInfo.userId;

    final profile = await UserProfile.db.findFirstRow(
      session,
      where: (t) => t.userInfoId.equals(userId),
    );

    if (profile == null) {
      throw Exception('Profile not found');
    }

    profile.profileImageUrl = profileImageUrl;
    await UserProfile.db.updateRow(session, profile);

    return profile;
  }
}
