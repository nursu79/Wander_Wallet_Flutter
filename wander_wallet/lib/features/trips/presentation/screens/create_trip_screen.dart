import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wander_wallet/core/di/providers.dart';
import 'package:wander_wallet/core/widgets/buttons.dart';
import 'package:wander_wallet/features/trips/presentation/providers/create_trip_provider.dart';

class CreateTripScreen extends ConsumerStatefulWidget {
  const CreateTripScreen({super.key});

  @override
  ConsumerState<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends ConsumerState<CreateTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _destinationController = TextEditingController();
  final _budgetController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  File? _tripImage;
  final imagePicker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _destinationController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _tripImage = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    ref.listenManual(createTripProvider, (prev, next) {
      next.whenData((data) {
        if (data is CreateTripSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Trip "${data.tripPayload.trip.name}" created successfully!')),
          );
          Navigator.pushNamed(context, '/tripDetails', arguments: data.tripPayload.trip.id);
        } else if (data is CreateTripError && (data.error.message != null)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error creating trip: ${data.error.message}')),
          );
        }
      });
    });
  }

  void _createTrip() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = _nameController.text;
    final destination = _destinationController.text;
    final budget = _budgetController.text.isNotEmpty ? num.tryParse(_budgetController.text) : null;
    if (budget == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid budget')),
      );
      return;
    }
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select start and end dates')),
      );
      return;
    }
    ref.read(createTripProvider.notifier).createTrip(name, destination, budget, _startDate!, _endDate!, _tripImage);
  }

  @override
  Widget build(BuildContext context) {
    final createTripState = ref.watch(createTripProvider);
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Text(
                'Create Trip',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                )
              ),
              const SizedBox(height: 32),
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _tripImage != null ? FileImage(_tripImage!) : null,
                    child: _tripImage == null
                        ? Icon(Icons.add_a_photo, size: 40, color: Theme.of(context).colorScheme.primary)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (createTripState.hasError)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    (createTripState.error as CreateTripError).error.message ?? 'An error occurred',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error),
                  ),
                ),
              TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'My trip to Casablanca',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(
                      Icons.book_outlined,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a trip name';
                    }
                    return null;
                  },
                ),
                if (createTripState.hasError && (createTripState.error as CreateTripError).error.name != null)
                  Text((createTripState.error as CreateTripError).error.name!,
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error),
                  ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _destinationController,
                  decoration: InputDecoration(
                    labelText: 'Destination',
                    hintText: 'Casablanca, Morocco',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(
                      Icons.place_outlined,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a destination';
                    }
                    return null;
                  },
                ),
                if (createTripState.hasError && (createTripState.error as CreateTripError).error.destination != null)
                  Text((createTripState.error as CreateTripError).error.destination!,
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error),
                  ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _budgetController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Budget',
                    hintText: '1000.00',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(
                      Icons.currency_pound,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a budget';
                    }
                    return null;
                  },
                ),
                if (createTripState.hasError && (createTripState.error as CreateTripError).error.budget != null)
                  Text((createTripState.error as CreateTripError).error.budget!,
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error),
                  ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'Start date',
                          hintText: _startDate != null
                              ? _startDate!.toLocal().toIso8601String().split('T')[0]
                              : 'Select Start Date',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () async {
                              final pickedDate = await showDatePicker(
                                context: context,
                                initialDate: _startDate ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100)
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  _startDate = pickedDate;
                                });
                              }
                            },
                            icon: Icon(Icons.calendar_today_outlined, color: theme.colorScheme.primary),
                          )
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: 'End Date',
                          hintText: _endDate != null
                              ? _endDate!.toLocal().toIso8601String().split('T')[0]
                              : 'Select End Date',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () async {
                              final pickedDate = await showDatePicker(
                                context: context,
                                initialDate: _endDate ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100)
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  _endDate = pickedDate;
                                });
                              }
                            },
                            icon: Icon(Icons.calendar_today_outlined, color: theme.colorScheme.primary),
                          )
                        ),
                      ),
                    ),
                  ],
                ),
                if (createTripState.hasError
                  && ((createTripState.error as CreateTripError).error.startDate != null
                  || (createTripState.error as CreateTripError).error.endDate != null))
                  Text((createTripState.error as CreateTripError).error.startDate ?? (createTripState.error as CreateTripError).error.endDate!,
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error),
                  ),
                const SizedBox(height: 32),
                Center(
                  child: Column(
                    children: [
                      RectangularButton(
                        onPressed:
                            createTripState.isLoading ? null : _createTrip,
                        text: 'Create',
                        isLoading: createTripState.isLoading
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
