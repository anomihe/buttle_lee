import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

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
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24, // extra padding
        top: 24,
        left: 24,
        right: 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.book_rounded, color: Colors.orange),
              const SizedBox(width: 8),
              Text(
                _editingId != null ? 'Edit Entry' : 'Daily Journal',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (_editingId != null)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _editingId = null;
                      _controller.clear();
                    });
                  },
                  child: const Text("Cancel"),
                ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isViewMode = true;
                  });
                },
                child: const Text("History"),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _editingId != null
                ? "Update your thoughts..."
                : "What are you grateful for today?",
            style: GoogleFonts.outfit(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'I am grateful for...',
              filled: true,
              fillColor: Theme.of(context).cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _hasText ? _saveEntry : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                disabledBackgroundColor: Colors.grey.withOpacity(0.3),
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.white.withOpacity(0.5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _editingId != null ? 'Update Entry' : 'Save Entry',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryView() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                BackButton(
                  onPressed: () {
                    setState(() {
                      _isViewMode = false;
                      _editingId = null;
                      _controller.clear();
                    });
                  },
                ),
                Text(
                  'Past Entries',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _entries.isEmpty
                ? Center(
                    child: Text("No entries yet.",
                        style: GoogleFonts.outfit(color: Colors.grey)))
                : ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    itemCount: _entries.length,
                    itemBuilder: (context, index) {
                      final item = _entries[index];
                      final date = DateTime.parse(item['date']);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${_getMonth(date.month)} ${date.day}, ${date.year} • ${_formatTime(date)}",
                                  style: GoogleFonts.outfit(
                                    fontSize: 12,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit_rounded,
                                      size: 16, color: Colors.blue),
                                  onPressed: () => _editEntry(item),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item['text'],
                              style: GoogleFonts.outfit(fontSize: 16),
                            ),
                          ],
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
