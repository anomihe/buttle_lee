import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:ui';

class JournalSheet extends StatefulWidget {
  const JournalSheet({super.key});

  @override
  State<JournalSheet> createState() => _JournalSheetState();
}

class _JournalSheetState extends State<JournalSheet> {
  final _controller = TextEditingController();
  List<Map<String, dynamic>> _entries = [];
  bool _isViewMode = false;
  String? _editingId;

  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final hasText = _controller.text.trim().isNotEmpty;
      if (hasText != _hasText) {
        setState(() => _hasText = hasText);
      }
    });
    _loadEntries();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = prefs.getStringList('journal_entries') ?? [];
    setState(() {
      _entries = entriesJson
          .map((e) => Map<String, dynamic>.from(json.decode(e)))
          .toList()
          .reversed
          .toList(); // Newest first
    });
  }

  Future<void> _saveEntry() async {
    if (_controller.text.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final entriesJson = prefs.getStringList('journal_entries') ?? [];
    List<Map<String, dynamic>> loadedEntries = entriesJson
        .map((e) => Map<String, dynamic>.from(json.decode(e)))
        .toList();

    if (_editingId != null) {
      // Update existing
      final index = loadedEntries.indexWhere((e) {
        final id = e['id'];
        if (id != null) return id == _editingId;
        // Legacy fallback: check date if id is missing
        return e['date'] == _editingId;
      });

      if (index != -1) {
        loadedEntries[index]['text'] = _controller.text;
        // Ensure it has an ID now for future stability
        if (loadedEntries[index]['id'] == null) {
          loadedEntries[index]['id'] =
              _editingId; // Use the date as ID or gen new one
        }
      }
    } else {
      // Create new
      final entry = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'text': _controller.text,
        'date': DateTime.now().toIso8601String(),
      };
      loadedEntries.add(entry);
    }

    await prefs.setStringList(
        'journal_entries', loadedEntries.map((e) => json.encode(e)).toList());

    await _loadEntries(); // Refresh local list

    setState(() {
      _controller.clear();
      _editingId = null;
      _isViewMode = true; // Go to history to see change
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Journal entry saved! ✍️')),
      );
    }
  }

  void _editEntry(Map<String, dynamic> entry) {
    setState(() {
      _editingId = entry['id'] ??
          entry['date']; // Fallback to date if id missing (legacy)
      _controller.text = entry['text'];
      _isViewMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isViewMode) {
      return _buildHistoryView();
    }
    return _buildEntryView();
  }

  Widget _buildEntryView() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0D1B2A) : const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // Modern Top Bar with Solid Color & Glassmorphism
          Container(
            decoration: BoxDecoration(
              color: primaryColor,
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                    ),
                    child: Row(
                      children: [
                        // Title
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _editingId != null
                                    ? 'Edit Entry'
                                    : 'Daily Journal',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _editingId != null
                                    ? 'Update your thoughts'
                                    : 'Reflect on your day',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Cancel Button (when editing)
                        if (_editingId != null)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _editingId = null;
                                    _controller.clear();
                                  });
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        // History Button
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _isViewMode = true;
                              });
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1.5,
                                ),
                              ),
                              child: const Text(
                                'History',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Content Area
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                top: 24,
                left: 24,
                right: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _editingId != null
                        ? "Update your thoughts..."
                        : "What are you grateful for today?",
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.white60 : Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _controller,
                    maxLines: 8,
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    decoration: InputDecoration(
                      hintText: 'I am grateful for...',
                      hintStyle: TextStyle(
                        color: isDark
                            ? Colors.white.withOpacity(0.3)
                            : Colors.black.withOpacity(0.3),
                      ),
                      filled: true,
                      fillColor:
                          isDark ? const Color(0xFF1B2838) : Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark
                              ? Colors.white.withOpacity(0.1)
                              : Colors.grey.withOpacity(0.2),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark
                              ? Colors.white.withOpacity(0.1)
                              : Colors.grey.withOpacity(0.2),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: primaryColor,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _hasText ? _saveEntry : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        disabledBackgroundColor: Colors.grey.withOpacity(0.3),
                        foregroundColor: Colors.white,
                        disabledForegroundColor: Colors.white.withOpacity(0.5),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _editingId != null ? 'Update Entry' : 'Save Entry',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryView() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0D1B2A) : const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // Modern Top Bar
          Container(
            decoration: BoxDecoration(
              color: primaryColor,
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                    ),
                    child: Row(
                      children: [
                        // Back Button
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _isViewMode = false;
                                _editingId = null;
                                _controller.clear();
                              });
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1.5,
                                ),
                              ),
                              child: const Icon(
                                Icons.arrow_back_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Title
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Past Entries',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Your journal history',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
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

          // Entries List
          Expanded(
            child: _entries.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.edit_note_rounded,
                            size: 64,
                            color: primaryColor.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'No entries yet',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start journaling to see your entries here',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.white38 : Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _entries.length,
                    itemBuilder: (context, index) {
                      final item = _entries[index];
                      final date = DateTime.parse(item['date']);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color:
                              isDark ? const Color(0xFF1B2838) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${_getMonth(date.month)} ${date.day}, ${date.year} • ${_formatTime(date)}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark
                                          ? Colors.white54
                                          : Colors.black54,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () => _editEntry(item),
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: primaryColor.withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Icon(
                                          Icons.edit_rounded,
                                          size: 18,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                item['text'],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isDark ? Colors.white : Colors.black87,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String _getMonth(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return months[month - 1];
  }

  String _formatTime(DateTime date) {
    return "${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }
}
