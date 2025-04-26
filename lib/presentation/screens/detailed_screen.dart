import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/models/cat_model.dart';

class DetailedScreen extends StatelessWidget {
  final CatModel cat;

  const DetailedScreen({super.key, required this.cat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(cat.breed)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: cat.url,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
              placeholder:
                  (_, __) => const Center(child: CircularProgressIndicator()),
              errorWidget: (_, __, ___) => const Icon(Icons.error),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Порода: ${cat.breed}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Описание: ${cat.description}'),
                  const SizedBox(height: 8),
                  Text('Темперамент: ${cat.temperament}'),
                  const SizedBox(height: 8),
                  Text('Происхождение: ${cat.origin}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
