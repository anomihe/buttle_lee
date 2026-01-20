import 'package:my_butler_client/my_butler_client.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/persona_provider.dart';
import '../../providers/reminder_provider.dart';
import '../../widgets/omni_bar.dart';
import '../../widgets/reminder_card.dart';
import '../../widgets/ai_chat_widget.dart';
import '../../widgets/daily_quote_widget.dart';
import '../../widgets/productivity_ring.dart';
import '../../widgets/smart_chips_widget.dart';
import '../../widgets/hydration_tracker_widget.dart';
import '../../screens/focus_mode_screen.dart';
import '../completed_reminders_screen.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/morning_briefing_sheet.dart';
import '../../widgets/level_progress_widget.dart';
import '../../screens/household_screen.dart';
import '../../widgets/insights_card.dart';

import '../../screens/settings_tab.dart';
import '../../widgets/reading_tracker_sheet.dart';
import '../../widgets/journal_sheet.dart';

import 'package:google_fonts/google_fonts.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _greetingController;
  late Animation<double> _greetingAnimation;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load reminders when dashboard opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReminderProvider>().loadReminders();
      _checkAndShowBriefing();
    });

    // Greeting animation
    _greetingController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    _greetingAnimation = CurvedAnimation(
      parent: _greetingController,
      curve: Curves.easeOutBack,
    );
    _greetingController.forward();
  }

  final GlobalKey<OmniBarState> _omniBarKey = GlobalKey<OmniBarState>();
  final GlobalKey<HydrationTrackerWidgetState> _hydrationKey =
      GlobalKey<HydrationTrackerWidgetState>();

  @override
  void dispose() {
    _greetingController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  late ConfettiController _confettiController;

  Future<void> _checkAndShowBriefing() async {
    final prefs = await SharedPreferences.getInstance();
    final lastDateStr = prefs.getString('last_briefing_date');
    final now = DateTime.now();
    final todayStr = '${now.year}-${now.month}-${now.day}';

    if (lastDateStr != todayStr) {
      // It's a new day! Show briefing.
      if (mounted) {
        // Wait a beat for animations to settle
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (context) => const MorningBriefingSheet(),
          );
          // Update last briefing date
          await prefs.setString('last_briefing_date', todayStr);
        }
      }
    }
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  String _getGreetingEmoji() {
    final hour = DateTime.now().hour;
    if (hour < 12) return '☀️';
    if (hour < 17) return '🌤️';
    return '🌙';
  }

  Color _getBackgroundColor(bool isDark) {
    if (isDark) {
      return const Color(0xFF0D2137);
    }

    final hour = DateTime.now().hour;

    // Morning (5 - 11): Golden Hour / Fresh Start
    if (hour >= 5 && hour < 11) {
      return const Color(0xFFE8F5F3); // Fade to teal-ish white
    }
    // Day (11 - 16): Productive Blue/White
    else if (hour >= 11 && hour < 16) {
      return const Color(0xFFF5F9F8); // White
    }
    // Evening (16 - 20): Sunset vibes
    else if (hour >= 16 && hour < 20) {
      return const Color(0xFFF3E5F5); // Light purple
    }
    // Night (20 - 5): Deep Work / Calm
    else {
      return const Color(0xFF1A237E); // Deep indigo
    }
  }

  void _showAiChatBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: AiChatWidget(
          onReminderCreated: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: _getBackgroundColor(isDark),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildDashboardTab(context),
            const JournalSheet(),
            const ReadingTrackerSheet(),
            const HouseholdScreen(),
            const SettingsTab(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          height: 65,
          elevation: 0,
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
            // Refresh hydration data when returning to dashboard
            if (index == 0) {
              _hydrationKey.currentState?.loadData();
            }
          },
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard_rounded),
              label: 'My Day',
            ),
            NavigationDestination(
              icon: Icon(Icons.edit_note_outlined),
              selectedIcon: Icon(Icons.edit_note_rounded),
              label: 'Journal',
            ),
            NavigationDestination(
              icon: Icon(Icons.auto_stories_outlined),
              selectedIcon: Icon(Icons.auto_stories_rounded),
              label: 'Read',
            ),
            NavigationDestination(
              icon: Icon(Icons.groups_outlined),
              selectedIcon: Icon(Icons.groups_rounded),
              label: 'Team',
            ),
            NavigationDestination(
              icon: Icon(Icons.tune_outlined),
              selectedIcon: Icon(Icons.tune_rounded),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardTab(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final personaProvider = context.watch<PersonaProvider>();
    final reminderProvider = context.watch<ReminderProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userProfile = authProvider.userProfile;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: _getBackgroundColor(isDark),
            child: CustomScrollView(
              slivers: [
                // Pinned App Bar with Name
                SliverAppBar(
                  pinned: true,
                  elevation: 0,
                  backgroundColor: isDark
                      ? const Color(0xFF0D2137).withOpacity(0.95)
                      : const Color(0xFFE8F5F3).withOpacity(0.95),
                  expandedHeight: 0,
                  toolbarHeight: 60,
                  flexibleSpace: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  title: Row(
                    children: [
                      // Small avatar
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.2),
                        child: userProfile?.profileImageUrl != null
                            ? ClipOval(
                                child: Image.network(
                                  userProfile!.profileImageUrl!,
                                  fit: BoxFit.cover,
                                  width: 36,
                                  height: 36,
                                  errorBuilder: (_, __, ___) => Icon(
                                    Icons.person_rounded,
                                    size: 18,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              )
                            : Icon(
                                Icons.person_rounded,
                                size: 18,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                      ),
                      const SizedBox(width: 12),
                      // Name
                      Expanded(
                        child: Text(
                          userProfile?.fullName ?? 'User',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Mode chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              personaProvider.modeIcon,
                              size: 14,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              personaProvider.modeDisplayName,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    // Energy Mode Toggle
                    Consumer<ReminderProvider>(
                      builder: (context, provider, _) {
                        return Material(
                          // Wrap with Material for InkWell
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              provider.toggleEnergyMode();

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    provider.isLowEnergyMode
                                        ? "Leaf Mode 🍃: Showing quick wins only."
                                        : "Power Mode ⚡️: Showing all tasks.",
                                  ),
                                  duration: const Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: provider.isLowEnergyMode
                                      ? Colors.green[800]
                                      : null,
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white.withOpacity(0.1)
                                    : Colors.white.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                ),
                              ),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: Icon(
                                  provider.isLowEnergyMode
                                      ? Icons.battery_saver_rounded
                                      : Icons.battery_full_rounded,
                                  key: ValueKey(provider.isLowEnergyMode),
                                  size: 20,
                                  color: provider.isLowEnergyMode
                                      ? Colors.green
                                      : (isDark
                                          ? Colors.white70
                                          : Colors.black54),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 16),
                  ],
                ),

                // Full Greeting Card (scrolls away)

                // Header with glassmorphism
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ScaleTransition(
                      scale: _greetingAnimation,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.8),
                                  Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withOpacity(0.6),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Profile Avatar with ring
                                Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.white.withOpacity(0.8),
                                        Colors.white.withOpacity(0.4),
                                      ],
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 32,
                                    backgroundColor:
                                        Colors.white.withOpacity(0.2),
                                    child: userProfile?.profileImageUrl != null
                                        ? ClipOval(
                                            child: Image.network(
                                              userProfile!.profileImageUrl!,
                                              fit: BoxFit.cover,
                                              width: 64,
                                              height: 64,
                                              errorBuilder: (_, __, ___) =>
                                                  const Icon(
                                                Icons.person_rounded,
                                                size: 32,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        : const Icon(
                                            Icons.person_rounded,
                                            size: 32,
                                            color: Colors.white,
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                // Greeting
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            _getGreeting(),
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.white70,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            _getGreetingEmoji(),
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        userProfile?.fullName ?? 'User',
                                        style: const TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                      if (userProfile != null) ...[
                                        const SizedBox(height: 8),
                                        LevelProgressWidget(
                                          xp: userProfile.xp ?? 0,
                                          level: userProfile.level ?? 1,
                                          isDark:
                                              false, // Card text is white, so treat as dark/light appropriately? Widget handles it.
                                          // Actually widget uses "isDark" for styling. The card background is colored/dark-ish.
                                          // Let's pass 'true' to force white text/elements which looks good on colored bg.
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Daily Quote
                const SliverToBoxAdapter(
                  child: DailyQuoteWidget(),
                ),

                // Hydration Tracker
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: HydrationTrackerWidget(key: _hydrationKey),
                  ),
                ),

                // Omni-Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: OmniBar(key: _omniBarKey),
                  ),
                ),

                // Smart Chips
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: SmartChipsWidget(
                      onActionSelected: (command) {
                        if (command == 'Start my morning routine') {
                          // 1. Morning Routine
                          _handleMorningRoutine(context, reminderProvider);
                        } else if (command == 'Log water intake') {
                          // 2. Water
                          _handleWaterLog(context);
                        } else {
                          // Default
                          _omniBarKey.currentState?.submitCommand(command);
                        }
                      },
                      onFocusSelected: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const FocusModeScreen(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              return FadeTransition(
                                  opacity: animation, child: child);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Insights Card
                SliverToBoxAdapter(
                  child: InsightsCard(isDark: isDark),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),

                // Reminders Section Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.notifications_active_rounded,
                                size: 16,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Active Reminders',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 13,
                                ),
                              ),
                              if (reminderProvider.reminders.isNotEmpty ||
                                  reminderProvider.dailyProductivityScore >
                                      0) ...[
                                const SizedBox(width: 8),
                                ProductivityRing(
                                  progress:
                                      reminderProvider.dailyProductivityScore,
                                  size: 28,
                                  strokeWidth: 3,
                                ),
                              ],
                            ],
                          ),
                        ),
                        const Spacer(),
                        // Completed reminders button
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const CompletedRemindersScreen(),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white.withOpacity(0.1)
                                    : Colors.grey.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.history_rounded,
                                size: 20,
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Refresh button
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => reminderProvider.loadReminders(),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white.withOpacity(0.1)
                                    : Colors.grey.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.refresh_rounded,
                                size: 20,
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),

                // Reminders List
                reminderProvider.isLoading
                    ? SliverFillRemaining(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      )
                    : reminderProvider.reminders.isEmpty
                        ? SliverFillRemaining(
                            child: _buildEmptyState(context, isDark),
                          )
                        : SliverPadding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final reminder =
                                      reminderProvider.reminders[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: ReminderCard(
                                      reminder: reminder,
                                      onDelete: () => reminderProvider
                                          .deleteReminder(reminder.id!),
                                      onComplete: () async {
                                        _confettiController.play();
                                        HapticFeedback.mediumImpact();
                                        // Delay deletion slightly to let confetti start
                                        await Future.delayed(
                                            const Duration(milliseconds: 500));

                                        await reminderProvider
                                            .deleteReminder(reminder.id!);

                                        if (context.mounted) {
                                          // Refresh gamification stats
                                          context
                                              .read<AuthProvider>()
                                              .loadUserProfile();
                                        }
                                      },
                                    )
                                        .animate(
                                          delay: (100 * index).ms,
                                        )
                                        .fadeIn(duration: 400.ms)
                                        .slideX(begin: 0.1, end: 0),
                                  );
                                },
                                childCount: reminderProvider.reminders.length,
                              ),
                            ),
                          ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.tertiary,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: _showAiChatBottomSheet,
          tooltip: 'AI Chat',
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.chat_rounded, color: Colors.white),
        ),
      ),
    );
  }

  void _showPersonaMenu(BuildContext context, PersonaProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Choose Your Mode',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildModeOption(
              context,
              PersonaMode.student,
              Icons.school_rounded,
              'Student',
              'Focus on studies & assignments',
              provider,
            ),
            _buildModeOption(
              context,
              PersonaMode.worker,
              Icons.work_rounded,
              'Worker',
              'Manage work tasks & meetings',
              provider,
            ),
            _buildModeOption(
              context,
              PersonaMode.personal,
              Icons.home_rounded,
              'Personal',
              'Personal life & hobbies',
              provider,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildModeOption(
    BuildContext context,
    PersonaMode mode,
    IconData icon,
    String title,
    String subtitle,
    PersonaProvider provider,
  ) {
    final isSelected = provider.currentMode == mode;
    return ListTile(
      onTap: () {
        provider.setMode(mode);
        Navigator.pop(context);
      },
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color:
              isSelected ? Colors.white : Theme.of(context).colorScheme.primary,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: isSelected
          ? Icon(
              Icons.check_circle_rounded,
              color: Theme.of(context).colorScheme.primary,
            )
          : null,
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.grey.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              size: 48,
              color: isDark ? Colors.white30 : Colors.grey[400],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No active reminders',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Use the Omni-Bar to create one!',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white38 : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _handleMorningRoutine(BuildContext context, ReminderProvider provider) {
    final now = DateTime.now();
    final morningTasks = [
      'Make the bed 🛏️',
      'Drink water 💧',
      'Stretch / Light Exercise 🧘',
      'Plan the day 🗓️'
    ];

    for (var i = 0; i < morningTasks.length; i++) {
      provider.createReminder(
        description: morningTasks[i],
        triggerTime: now.add(Duration(minutes: 5 + (i * 2))),
        reminderType: ReminderType.once,
        priority: Priority.high,
      );
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Morning routine added! ☀️'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
    _confettiController.play();
  }

  void _handleWaterLog(BuildContext context) {
    _hydrationKey.currentState?.addWater();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Hydrated! 💧 +1 Water Logged'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 1),
      ),
    );
    _confettiController.play();
  }
}
