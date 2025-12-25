import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../injection_container.dart';
import '../cubit/neo_cubit.dart';
import '../cubit/neo_state.dart';
import '../widgets/asteroid_cloud.dart';

class NeoPage extends StatefulWidget {
  const NeoPage({super.key});

  @override
  State<NeoPage> createState() => _NeoPageState();
}

class _NeoPageState extends State<NeoPage> {
  DateTimeRange? _selectedDateRange;

  DateTimeRange get _currentDateRange {
    final now = DateTime.now();
    return _selectedDateRange ??
        DateTimeRange(start: now.subtract(const Duration(days: 7)), end: now);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<NeoCubit>()..fetchLastWeekNeos(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Near Earth Objects'),
          centerTitle: true,
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Iconsax.calendar),
                onPressed: () => _showDatePicker(context),
                tooltip: 'Choisir une période',
              ),
            ),
          ],
        ),
        drawer: const AppDrawer(currentRoute: 'neo'),
        body: BlocBuilder<NeoCubit, NeoState>(
          builder: (context, state) {
            return switch (state) {
              NeoInitial() => const Center(child: Text('Initialisation...')),
              NeoLoading() => _buildLoading(),
              NeoLoaded(:final feed) => AsteroidCloud(
                neos: feed.allNeos,
                dateRange: _currentDateRange,
              ),
              NeoError(:final message) => _buildError(context, message),
            };
          },
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Recherche des astéroïdes...'),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Iconsax.warning_2,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(message),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => context.read<NeoCubit>().fetchLastWeekNeos(),
            icon: const Icon(Iconsax.refresh),
            label: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(1974),
      lastDate: now,
      initialDateRange: _currentDateRange,
      helpText: 'Sélectionner une période',
      cancelText: 'Annuler',
      confirmText: 'OK',
      saveText: 'Valider',
      fieldStartHintText: 'Date début',
      fieldEndHintText: 'Date fin',
      fieldStartLabelText: 'Début',
      fieldEndLabelText: 'Fin',
      errorFormatText: 'Format invalide',
      errorInvalidText: 'Date invalide',
      errorInvalidRangeText: 'Période invalide',
    );

    if (picked != null && context.mounted) {
      if (picked.end.difference(picked.start).inDays > 7) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Maximum 7 jours')));
        return;
      }

      setState(() {
        _selectedDateRange = picked;
      });

      context.read<NeoCubit>().fetchNeoFeed(
        startDate: _formatDate(picked.start),
        endDate: _formatDate(picked.end),
      );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
