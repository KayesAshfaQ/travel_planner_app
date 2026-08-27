import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class PlacesService {
  final String _apiKey = 'AIzaSyDx9PR7FqVB_Ad9NLc8L1vmKJr2xqos-04';

  Future<String> fetchPlacesContext(
    String destination,
    List<String> interests,
  ) async {
    final hotels = await _fetchCategoryPlaces('hotel in $destination');
    final restaurants = await _fetchCategoryPlaces(
      'restaurant in $destination',
    );

    final interestQuery = interests.isNotEmpty
        ? interests.join(' or ')
        : 'tourist attractions';
    final attractions = await _fetchCategoryPlaces(
      'attractions for $interestQuery in $destination',
    );

    return '''
    Context for $destination:

    Hotels: 
    $hotels

    Restaurants: 
    $restaurants

    Attractions: 
    $attractions
    ''';
  }

  Future<String> _fetchCategoryPlaces(String query) async {
    // Get nearby places based on destination (city/region)
    final String placeUrl =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=${Uri.encodeComponent(query)}&radius=50000&key=$_apiKey';

    try {
      final response = await http.get(Uri.parse(placeUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'] ?? [];

        if (results.isNotEmpty) {
          // Take top 5 places
          final topPlaces = results.take(5).toList();

          // Build a string with place details
          final placesDescriptions = topPlaces
              .map((place) {
                final name = place['name'] ?? 'Unknown Place';
                final address = place['formatted_address'] ?? '';
                final types =
                    (place['types'] as List?)?.take(3).join(', ') ??
                    'Attraction';

                return 'Name: $name\nAddress: $address\nCategory: $types';
              })
              .join('\n\n');

          return placesDescriptions;
        } else {
          return 'No specific places found for $query.';
        }
      } else {
        debugPrint('Failed to load places: ${response.statusCode}');
        return 'No places found.';
      }
    } catch (e) {
      debugPrint('Error fetching places: $e');
      return 'No places found.';
    }
  }
}
