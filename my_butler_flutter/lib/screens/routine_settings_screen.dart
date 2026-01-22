import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/routine_service.dart';

class RoutineSettingsScreen extends StatefulWidget {
  const RoutineSettingsScreen({super.key});

  @override
  State<RoutineSettingsScreen> createState() => _RoutineSettingsScreenState();
}

class _RoutineSettingsScreenState extends State<RoutineSettingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final RoutineService _service = RoutineService();

  // Cache lists
  List<String> _morningTasks = [];
  List<String> _afternoonTasks = [];
  List<String> _eveningTasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadRoutines();
  }

  Future<void> _loadRoutines() async {
    setState(() => _isLoading = true);
    _morningTasks = await _service.getRoutine(RoutineType.morning);
    _afternoonTasks = await _service.getRoutine(RoutineType.afternoon);
    _eveningTasks = await _service.getRoutine(RoutineType.evening);
    if (mounted) setState(() => _isLoading = false);
  }

  // Consistent background logic
  Color _getBackgroundColor(bool isDark) {
    if (isDark) return const Color(0xFF0D2137);
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 11)
      return const Color(0xFFE8F5F3);
    else if (hour >= 11 && hour < 16)
      return const Color(0xFFF5F9F8);
    else if (hour >= 16 && hour < 20)
      return const Color(0xFFF3E5F5);
    else
      return const Color(0xFF1A237E);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: _getBackgroundColor(isDark),
      appBar: AppBar(
        title: Text(
          'Manage Routines',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded,
              color: isDark ? Colors.white : Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Segmented Tab Bar Container
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  height: 48,
                  decoration: BoxDecoration(
                    color:
                        isDark ? Colors.white10 : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Theme.of(context).colorScheme.primary,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    unselectedLabelColor:
                        isDark ? Colors.white54 : Colors.grey[700],
                    labelStyle: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold, fontSize: 13),
                    dividerColor: Colors.transparent,
                    padding: const EdgeInsets.all(4),
                    tabs: const [
                      Tab(text: 'Morning ☀️'),
                      Tab(text: 'Afternoon 🌤️'),
                      Tab(text: 'Evening 🌙'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildRoutineList(RoutineType.morning, _morningTasks),
                      _buildRoutineList(RoutineType.afternoon, _afternoonTasks),
                      _buildRoutineList(RoutineType.evening, _eveningTasks),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildRoutineList(RoutineType type, List<String> tasks) {
    if (tasks.isEmpty) {
      return Center(
        child: TextButton.icon(
          onPressed: () => _showAddItemDialog(type),
          icon: const Icon(Icons.add_rounded),
          label: const Text('Start adding tasks'),
        ),
      );
    }

    return ReorderableListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      itemCount: tasks.length + 1,
      onReorder: (oldIndex, newIndex) => _onReorder(type, oldIndex, newIndex),
      proxyDecorator: (child, index, animation) {
        return Material(
          elevation: 8,
          color: Colors.transparent,
          child: child,
        );
      },
      itemBuilder: (context, index) {
        if (index == tasks.length) {
          // Add Task Button at bottom
          return Padding(
            key: const ValueKey('add_button'),
            padding: const EdgeInsets.only(top: 24),
            child: Center(
              child: TextButton.icon(
                onPressed: () => _showAddItemDialog(type),
                icon: const Icon(Icons.add_rounded),
                label: Text(
                  'Add Task',
                  style: GoogleFonts.outfit(fontSize: 16),
                ),
              ),
            ),
          );
        }

        final rawTask = tasks[index];
        final parts = rawTask.split('|');
        final time = parts.length > 1 ? parts[0] : null;
        final taskText = parts.length > 1 ? parts[1] : rawTask;

        return Card(
          key: ValueKey('${type.name}_$index'),
          elevation: 0,
          color: Theme.of(context).cardColor.withOpacity(0.7),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: GestureDetector(
              onTap: () => _showTimePicker(type, index, time),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  time ?? 'Set Time',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            title: Text(
              taskText,
              style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.close_rounded,
                      size: 20, color: Colors.grey),
                  onPressed: () => _removeItem(type, index),
                ),
                const Icon(Icons.drag_handle_rounded, color: Colors.grey),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _onReorder(RoutineType type, int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex -= 1;
    final tasks = _getTasksForType(type);

    // Check bounds (don't move the add button)
    if (oldIndex >= tasks.length || newIndex >= tasks.length) return;

    setState(() {
      final item = tasks.removeAt(oldIndex);
      tasks.insert(newIndex, item);
    });
    await _service.saveRoutine(type, tasks);
  }

  Future<void> _showTimePicker(
      RoutineType type, int index, String? currentTime) async {
    TimeOfDay initial = TimeOfDay.now();
    if (currentTime != null && currentTime.contains(':')) {
      final p = currentTime.split(':');
      initial = TimeOfDay(hour: int.parse(p[0]), minute: int.parse(p[1]));
    }

    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked != null) {
      final tasks = _getTasksForType(type);
      final currentTask = tasks[index];
      // strip old time if present
      final text =
          currentTask.contains('|') ? currentTask.split('|')[1] : currentTask;

      final formattedTime =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      final newTask = '$formattedTime|$text';

      setState(() {
        tasks[index] = newTask;
      });
      await _service.saveRoutine(type, tasks);
    }
  }

  Future<void> _removeItem(RoutineType type, int index) async {
    final tasks = _getTasksForType(type);
    setState(() {
      tasks.removeAt(index);
    });
    await _service.saveRoutine(type, tasks);
  }

  Future<void> _showAddItemDialog(RoutineType type) async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Add Task',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'e.g. Drink water',
            filled: true,
            fillColor: Colors.grey.withOpacity(0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child:
                Text('Cancel', style: GoogleFonts.outfit(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                final tasks = _getTasksForType(type);
                setState(() {
                  tasks.add(controller.text);
                });
                await _service.saveRoutine(type, tasks);
              }
              if (context.mounted) Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Add',
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  List<String> _getTasksForType(RoutineType type) {
    switch (type) {
      case RoutineType.morning:
        return _morningTasks;
      case RoutineType.afternoon:
        return _afternoonTasks;
      case RoutineType.evening:
        return _eveningTasks;
    }
  }
}
