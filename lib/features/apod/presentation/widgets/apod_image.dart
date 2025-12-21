import 'package:flutter/material.dart';

class ApodImage extends StatelessWidget {
  final String? url;
  final String? hdurl;
  final BoxFit fit;
  final double? placeholderIconSize;

  const ApodImage({
    super.key,
    this.url,
    this.hdurl,
    this.fit = BoxFit.cover,
    this.placeholderIconSize = 48,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = hdurl ?? url;
    if (imageUrl == null) {
      return _buildPlaceholder(Icons.image);
    }
    return Image.network(
      imageUrl,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: Colors.grey[800],
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return _buildPlaceholder(Icons.broken_image);
      },
    );
  }

  Widget _buildPlaceholder(IconData icon) {
    return Container(
      color: Colors.grey[800],
      child: Center(
        child: Icon(icon, size: placeholderIconSize, color: Colors.grey),
      ),
    );
  }
}
