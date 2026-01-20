import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:my_butler_client/my_butler_client.dart';
import '../providers/auth_provider.dart';
import 'household_detail_screen.dart';

class HouseholdScreen extends StatefulWidget {
  const HouseholdScreen({super.key});

  @override
  State<HouseholdScreen> createState() => _HouseholdScreenState();
}

class _HouseholdScreenState extends State<HouseholdScreen> {
  bool _isLoading = true;
  List<Household> _households = [];

  // Create/Join inputs
  final _createController = TextEditingController();
  final _joinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadHouseholds();
  }

  Future<void> _loadHouseholds() async {
    setState(() => _isLoading = true);
    try {
      final client = context.read<AuthProvider>().client;
      final households = await client.household.getMyHouseholds();
      _households = households;
    } catch (e) {
      debugPrint('Error loading households: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _createHousehold() async {
    final name = _createController.text.trim();
    if (name.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final client = context.read<AuthProvider>().client;
      final household = await client.household.createHousehold(name);
      if (household != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Household "${household.name}" created!')));
          _createController.clear();
        }
        await _loadHouseholds();
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _joinHousehold() async {
    final code = _joinController.text.trim();
    if (code.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final client = context.read<AuthProvider>().client;
      final success = await client.household.joinHousehold(code);
      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Joined household successfully!')));
          _joinController.clear();
        }
        await _loadHouseholds();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Could not join household. Check code.')));
        }
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('Shared Spaces',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    'My Households',
                    style: GoogleFonts.outfit(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF1A1C1E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Collaborate with family or roommates.',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Create New
                  _buildCard(
                    context,
                    title: 'Create New',
                    icon: Icons.add_home_rounded,
                    isDark: isDark,
                    child: Column(
                      children: [
                        TextField(
                          controller: _createController,
                          style: GoogleFonts.outfit(
                              color: isDark ? Colors.white : Colors.black87),
                          decoration: InputDecoration(
                            labelText: 'Household Name',
                            hintText: 'e.g. The Wayne Manor',
                            labelStyle: GoogleFonts.outfit(
                                color:
                                    isDark ? Colors.white70 : Colors.black54),
                            hintStyle: GoogleFonts.outfit(
                                color:
                                    isDark ? Colors.white38 : Colors.black38),
                            filled: true,
                            fillColor: isDark
                                ? Colors.white.withOpacity(0.05)
                                : Colors.grey.withOpacity(0.05),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _createHousehold,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Create',
                              style: GoogleFonts.outfit(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Join Existing
                  _buildCard(
                    context,
                    title: 'Join Existing',
                    icon: Icons.person_add_rounded,
                    isDark: isDark,
                    child: Column(
                      children: [
                        TextField(
                          controller: _joinController,
                          style: GoogleFonts.outfit(
                              color: isDark ? Colors.white : Colors.black87),
                          decoration: InputDecoration(
                            labelText: 'Join Code',
                            hintText: 'e.g. A1B2C3',
                            labelStyle: GoogleFonts.outfit(
                                color:
                                    isDark ? Colors.white70 : Colors.black54),
                            hintStyle: GoogleFonts.outfit(
                                color:
                                    isDark ? Colors.white38 : Colors.black38),
                            filled: true,
                            fillColor: isDark
                                ? Colors.white.withOpacity(0.05)
                                : Colors.grey.withOpacity(0.05),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _joinHousehold,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Join',
                              style: GoogleFonts.outfit(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  if (_households.isNotEmpty) ...[
                    Text('Your Teams',
                        style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87)),
                    const SizedBox(height: 16),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _households.length,
                        itemBuilder: (context, index) {
                          final household = _households[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            color: isDark
                                ? Colors.white.withOpacity(0.05)
                                : Colors.white,
                            child: ListTile(
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HouseholdDetailScreen(
                                        household: household),
                                  ),
                                );
                                if (result == true) {
                                  _loadHouseholds();
                                }
                              },
                              leading: CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                child:
                                    const Icon(Icons.home, color: Colors.white),
                              ),
                              title: Text(household.name,
                                  style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.bold,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black87)),
                              subtitle: Text('Code: ${household.joinCode}',
                                  style: GoogleFonts.outfit(
                                      color: isDark
                                          ? Colors.white70
                                          : Colors.black54)),
                              trailing: Icon(Icons.arrow_forward_ios_rounded,
                                  size: 16,
                                  color:
                                      isDark ? Colors.white54 : Colors.black45),
                            ),
                          );
                        })
                  ]
                ],
              ),
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
}
