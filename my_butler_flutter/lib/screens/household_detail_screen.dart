import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:my_butler_client/my_butler_client.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/auth_provider.dart';
import '../services/routine_service.dart';

class HouseholdDetailScreen extends StatefulWidget {
  final Household household;

  const HouseholdDetailScreen({super.key, required this.household});

  @override
  State<HouseholdDetailScreen> createState() => _HouseholdDetailScreenState();
}

class _HouseholdDetailScreenState extends State<HouseholdDetailScreen> {
  bool _isLoading = true;
  List<UserProfile> _members = [];
  List<SharedRoutine> _sharedRoutines = [];
  late Household _household;

  @override
  void initState() {
    super.initState();
    _household = widget.household;
    _loadMembers();
    _loadSharedRoutines();
  }

  Future<void> _loadMembers() async {
    setState(() => _isLoading = true);
    try {
      final client = context.read<AuthProvider>().client;
      // Ideally should be by householdId, using existing method for now
      final members = await client.household
          .getHouseholdMembers(householdId: widget.household.id);
      _members = members;
    } catch (e) {
      debugPrint('Error loading members: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loadSharedRoutines() async {
    try {
      final client = context.read<AuthProvider>().client;
      final routines = await client.household.getSharedRoutines(_household.id!);
      setState(() => _sharedRoutines = routines);
    } catch (e) {
      debugPrint('Error load shared routines: $e');
    }
  }

  Future<void> _leaveHousehold() async {
    setState(() => _isLoading = true);
    try {
      final client = context.read<AuthProvider>().client;
      final success =
          await client.household.leaveHousehold(widget.household.id!);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Left household successfully')));
        Navigator.pop(context, true);
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
            'Are you sure? This cannot be undone and all members will be removed.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
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
      final success =
          await client.household.deleteHousehold(widget.household.id!);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Household deleted successfully')));
        Navigator.pop(context, true);
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

  Future<void> _startFocus() async {
    final duration = await showDialog<int>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Set Focus Duration'),
        children: [15, 25, 45, 60]
            .map((e) => SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, e),
                  child: Text('$e minutes'),
                ))
            .toList(),
      ),
    );

    if (duration == null) return;

    setState(() => _isLoading = true);
    try {
      final client = context.read<AuthProvider>().client;
      await client.household.startFocusSession(_household.id!, duration);
      // Refresh household to get status
      final households = await client.household.getMyHouseholds();
      final updated = households.firstWhere((h) => h.id == _household.id);
      setState(() => _household = updated);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Focus session started for team!')));
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _stopFocus() async {
    setState(() => _isLoading = true);
    try {
      final client = context.read<AuthProvider>().client;
      await client.household.stopFocusSession(_household.id!);
      // Refresh household
      final households = await client.household.getMyHouseholds();
      final updated = households.firstWhere((h) => h.id == _household.id);
      setState(() => _household = updated);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Focus session ended.')));
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _shareRoutine() async {
    final type = await showDialog<RoutineType>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Share which routine?'),
        children: RoutineType.values
            .map((e) => SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, e),
                  child: Text(e.name.toUpperCase()),
                ))
            .toList(),
      ),
    );

    if (type == null) return;

    setState(() => _isLoading = true);
    try {
      final tasks = await RoutineService().getRoutine(type);
      final client = context.read<AuthProvider>().client;
      await client.household
          .shareRoutine(_household.id!, '${type.name} Routine', tasks);

      await _loadSharedRoutines();
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Routine shared!')));
      }
    } catch (e) {
      debugPrint('Error sharing routine: $e');
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
    final userId = context.read<AuthProvider>().userProfile?.userInfoId;
    final isAdmin = userId == _household.adminId;

    return Container(
      color: _getBackgroundColor(isDark),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(_household.name,
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
                      // Community Focus Card
                      _buildCard(
                        context,
                        title: 'Community Focus',
                        icon: Icons.self_improvement_rounded,
                        isDark: isDark,
                        child: Column(
                          children: [
                            if (_household.isFocusActive)
                              Container(
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.green),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.timer,
                                        color: Colors.green),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Focus Session Active!',
                                        style: GoogleFonts.outfit(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              const Text('No active focus session.'),
                            if (isAdmin) ...[
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: _household.isFocusActive
                                    ? OutlinedButton.icon(
                                        onPressed: _stopFocus,
                                        icon: const Icon(Icons.stop_circle),
                                        label: const Text('End Session'),
                                        style: OutlinedButton.styleFrom(
                                            foregroundColor: Colors.red),
                                      )
                                    : ElevatedButton.icon(
                                        onPressed: _startFocus,
                                        icon: const Icon(Icons.play_circle),
                                        label:
                                            const Text('Start Community Focus'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          foregroundColor: Colors.white,
                                        ),
                                      ),
                              ),
                            ]
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Join Code
                      _buildCard(
                        context,
                        title: 'Join Code',
                        icon: Icons.key_rounded,
                        isDark: isDark,
                        child: Column(
                          children: [
                            SelectableText(
                              _household.joinCode,
                              style: GoogleFonts.outfit(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                                color: Theme.of(context).colorScheme.primary,
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
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Members
                      _buildMemberSection(isDark),
                      const SizedBox(height: 24),

                      // Shared Routines
                      _buildSharedRoutinesSection(isDark),
                      const SizedBox(height: 24),

                      // Settings
                      _buildSettingsSection(isDark, isAdmin),
                    ],
                  ),
                )),
    );
  }

  Widget _buildMemberSection(bool isDark) {
    return _buildCard(
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
                    backgroundImage: member.profileImageUrl != null
                        ? NetworkImage(member.profileImageUrl!)
                        : null,
                    child: member.profileImageUrl == null
                        ? Text(member.fullName[0])
                        : null,
                  ),
                  title: Text(member.fullName,
                      style: GoogleFonts.outfit(
                          color: isDark ? Colors.white : Colors.black87)),
                  subtitle: Text(
                    'Level ${member.level ?? 1} • ${member.focusCompleted ?? 0} Sessions',
                    style: GoogleFonts.outfit(
                        color: isDark ? Colors.white70 : Colors.black54),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildSharedRoutinesSection(bool isDark) {
    return _buildCard(
      context,
      title: 'Shared Routines',
      icon: Icons.list_alt,
      isDark: isDark,
      child: Column(
        children: [
          if (_sharedRoutines.isEmpty)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('No shared routines yet.'),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _sharedRoutines.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final routine = _sharedRoutines[index];
                return ListTile(
                  title: Text(routine.name,
                      style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                  subtitle: Text('${routine.tasks.length} tasks'),
                  trailing: const Icon(Icons.download_rounded),
                  onTap: () {
                    // TODO: Implement "Apply Routine" logic locally
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Routine copied!')));
                  },
                );
              },
            ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _shareRoutine,
              icon: const Icon(Icons.add),
              label: const Text('Share My Routine'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(bool isDark, bool isAdmin) {
    return _buildCard(
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
              ),
            ),
          ),
          if (isAdmin) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _deleteHousehold,
                icon: const Icon(Icons.delete_forever_rounded),
                label: const Text('Delete Household'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                ),
              ),
            ),
          ],
        ],
      ),
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
    if (hour >= 5 && hour < 12) return const Color(0xFFE8F5F3);
    if (hour >= 12 && hour < 17) return const Color(0xFFFDF7E7);
    if (hour >= 17 && hour < 20) return const Color(0xFFE6EEF7);
    return const Color(0xFFE3E6EA);
  }
}
