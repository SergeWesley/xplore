import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/widgets/app_drawer.dart';
import '../../../../injection_container.dart';
import '../cubit/favorites_cubit.dart';
import '../cubit/favorites_state.dart';
import '../widgets/apod_grid_tile.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<FavoritesCubit>()..loadFavorites(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Mes Favoris'), centerTitle: true),
        drawer: const AppDrawer(currentRoute: 'favorites'),
        body: BlocBuilder<FavoritesCubit, FavoritesState>(
          builder: (context, state) {
            return switch (state) {
              FavoritesInitial() => const Center(
                child: CircularProgressIndicator(),
              ),
              FavoritesLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
              FavoritesLoaded(:final favorites) =>
                favorites.isEmpty
                    ? _buildEmptyState()
                    : _buildFavoritesList(context, favorites),
              FavoritesError(:final message) => Center(
                child: Text('Erreur: $message'),
              ),
            };
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.heart, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Aucun favori pour le moment',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList(BuildContext context, List favorites) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 2;
        if (constraints.maxWidth > 600) crossAxisCount = 3;
        if (constraints.maxWidth > 900) crossAxisCount = 4;

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final apod = favorites[index];
            return ApodGridTile(apod: apod);
          },
        );
      },
    );
  }
}
