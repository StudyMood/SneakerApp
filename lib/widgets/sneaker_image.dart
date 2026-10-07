import 'package:flutter/material.dart';

class SneakerImage extends StatelessWidget {
  final String imagePath;
  final BoxFit fit;
  final double? width;
  final double? height;

  const SneakerImage({
    super.key,
    required this.imagePath,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: SizedBox(
              width: 24,
              height: 24,
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
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Icon(Icons.sports_basketball, color: Colors.grey, size: 40),
        ),
      );
    } else {
      return Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => const Center(
          child: Icon(Icons.sports_basketball, color: Colors.grey, size: 40),
        ),
      );
    }
  }
}
