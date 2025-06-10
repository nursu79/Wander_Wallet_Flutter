import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wander_wallet/core/di/providers.dart';
import 'package:wander_wallet/core/models/success.dart';
import 'package:wander_wallet/core/widgets/buttons.dart';
import 'package:wander_wallet/features/expenses/presentation/providers/edit_expense_provider.dart';
import 'package:wander_wallet/features/expenses/presentation/providers/expense_details_provider.dart';

class EditExpenseScreen extends ConsumerStatefulWidget {
  final String id;

  const EditExpenseScreen({ super.key, required this.id });

  @override ConsumerState<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends ConsumerState<EditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isLoading = false;
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

    ref.listenManual(editExpenseProvider(widget.id), (prev, next) {
      next.when(
        data: (data) {
          if (data is EditExpenseGetSuccess) {
            final expense = data.expensePayload.expense;

            _nameController.text = expense.name;
            _amountController.text = expense.amount.toString();
            _notesController.text = expense.notes ?? '';
            _date = expense.date;
            _selectedCategory = expense.category;
          } else if (data is EditExpenseUpdateSuccess) {
            final tripId = data.expensePayload.expense.tripId;
            ref.invalidate(expenseDetailsProvider(widget.id));
            Navigator.pushNamed(context, '/expenseDetails', arguments: {
              'id': widget.id,
              'tripId': tripId
            });
          }
        },
        error: (error, _) {
          if (error is EditExpenseGetError && error.logggeOut) {
            Navigator.pushNamed(context, '/login');
          } else if (error is EditExpenseUpdateError) {
            if (error.loggedOut) {
              Navigator.pushNamed(context, '/login');
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('An error occurred'))
              );
            }
          }
        },
        loading: () {}
      );
    });
  }

  void _updateExpense() async {
    setState(() {
      _isLoading = true;
    });
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

    ref.read(editExpenseProvider(widget.id).notifier).updateTrip(name, amount, _selectedCategory!, _date!, notes);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final editExpenseState = ref.watch(editExpenseProvider(widget.id));
    final theme = Theme.of(context);

    return editExpenseState.when(
      data: (data) {
        if (data is EditExpenseGetSuccess) {
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
                      'Edit Expense',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      )
                    ),
                    const SizedBox(height: 32),
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
                      const SizedBox(height: 16),
                      DropdownButtonFormField(
                        value: _selectedCategory,
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
                                _isLoading ? null : _updateExpense,
                              text: 'Edit',
                              isLoading: _isLoading
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
        } else {
          return Center(child: Text('Expense updated successfully!'));
        }
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, _) {
        if (error is EditExpenseGetError) {
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(error.error.message, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.error)),
                RectangularButton(
                  onPressed: () {
                    ref.read(editExpenseProvider(widget.id).notifier).refresh();
                  },
                  text: 'Retry'
                )
              ],
            ),
          );
        } else {
          final expenseError = (error as EditExpenseUpdateError).error;
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
                      if (expenseError.message != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            expenseError.message ?? 'An error occurred',
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
                        if (expenseError.name != null)
                          Text(expenseError.name!,
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
                        if (expenseError.amount != null)
                          Text(expenseError.amount!,
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
                        if (expenseError.date != null)
                          Text(expenseError.date!,
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
                                  _isLoading ? null : _updateExpense,
                                text: 'Create',
                                isLoading: _isLoading
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
    );
  }
}
