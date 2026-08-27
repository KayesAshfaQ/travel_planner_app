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
    final String placeUrl = 'https://places.googleapis.com/v1/places:searchText';

    try {
      final response = await http.post(
        Uri.parse(placeUrl),
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-Api-Key': _apiKey,
          'X-Goog-FieldMask': 'places.displayName,places.formattedAddress,places.types',
        },
        body: json.encode({
          'textQuery': query,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> places = data['places'] ?? [];

        if (places.isNotEmpty) {
          // Take top 5 places
          final topPlaces = places.take(2).toList();

          // Build a string with place details
          final placesDescriptions = topPlaces
              .map((place) {
                final displayNameObj = place['displayName'] as Map<String, dynamic>?;
                final name = displayNameObj != null ? displayNameObj['text'] ?? 'Unknown Place' : 'Unknown Place';
                final address = place['formattedAddress'] ?? '';
                final types = (place['types'] as List?)?.take(3).join(', ') ?? 'Attraction';

                return 'Name: $name\nAddress: $address\nCategory: $types';
              })
              .join('\n\n');

          return placesDescriptions;
        } else {
          return 'No specific places found for $query.';
        }
      } else {
        debugPrint('Failed to load places: ${response.statusCode} - ${response.body}');
        return 'No places found.';
      }
    } catch (e) {
      debugPrint('Error fetching places: $e');
      return 'No places found.';
    }
  }
}
