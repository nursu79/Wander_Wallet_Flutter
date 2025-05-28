import 'package:flutter/material.dart';
import 'package:wander_wallet/core/constants/constants.dart';
import 'package:wander_wallet/core/models/success.dart';
import 'package:wander_wallet/core/widgets/buttons.dart';

class TripCard extends StatelessWidget {
  final Trip trip;
  const TripCard({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(12),
      child: Column(
        children: [
          (trip.imgUrl != null)
            ? Image.network('$baseUrl/tripImages/${trip.imgUrl}', height: 200, width: double.infinity, fit: BoxFit.fill)
            : Image.asset('images/default_tripimage.png'),
          
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(trip.name, style: Theme.of(context).textTheme.titleMedium),
                    Row(
                      spacing: 4,
                      children: [
                        Icon(Icons.location_on, color: Theme.of(context).colorScheme.primary),
                        Text(trip.destination, style: Theme.of(context).textTheme.labelLarge)
                      ],
                    ),
                  ],
                ),
                Text(trip.startDate.toIso8601String().split('T')[0], style: Theme.of(context).textTheme.labelMedium),
                SizedBox(height: 40),
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      RectangularButton(
                        fillWidth: true,
                        onPressed: () {
                          Navigator.of(context).pushNamed('/tripDetails', arguments: trip.id);
                        },
                        text: 'View Details'
                      )
                  ])
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}