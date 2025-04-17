import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/liked_cats_cubit.dart';

class LikedCatsScreen extends StatefulWidget {
  const LikedCatsScreen({super.key});

  @override
  State<LikedCatsScreen> createState() => _LikedCatsScreenState();
}

class _LikedCatsScreenState extends State<LikedCatsScreen> {
  String? selectedBreed;

  @override
  Widget build(BuildContext context) {
    final likedCats = context.watch<LikedCatsCubit>().state;
    final breeds = likedCats.map((e) => e.cat.breed).toSet().toList();
    final filtered =
        selectedBreed == null
            ? likedCats
            : likedCats.where((c) => c.cat.breed == selectedBreed).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Избранные котики')),
      body: Column(
        children: [
          if (breeds.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton<String>(
                hint: const Text('Фильтр по породе'),
                value: selectedBreed,
                onChanged: (value) => setState(() => selectedBreed = value),
                items:
                    breeds
                        .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                        .toList(),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (_, index) {
                final likedCat = filtered[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: ListTile(
                    leading: Image.network(
                      likedCat.cat.url,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    ),
                    title: Text(likedCat.cat.breed),
                    subtitle: Text(
                      'Лайк: ${likedCat.likedAt.toLocal().toString().split('.')[0]}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        final cubit = context.read<LikedCatsCubit>();
                        cubit.removeCat(likedCat);

                        final remainingCats = cubit.state;
                        final stillHasSelectedBreed =
                            selectedBreed == null ||
                            remainingCats.any(
                              (c) => c.cat.breed == selectedBreed,
                            );

                        if (!stillHasSelectedBreed) {
                          setState(() {
                            selectedBreed = null;
                          });
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
