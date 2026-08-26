import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../providers/travel_planner_provider.dart';
import 'trip_details_screen.dart';

class PlanTripScreen extends StatefulWidget {
  const PlanTripScreen({super.key});

  @override
  State<PlanTripScreen> createState() => _PlanTripScreenState();
}

class _PlanTripScreenState extends State<PlanTripScreen> {
  final _destinationController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  String _selectedBudget = 'Moderate';
  List<String> _selectedInterests = [];

  final _budgetOptions = ['Budget', 'Moderate', 'Luxury'];
  final _availableInterests = [
    'Food',
    'Culture',
    'History',
    'Nature',
    'Adventure',
    'Relaxation',
    'Shopping',
    'Hiking',
    'Beaches',
    'Nightlife',
    'Family-friendly',
    'Sightseeing',
  ];

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  void _toggleInterest(String interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else {
        _selectedInterests.add(interest);
      }
    });
  }

  void _generateTrip() async {
    if (_destinationController.text.isEmpty ||
        _startDate == null ||
        _endDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    final user = context.read<AuthProvider>().user;
    if (user == null) return;

    final plannerProvider = context.read<TravelPlannerProvider>();

    final plan = await plannerProvider.generateAndSaveTrip(
      user.uid,
      destination: _destinationController.text,
      startDate: _startDate!,
      endDate: _endDate!,
      budget: _selectedBudget,
      interests: _selectedInterests,
    );

    if (mounted) {
      if (plan != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => TripDetailsScreen(trip: plan)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to generate trip plan.')),
        );
      }
    }
  }

  @override
  void dispose() {
    _destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isGenerating = Provider.of<TravelPlannerProvider>(
      context,
    ).isGenerating;

    return Scaffold(
      appBar: AppBar(title: const Text('Plan a Trip')),
      body: isGenerating
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'AI is crafting your perfect itinerary...',
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Where do you want to go?',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _destinationController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'e.g. Paris, Tokyo, Bali',
                      prefixIcon: Icon(Icons.location_on),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'When are you travelling?',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: theme.colorScheme.outline),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    leading: const Icon(Icons.date_range),
                    title: Text(
                      _startDate != null && _endDate != null
                          ? '${DateFormat.yMMMd().format(_startDate!)} - ${DateFormat.yMMMd().format(_endDate!)}'
                          : 'Select Dates',
                    ),
                    onTap: () => _selectDateRange(context),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'What is your budget?',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedBudget,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.account_balance_wallet),
                    ),
                    items: _budgetOptions.map((budget) {
                      return DropdownMenuItem(
                        value: budget,
                        child: Text(budget),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedBudget = val);
                    },
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'What are your interests?',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availableInterests.map((interest) {
                      final isSelected = _selectedInterests.contains(interest);
                      return FilterChip(
                        label: Text(interest),
                        selected: isSelected,
                        onSelected: (_) => _toggleInterest(interest),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _generateTrip,
                      icon: const Icon(Icons.auto_awesome),
                      label: const Text('Generate Itinerary with AI'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
