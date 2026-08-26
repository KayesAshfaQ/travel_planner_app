import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travel_planner_app/models/daily_itenary.dart';
import '../../models/trip_plan.dart';

class TripDetailsScreen extends StatelessWidget {
  final TripPlan trip;

  const TripDetailsScreen({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(trip.destination)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 0,
              color: theme.colorScheme.primaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Dates', style: theme.textTheme.labelLarge),
                            const SizedBox(height: 4),
                            Text(
                              '${DateFormat.yMMMd().format(trip.startDate)} - ${DateFormat.yMMMd().format(trip.endDate)}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Budget', style: theme.textTheme.labelLarge),
                            const SizedBox(height: 4),
                            Text(
                              trip.budget,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    Divider(height: 16, color: Colors.grey),

                    if (trip.interests.isNotEmpty)
                      SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Interests',
                              style: theme.textTheme.labelLarge,
                            ),
                            const SizedBox(height: 4),
                            Wrap(
                              children: trip.interests
                                  .map(
                                    (interest) => Chip(
                                      label: Text(interest),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'AI Generated Itinerary',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            StructuredItinerary(itinerary: trip.itinerary),
          ],
        ),
      ),
    );
  }
}

class StructuredItinerary extends StatelessWidget {
  final List<DailyItenary> itinerary;

  const StructuredItinerary({super.key, required this.itinerary});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: itinerary.length,
      itemBuilder: (context, index) {
        final dailyItenary = itinerary[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Day ${dailyItenary.dayNumber}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildSection(
                    context,
                    icon: Icons.sunny,
                    title: 'Morning',
                    content: dailyItenary.morningActivity,
                  ),
                  _buildSection(
                    context,
                    icon: Icons.wb_sunny,
                    title: 'Afternoon',
                    content: dailyItenary.afternoonActivity,
                  ),
                  _buildSection(
                    context,
                    icon: Icons.sunny,
                    title: 'Evening',
                    content: dailyItenary.eveningActivity,
                  ),
                  if (dailyItenary.diningSuggestions.isNotEmpty)
                    _buildSection(
                      context,
                      icon: Icons.food_bank,
                      title: 'Dining Suggestions',
                      content: dailyItenary.diningSuggestions,
                    ),
                  if (dailyItenary.tips.isNotEmpty)
                    _buildSection(
                      context,
                      icon: Icons.light,
                      title: 'Tips',
                      content: dailyItenary.tips,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18),
              const SizedBox(width: 4),
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(content, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
