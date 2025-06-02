import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wander_wallet/core/models/success.dart';
import 'package:wander_wallet/core/widgets/buttons.dart';
import 'package:wander_wallet/features/expenses/presentation/providers/create_expense_provider.dart';
import 'package:wander_wallet/features/trips/presentation/providers/trip_details_provider.dart';

class CreateExpenseScreen extends ConsumerStatefulWidget {
  final String tripId;
  const CreateExpenseScreen({super.key, required this.tripId});

  @override
  ConsumerState<CreateExpenseScreen> createState() => _CreateExpenseScreenState();
}

class _CreateExpenseScreenState extends ConsumerState<CreateExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime? _date;
  Category? _selectedCategory;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    ref.listenManual(createExpenseProvider(widget.tripId), (prev, next) {
      next.whenData((data) {
        if (data is CreateExpenseSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Trip "${data.expensePayload.expense.name}" created successfully!'))
          );
          ref.invalidate(tripDetailsProvider(widget.tripId));
          Navigator.pushNamed(context, '/tripDetails', arguments: widget.tripId);
        }
      });
    });
  }

  void _createExpense() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = _nameController.text;
    final amount = _amountController.text.isEmpty ? null : num.tryParse(_amountController.text);
    final notes = _notesController.text.isEmpty ? null : _notesController.text;

    if (amount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount'))
      );
      return;
    }
    if (_date == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select date'))
      );
      return;
    }
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a valid category'))
      );
      return;
    }

    ref.read(createExpenseProvider(widget.tripId).notifier).createExpense(name, amount, _selectedCategory!, _date!, notes);
  }

  @override
  Widget build(BuildContext context) {
    final createExpenseState = ref.watch(createExpenseProvider(widget.tripId));
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
                'Create Expense',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                )
              ),
              const SizedBox(height: 32),
              if (createExpenseState.hasError)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    (createExpenseState.error as CreateExpenseError).error.message ?? 'An error occurred',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error),
                  ),
                ),
              TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'Lasagna a la Paris',
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
                      return 'Please enter an expense name';
                    }
                    return null;
                  },
                ),
                if (createExpenseState.hasError && (createExpenseState.error as CreateExpenseError).error.name != null)
                  Text((createExpenseState.error as CreateExpenseError).error.name!,
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error),
                  ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    hintText: '100.00',
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
                      return 'Please enter an amount';
                    }
                    return null;
                  },
                ),
                if (createExpenseState.hasError && (createExpenseState.error as CreateExpenseError).error.amount != null)
                  Text((createExpenseState.error as CreateExpenseError).error.amount!,
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error),
                  ),
                const SizedBox(height: 16),
                TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Date',
                    hintText: _date != null
                        ? _date!.toLocal().toIso8601String().split('T')[0]
                        : 'Select Date',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _date ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100)
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _date = pickedDate;
                          });
                        }
                      },
                      icon: Icon(Icons.calendar_today_outlined, color: theme.colorScheme.primary),
                    )
                  ),
                ),
                if (createExpenseState.hasError
                  && ((createExpenseState.error as CreateExpenseError).error.date != null))
                  Text((createExpenseState.error as CreateExpenseError).error.date!,
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error),
                  ),
                const SizedBox(height: 16),
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(
                      Icons.category,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  items: Category.values.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category.name.toLowerCase()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  }
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesController,
                  decoration: InputDecoration(
                    labelText: 'Notes',
                    hintText: 'I left a \$20 tip',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Icon(
                      Icons.note,
                      color: theme.colorScheme.primary,
                    ),
                  )
                ),
                const SizedBox(height: 32),
                Center(
                  child: Column(
                    children: [
                      RectangularButton(
                        onPressed:
                            createExpenseState.isLoading ? null : _createExpense,
                        text: 'Create',
                        isLoading: createExpenseState.isLoading
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
