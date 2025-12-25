import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../domain/entities/neo_entity.dart';

class NeoInfoPanel extends StatelessWidget {
  final NeoEntity neo;
  final VoidCallback onClose;

  const NeoInfoPanel({super.key, required this.neo, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 12),
            _buildInfoRow(context, [
              _InfoItem(
                icon: Iconsax.ruler,
                label: 'Diamètre',
                value: _formatDiameter(neo.averageDiameterMeters),
              ),
              _InfoItem(
                icon: Iconsax.moon,
                label: 'Distance',
                value: '${neo.missDistanceLunar.toStringAsFixed(1)} × 🌙',
              ),
            ]),
            const SizedBox(height: 8),
            _buildInfoRow(context, [
              _InfoItem(
                icon: Iconsax.flash,
                label: 'Vitesse',
                value: '${neo.velocityKmPerSecond.toStringAsFixed(1)} km/s',
              ),
              _InfoItem(
                icon: Iconsax.calendar,
                label: 'Date passage',
                value: neo.closeApproachDate,
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            neo.name,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        if (neo.isPotentiallyHazardous)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '⚠️ Dangereux',
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: Colors.white),
            ),
          ),
        IconButton(icon: const Icon(Icons.close), onPressed: onClose),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, List<_InfoItem> items) {
    return Row(
      children: items
          .map((item) => Expanded(child: _buildInfoTile(context, item)))
          .toList(),
    );
  }

  Widget _buildInfoTile(BuildContext context, _InfoItem item) {
    return Row(
      children: [
        Icon(item.icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            Text(
              item.value,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDiameter(double meters) {
    if (meters >= 1000) {
      return '${(meters / 1000).toStringAsFixed(2)} km';
    }
    return '${meters.toStringAsFixed(0)} m';
  }
}

class _InfoItem {
  final IconData icon;
  final String label;
  final String value;

  _InfoItem({required this.icon, required this.label, required this.value});
}
