import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../features/apod/presentation/pages/apod_page.dart';
import '../../features/apod/presentation/pages/favorites_page.dart';
import '../../features/neo/presentation/pages/neo_page.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;

  const AppDrawer({super.key, this.currentRoute = 'apod'});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Iconsax.star_1,
                  size: 48,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                const SizedBox(height: 12),
                Text(
                  'XPlore',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Explorer l\'univers',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onPrimary.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Iconsax.image),
            title: const Text('APOD'),
            subtitle: const Text('Image astronomique du jour'),
            selected: currentRoute == 'apod',
            onTap: () {
              Navigator.pop(context);
              if (currentRoute != 'apod') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ApodPage()),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Iconsax.global),
            title: const Text('NEO'),
            subtitle: const Text('Objets proches de la Terre'),
            selected: currentRoute == 'neo',
            onTap: () {
              Navigator.pop(context);
              if (currentRoute != 'neo') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const NeoPage()),
                );
              }
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Iconsax.heart),
            title: const Text('Favoris'),
            selected: currentRoute == 'favorites',
            onTap: () {
              Navigator.pop(context);
              if (currentRoute != 'favorites') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavoritesPage(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
