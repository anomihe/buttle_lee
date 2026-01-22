import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import '../generated/protocol.dart';
import 'dart:math';

class HouseholdEndpoint extends Endpoint {
  /// Create a new household
  Future<Household?> createHousehold(Session session, String name) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }

    final userId = authInfo.userId;
    // Generate a unique 6-char join code (simplified)
    final joinCode = _generateJoinCode();

    final household = Household(
      name: name,
      joinCode: joinCode,
      adminId: userId,
    );

    final insertedHousehold = await Household.db.insertRow(session, household);

    // Add creator as admin member
    await HouseholdMember.db.insertRow(
      session,
      HouseholdMember(
        householdId: insertedHousehold.id!,
        userId: userId,
        role: 'admin',
        joinedAt: DateTime.now(),
      ),
    );

    return insertedHousehold;
  }

  /// Join a household by code
  Future<bool> joinHousehold(Session session, String joinCode) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }
    final userId = authInfo.userId;

    final household = await Household.db.findFirstRow(
      session,
      where: (t) => t.joinCode.equals(joinCode.toUpperCase()),
    );

    if (household == null) {
      throw Exception('Household not found');
    }

    // Check if already a member
    final existingMember = await HouseholdMember.db.findFirstRow(
      session,
      where: (t) =>
          t.householdId.equals(household.id!) & t.userId.equals(userId),
    );

    if (existingMember != null) {
      return true; // Already joined
    }

    await HouseholdMember.db.insertRow(
      session,
      HouseholdMember(
        householdId: household.id!,
        userId: userId,
        role: 'member',
        joinedAt: DateTime.now(),
      ),
    );

    return true;
  }

  /// Get members of a specific household (or user's first one)
  Future<List<UserProfile>> getHouseholdMembers(Session session,
      {int? householdId}) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) {
      throw Exception('Not authenticated');
    }
    final userId = authInfo.userId;

    int? targetHouseholdId = householdId;

    if (targetHouseholdId == null) {
      // 1. Find households this user is in
      final membership = await HouseholdMember.db.findFirstRow(
        session,
        where: (t) => t.userId.equals(userId),
      );
      if (membership == null) return [];
      targetHouseholdId = membership.householdId;
    } else {
      // Verify membership
      final membership = await HouseholdMember.db.findFirstRow(
        session,
        where: (t) =>
            t.userId.equals(userId) & t.householdId.equals(targetHouseholdId),
      );
      if (membership == null) {
        throw Exception('Not a member of this household');
      }
    }

    // 2. Find all members of that household
    final householdMembers = await HouseholdMember.db.find(
      session,
      where: (t) => t.householdId.equals(targetHouseholdId!),
    );

    final memberUserIds = householdMembers.map((m) => m.userId).toList();

    // 3. Fetch UserProfiles
    final profiles = await UserProfile.db.find(
      session,
      where: (t) => t.userInfoId.inSet(memberUserIds.toSet()),
    );

    return profiles;
  }

  /// Get all households the user is a member of
  Future<List<Household>> getMyHouseholds(Session session) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) return [];
    final userId = authInfo.userId;

    // Find all memberships
    final memberships = await HouseholdMember.db.find(
      session,
      where: (t) => t.userId.equals(userId),
    );

    if (memberships.isEmpty) return [];

    final householdIds = memberships.map((m) => m.householdId).toSet();

    // Fetch the household details
    return await Household.db.find(
      session,
      where: (t) => t.id.inSet(householdIds),
    );
  }

  /// Leave a specific household
  Future<bool> leaveHousehold(Session session, int householdId) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) return false;
    final userId = authInfo.userId;

    final membership = await HouseholdMember.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId) & t.householdId.equals(householdId),
    );

    if (membership == null) return false; // Not in this household

    // Remove membership
    await HouseholdMember.db.deleteRow(session, membership);

    return true;
  }

  /// Delete the current household (if admin)
  Future<bool> deleteHousehold(Session session, int householdId) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) return false;
    final userId = authInfo.userId;

    final membership = await HouseholdMember.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId) & t.householdId.equals(householdId),
    );

    if (membership == null) return false;

    final household = await Household.db.findById(session, householdId);
    if (household == null) return false;

    // Check if user is admin
    if (household.adminId != userId) {
      throw Exception('Only the admin can delete the household');
    }

    // Delete all members
    await HouseholdMember.db.deleteWhere(
      session,
      where: (t) => t.householdId.equals(household.id!),
    );

    // Delete household
    await Household.db.deleteRow(session, household);

    return true;
  }

  String _generateJoinCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        6, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  Future<void> startFocusSession(
      Session session, int householdId, int durationMinutes) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) return;
    final userId = authInfo.userId;

    final household = await Household.db.findById(session, householdId);
    if (household == null) return;

    if (household.adminId != userId) {
      throw Exception('Only admin can start focus session');
    }

    household.isFocusActive = true;
    household.focusStartedBy = userId;
    household.focusEndTime =
        DateTime.now().add(Duration(minutes: durationMinutes));

    await Household.db.updateRow(session, household);
  }

  Future<void> stopFocusSession(Session session, int householdId) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) return;
    final userId = authInfo.userId;

    final household = await Household.db.findById(session, householdId);
    if (household == null) return;

    if (household.adminId != userId) {
      throw Exception('Only admin can stop focus session');
    }

    household.isFocusActive = false;
    household.focusEndTime = null;

    await Household.db.updateRow(session, household);
  }

  Future<void> shareRoutine(
      Session session, int householdId, String name, List<String> tasks) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) return;
    final userId = authInfo.userId;

    // Verify membership
    final member = await HouseholdMember.db.findFirstRow(
      session,
      where: (t) => t.householdId.equals(householdId) & t.userId.equals(userId),
    );
    if (member == null) throw Exception('Not a member');

    await SharedRoutine.db.insertRow(
      session,
      SharedRoutine(
        householdId: householdId,
        createdBy: userId,
        name: name,
        tasks: tasks,
        sharedAt: DateTime.now(),
      ),
    );
  }

  Future<List<SharedRoutine>> getSharedRoutines(
      Session session, int householdId) async {
    final authInfo = await session.authenticated;
    if (authInfo == null) return [];
    final userId = authInfo.userId;

    // Verify membership
    final member = await HouseholdMember.db.findFirstRow(
      session,
      where: (t) => t.householdId.equals(householdId) & t.userId.equals(userId),
    );
    if (member == null) return [];

    return await SharedRoutine.db.find(
      session,
      where: (t) => t.householdId.equals(householdId),
      orderBy: (t) => t.sharedAt,
      orderDescending: true,
    );
  }
}
