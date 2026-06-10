import 'dart:convert';

import 'package:app/app/theme/app_colors.dart';
import 'package:app/features/pets/domain/entities/pet.dart';
import 'package:flutter/material.dart';

class PetImage extends StatelessWidget {
  const PetImage({
    required this.pet,
    required this.size,
    this.borderRadius,
    this.fit = BoxFit.cover,
    super.key,
  });

  final Pet pet;
  final double size;
  final BorderRadius? borderRadius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final imageProvider = _imageProvider(pet.imageUrl);
    final radius = borderRadius ?? BorderRadius.circular(size / 2);

    return ClipRRect(
      borderRadius: radius,
      child: Container(
        width: size,
        height: size,
        color: Color(pet.imagePlaceholderColor).withValues(alpha: 0.45),
        child: imageProvider == null
            ? const Icon(
                Icons.pets_rounded,
                color: AppColors.primary,
                size: 34,
              )
            : Image(
                image: imageProvider,
                width: size,
                height: size,
                fit: fit,
              ),
      ),
    );
  }

  ImageProvider? _imageProvider(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return null;
    }

    if (imageUrl.startsWith('data:image')) {
      final commaIndex = imageUrl.indexOf(',');
      if (commaIndex == -1) {
        return null;
      }
      return MemoryImage(base64Decode(imageUrl.substring(commaIndex + 1)));
    }

    if (imageUrl.startsWith('http')) {
      return NetworkImage(imageUrl);
    }

    return null;
  }
}
