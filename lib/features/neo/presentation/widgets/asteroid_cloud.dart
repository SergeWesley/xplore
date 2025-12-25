import 'package:flutter/material.dart';
import '../../domain/entities/neo_entity.dart';
import '../utils/neo_position_calculator.dart';
import 'neo_info_panel.dart';
import 'starfield_painter.dart';

class AsteroidCloud extends StatefulWidget {
  final List<NeoEntity> neos;
  final DateTimeRange? dateRange;

  const AsteroidCloud({super.key, required this.neos, this.dateRange});

  @override
  State<AsteroidCloud> createState() => _AsteroidCloudState();
}

class _AsteroidCloudState extends State<AsteroidCloud> {
  NeoEntity? selectedNeo;
  List<PositionedNeo>? _positionedNeos;
  Size? _lastSize;
  final _calculator = NeoPositionCalculator();

  @override
  Widget build(BuildContext context) {
    if (widget.neos.isEmpty) {
      return const Center(child: Text('Aucun astéroïde détecté'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final currentSize = Size(constraints.maxWidth, constraints.maxHeight);

        if (_lastSize != currentSize) {
          _lastSize = currentSize;
          _positionedNeos = _calculator.calculatePositions(
            widget.neos,
            constraints.maxWidth,
            constraints.maxHeight,
          );
        }

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0D1B2A), Color(0xFF1B263B), Color(0xFF415A77)],
            ),
          ),
          child: Stack(
            children: [
              CustomPaint(
                painter: StarfieldPainter(),
                size: Size(constraints.maxWidth, constraints.maxHeight),
              ),
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: _CloudLegend(
                  neos: widget.neos,
                  availableWidth: constraints.maxWidth,
                  dateRange: widget.dateRange,
                ),
              ),
              ..._positionedNeos!.map(
                (pNeo) => _AsteroidPoint(
                  positionedNeo: pNeo,
                  isSelected: selectedNeo?.id == pNeo.neo.id,
                  onTap: () => _onAsteroidTap(pNeo.neo),
                ),
              ),
              if (selectedNeo != null)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: NeoInfoPanel(
                    neo: selectedNeo!,
                    onClose: () => setState(() => selectedNeo = null),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _onAsteroidTap(NeoEntity neo) {
    setState(() {
      selectedNeo = selectedNeo?.id == neo.id ? null : neo;
    });
  }
}

class _CloudLegend extends StatelessWidget {
  final List<NeoEntity> neos;
  final double availableWidth;
  final DateTimeRange? dateRange;

  const _CloudLegend({
    required this.neos,
    required this.availableWidth,
    this.dateRange,
  });

  @override
  Widget build(BuildContext context) {
    final hazardousCount = neos.where((n) => n.isPotentiallyHazardous).length;
    final isSmallScreen = availableWidth < 400;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dateRange != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                _formatDateRange(dateRange!),
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(color: Colors.white70),
              ),
            ),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${neos.length} objets',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (hazardousCount > 0) ...[
                    const SizedBox(width: 12),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$hazardousCount dangereux',
                      style: Theme.of(
                        context,
                      ).textTheme.labelMedium?.copyWith(color: Colors.red),
                    ),
                  ],
                ],
              ),
              if (!isSmallScreen)
                Text(
                  'Appuyez sur un astéroïde',
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: Colors.white54),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDateRange(DateTimeRange range) {
    final start = range.start;
    final end = range.end;
    return '${start.day}/${start.month}/${start.year} - ${end.day}/${end.month}/${end.year}';
  }
}

class _AsteroidPoint extends StatelessWidget {
  final PositionedNeo positionedNeo;
  final bool isSelected;
  final VoidCallback onTap;

  const _AsteroidPoint({
    required this.positionedNeo,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = positionedNeo.neo.isPotentiallyHazardous
        ? Colors.red
        : Colors.blueGrey;

    return Positioned(
      left: positionedNeo.x - positionedNeo.radius,
      top: positionedNeo.y - positionedNeo.radius,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: positionedNeo.radius * 2,
          height: positionedNeo.radius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.7),
            border: isSelected
                ? Border.all(color: Colors.white, width: 2)
                : null,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.5),
                blurRadius: isSelected ? 12 : 6,
                spreadRadius: isSelected ? 2 : 0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
