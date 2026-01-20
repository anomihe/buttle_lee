import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:my_butler_client/my_butler_client.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/auth_provider.dart';

class HouseholdDetailScreen extends StatefulWidget {
  final Household household;

  const HouseholdDetailScreen({super.key, required this.household});

  @override
  State<HouseholdDetailScreen> createState() => _HouseholdDetailScreenState();
}

class _HouseholdDetailScreenState extends State<HouseholdDetailScreen> {
  bool _isLoading = true;
  List<UserProfile> _members = [];

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    setState(() => _isLoading = true);
    try {
      final client = context.read<AuthProvider>().client;
      // We need a way to get members for a specification household.
      // Currently getHouseholdMembers gets for *all* households of user.
      // We might need to update backend or filter client side.
      // Backend: getHouseholdMembers() currently fetches *first* household members.
      // We need to update backend to get members by householdId.

      // Temporary workaround: if we assume getHouseholdMembers logic is updated or we filter locally if possible?
      // Actually, looking at previous backend code:
      // getHouseholdMembers finds first household match. This is bad for multi-household.

      // Let's rely on the plan to fix backend for getting members too.
      // For now, I will use existing constraint but I really should have updated getHouseholdMembers to take an ID.
      // I will add a TODO or fix backend next. SInce user is blocked, I'll update backend to accept optional ID?

      // The current getHouseholdMembers implementation:
      /*
      Future<List<UserProfile>> getHouseholdMembers(Session session) async {
         ...
         final memberships = await HouseholdMember.db.find(..., where: (t) => t.userId.equals(userId));
         final householdId = memberships.first.householdId; // FIRST
         final householdMembers = await HouseholdMember.db.find(..., where: (t) => t.householdId.equals(householdId));
         ...
      }
      */

      // I MUST update getHouseholdMembers to optionally take a householdId.

      final members = await client.household
          .getHouseholdMembers(householdId: widget.household.id);
      _members = members;
    } catch (e) {
      debugPrint('Error loading members: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _leaveHousehold() async {
    setState(() => _isLoading = true);
    try {
      final client = context.read<AuthProvider>().client;
      // Needs update to support specific household leave
      final success =
          await client.household.leaveHousehold(widget.household.id!);
      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Left household successfully')));
          Navigator.pop(context, true); // Return true to refresh list
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteHousehold() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Household?'),
        content: const Text(
            'Are you sure you want to delete this household? This cannot be undone and all members will be removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);
    try {
      final client = context.read<AuthProvider>().client;
      // Needs update to support specific household delete
      final success =
          await client.household.deleteHousehold(widget.household.id!);
      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Household deleted successfully')));
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _shareJoinCode() {
    Share.share(
      'Join my household on Butler Lee! Use code: ${widget.household.joinCode}',
      subject: 'Join my Butler Lee Household',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: _getBackgroundColor(isDark),
      child: Scaffold(
          backgroundColor: Colors.transparent, // Inherit from parent background
          appBar: AppBar(
            title: Text(widget.household.name,
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      _buildCard(
                        context,
                        title: 'Join Code',
                        icon: Icons.key_rounded,
                        isDark: isDark,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.3),
                                ),
                              ),
                              child: Column(
                                children: [
                                  SelectableText(
                                    widget.household.joinCode,
                                    style: GoogleFonts.outfit(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _shareJoinCode,
                                icon: const Icon(Icons.share_rounded),
                                label: const Text('Share Code'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildCard(
                        context,
                        title: 'Members',
                        icon: Icons.group_rounded,
                        isDark: isDark,
                        child: _members.isEmpty
                            ? const Text('No members found')
                            : ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _members.length,
                                separatorBuilder: (_, __) => const Divider(),
                                itemBuilder: (context, index) {
                                  final member = _members[index];
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage:
                                          member.profileImageUrl != null
                                              ? NetworkImage(
                                                  member.profileImageUrl!)
                                              : null,
                                      child: member.profileImageUrl == null
                                          ? Text(member.fullName[0])
                                          : null,
                                    ),
                                    title: Text(member.fullName,
                                        style: GoogleFonts.outfit(
                                            color: isDark
                                                ? Colors.white
                                                : Colors.black87)),
                                    subtitle: Text(
                                      'Level ${member.level ?? 1} • ${member.xp ?? 0} XP',
                                      style: GoogleFonts.outfit(
                                          color: isDark
                                              ? Colors.white70
                                              : Colors.black54),
                                    ),
                                  );
                                },
                              ),
                      ),
                      const SizedBox(height: 24),
                      _buildCard(
                        context,
                        title: 'Settings',
                        icon: Icons.settings_rounded,
                        isDark: isDark,
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: _leaveHousehold,
                                icon: const Icon(Icons.exit_to_app_rounded),
                                label: const Text('Leave Household'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.black54,
                                  side: const BorderSide(color: Colors.grey),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            // Delete Button (Visible only to Admin)
                            if (widget.household.adminId ==
                                context
                                    .read<AuthProvider>()
                                    .userProfile
                                    ?.userInfoId) ...[
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  onPressed: _deleteHousehold,
                                  icon:
                                      const Icon(Icons.delete_forever_rounded),
                                  label: const Text('Delete Household'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red,
                                    side: const BorderSide(color: Colors.red),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
    );
  }

  Widget _buildCard(BuildContext context,
      {required String title,
      required IconData icon,
      required Widget child,
      required bool isDark}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Theme.of(context).primaryColor),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.outfit(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Color _getBackgroundColor(bool isDark) {
    if (isDark) return const Color(0xFF0D2137);
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return const Color(0xFFE8F5F3); // Morning
    if (hour >= 12 && hour < 17) return const Color(0xFFFDF7E7); // Afternoon
    if (hour >= 17 && hour < 20) return const Color(0xFFE6EEF7); // Evening
    return const Color(0xFFE3E6EA); // Night
  }
}
