import 'package:flutter/material.dart';
import '../../domain/models/cat_model.dart';

class DetailScreen extends StatelessWidget {
  final CatModel cat;

  const DetailScreen({super.key, required this.cat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(cat.breed)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              cat.url,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder:
                  (context, error, stackTrace) => const Icon(Icons.error),
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
