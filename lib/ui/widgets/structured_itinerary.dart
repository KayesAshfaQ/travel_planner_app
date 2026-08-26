import 'package:flutter/material.dart';
import 'package:travel_planner_app/models/daily_itenary.dart';

class StructuredItinerary extends StatelessWidget {
  final List<DailyItenary> itinerary;

  const StructuredItinerary({super.key, required this.itinerary});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
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
            child: ExpansionTile(
              title: Text(
                'Day ${dailyItenary.dayNumber}: ${dailyItenary.title}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              childrenPadding: const EdgeInsets.only(bottom: 16),
              clipBehavior: Clip.antiAlias,
              children: [
                if (dailyItenary.morningActivity.isNotEmpty)
                  _buildSection(
                    context,
                    icon: Icons.sunny,
                    title: 'Morning',
                    content: dailyItenary.morningActivity,
                  ),
                if (dailyItenary.afternoonActivity.isNotEmpty)
                  _buildSection(
                    context,
                    icon: Icons.wb_sunny,
                    title: 'Afternoon',
                    content: dailyItenary.afternoonActivity,
                  ),
                if (dailyItenary.eveningActivity.isNotEmpty)
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
