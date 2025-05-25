import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wander_wallet/core/models/misc.dart';
import 'package:wander_wallet/core/widgets/trip_card.dart';
import 'package:wander_wallet/features/trips/presentation/providers/trips_provider.dart';

class TripsScreen extends ConsumerStatefulWidget {
  const TripsScreen({ super.key });

  @override
  ConsumerState<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends ConsumerState<TripsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: TabType.values.length,
      initialIndex: 1,
      vsync: this
    );

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        ref.read(tripsProvider.notifier).getTrips(TabType.values[_tabController.index]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: TabType.values.map((type) => Tab(text: type.name.toUpperCase())).toList(),
          labelColor: Theme.of(context).colorScheme.primary,
          labelStyle: Theme.of(context).textTheme.bodyMedium,
          unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
          unselectedLabelStyle: Theme.of(context).textTheme.bodyMedium,
        ),
        Expanded(
          child:  Consumer(
            builder: (context, ref, child) {
              final asyncVal = ref.watch(tripsProvider);

              return asyncVal.when(
                data: (items) {
                  final trips = (items as TripsSuccess).trips.trips;

                  if (trips.isEmpty) {
                    return const Center(child: Text('No items found.'));
                  }
                  return ListView.builder(
                    itemCount: trips.length,
                    itemBuilder: (context, index) {
                      return TripCard(trip: trips[index]);
                    },
                  );
                },
                error: (err, stack) => Center(child: Text((err is TripsError) ? err.messageError.message : err.toString())),
                loading: () => Center(child: CircularProgressIndicator())
              );
            },
          ),
        )
      ],
    );
  }
}
