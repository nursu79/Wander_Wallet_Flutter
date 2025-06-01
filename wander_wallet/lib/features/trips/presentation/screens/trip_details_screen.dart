import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wander_wallet/core/widgets/buttons.dart';
import 'package:wander_wallet/core/widgets/trip_budget_info.dart';
import 'package:wander_wallet/core/widgets/trip_expenses_section.dart';
import 'package:wander_wallet/features/trips/presentation/providers/trip_details_provider.dart';

class TripDetailsScreen extends ConsumerStatefulWidget {
  final String id;

  const TripDetailsScreen({ super.key, required this.id });
  @override
  ConsumerState<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends ConsumerState<TripDetailsScreen> {
  @override
  void initState() {
    super.initState();

    ref.listenManual(tripDetailsProvider(widget.id), (prev, next) {
      next.when(
        data: (data) {
          if (data is TripDetailsDeleteSuccess) {
            Navigator.pushNamed(context, '/trips');
          }
        },
        loading: () {},
        error: (error, stack) {
          if (error is TripDetailsError && error.loggedOut) {
            Navigator.pushNamed(context, '/login');
          }
        }
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final asyncValue = ref.watch(tripDetailsProvider(widget.id));

    return asyncValue.when(
        data: (data) {
          if (data is TripDetailsDeleteSuccess) {
            return Center(
              child: Text('Trip deleted successfully!'),
            );
          } else {
            final tripPayload = (data as TripDetailsSuccess).tripPayload;

            return Scaffold( 
              body: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  spacing: 28,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TripBudgetInfo(budget: tripPayload.trip.budget, expenditure: tripPayload.totalExpenditure!),
                    Row(
                      spacing: 16,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RectangularButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/editTrip', arguments: tripPayload.trip.id);
                          },
                          text: 'Edit',
                        ),
                        RectangularButton(
                          color: Theme.of(context).colorScheme.error,
                          textColor: Theme.of(context).colorScheme.onError,
                          onPressed: () {
                            ref.read(tripDetailsProvider(widget.id).notifier).deleteTrip();
                          },
                          text: 'Delete',
                        )
                      ],
                    ),
                    TripExpensesSection(trip: tripPayload.trip, categories: tripPayload.expensesByCategory!),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/createExpense');
                },
                shape: CircleBorder(),
                child: const Icon(Icons.add)
              ),
            );
          }
        },
        error: (err, stack) {
          return Center(
            child: Column(
              spacing: 16,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text((err as TripDetailsError).error.message),
                RectangularButton(
                  onPressed: () {
                    ref.read(tripDetailsProvider(widget.id).notifier).refresh();
                  },
                  text: 'Retry',
                )
              ],
            ),
          );
        },
        loading: () => Center(child: CircularProgressIndicator(),)
    );
  }
}
