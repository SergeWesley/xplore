import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/apod_cubit.dart';
import '../cubit/apod_state.dart';
import '../widgets/apod_grid_tile.dart';

class ApodPage extends StatefulWidget {
  const ApodPage({super.key});

  @override
  State<ApodPage> createState() => _ApodPageState();
}

class _ApodPageState extends State<ApodPage> {
  @override
  void initState() {
    super.initState();
    context.read<ApodCubit>().fetchLastWeekApods();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApodCubit, ApodState>(
      builder: (context, state) {
        final isGalleryMode = state is ApodListLoaded;
        final isSingleMode = state is ApodLoaded;
        final primaryColor = Theme.of(context).colorScheme.primary;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Astronomy Picture of the Day'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(
                  Iconsax.gallery,
                  color: isGalleryMode ? primaryColor : null,
                ),
                tooltip: "7 derniers jours",
                onPressed: () {
                  context.read<ApodCubit>().fetchLastWeekApods();
                },
              ),
              IconButton(
                icon: Icon(
                  Iconsax.calendar,
                  color: isSingleMode ? primaryColor : null,
                ),
                tooltip: "Image du jour",
                onPressed: () {
                  context.read<ApodCubit>().fetchTodayApod();
                },
              ),
              IconButton(
                icon: const Icon(Iconsax.calendar_1),
                tooltip: 'Choisir une date',
                onPressed: () => _showDatePicker(context),
              ),
            ],
          ),
          body: switch (state) {
            ApodInitial() => _buildInitialState(),
            ApodLoading() => _buildLoadingState(),
            ApodLoaded(:final apod) => _buildSingleApod(context, apod),
            ApodListLoaded(:final apodList) => _buildApodList(
              context,
              apodList,
            ),
            ApodError(:final message) => _buildErrorState(context, message),
          },
        );
      },
    );
  }

  Widget _buildInitialState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.star_1, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Découvrez les merveilles de l\'univers',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Chargement des images...'),
        ],
      ),
    );
  }

  Widget _buildSingleApod(BuildContext context, apod) {
    return RefreshIndicator(
      onRefresh: () => context.read<ApodCubit>().fetchTodayApod(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: SizedBox(height: 300, child: ApodGridTile(apod: apod)),
      ),
    );
  }

  Widget _buildApodList(BuildContext context, List apodList) {
    return RefreshIndicator(
      onRefresh: () => context.read<ApodCubit>().fetchLastWeekApods(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = _getCrossAxisCount(constraints.maxWidth);

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemCount: apodList.length,
            itemBuilder: (context, index) {
              final apod = apodList[apodList.length - 1 - index];
              return ApodGridTile(apod: apod);
            },
          );
        },
      ),
    );
  }

  int _getCrossAxisCount(double width) {
    if (width < 400) return 2;
    if (width < 600) return 2;
    if (width < 900) return 3;
    if (width < 1200) return 4;
    return 5;
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Iconsax.warning_2, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.red),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.read<ApodCubit>().fetchLastWeekApods(),
            icon: const Icon(Iconsax.refresh),
            label: const Text('Réessayer'),
          ),
        ],
      ),
    );
  }

  void _showDatePicker(BuildContext context) async {
    final now = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1995, 6, 16),
      lastDate: now,
      helpText: 'Choisir une date',
      cancelText: 'Annuler',
      confirmText: 'Confirmer',
    );

    if (selectedDate != null && context.mounted) {
      final formattedDate =
          '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
      context.read<ApodCubit>().fetchApod(date: formattedDate);
    }
  }
}
