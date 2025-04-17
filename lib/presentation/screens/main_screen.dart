import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../cubits/cat_cubit.dart';
import '../cubits/liked_cats_cubit.dart';
import 'detail_screen.dart';
import '../widgets/like_button.dart';
import 'liked_cats_screen.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final CardSwiperController _swiperController = CardSwiperController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Кототиндер'),
        actions: [
          BlocBuilder<LikedCatsCubit, List<LikedCat>>(
            builder: (context, likedCats) {
              return Row(
                children: [
                  Text(
                    '${likedCats.length}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.favorite),
                    onPressed:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LikedCatsScreen(),
                          ),
                        ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CatCubit, CatState>(
        builder: (context, state) {
          if (state is CatLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CatError) {
            return Center(
              child: AlertDialog(
                title: const Text('Ошибка'),
                content: Text(state.message),
                actions: [
                  TextButton(
                    onPressed: () => context.read<CatCubit>().fetchRandomCat(),
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          } else if (state is CatLoaded) {
            final cat = state.cat;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 400,
                  child: CardSwiper(
                    controller: _swiperController,
                    cardsCount: 1,
                    numberOfCardsDisplayed: 1,
                    onSwipe: (index, previousIndex, direction) {
                      if (direction == CardSwiperDirection.right) {
                        context.read<LikedCatsCubit>().likeCat(cat);
                      }
                      context.read<CatCubit>().fetchRandomCat();
                      return true;
                    },
                    cardBuilder: (
                      context,
                      index,
                      horizontalIndex,
                      verticalIndex,
                    ) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailScreen(cat: cat),
                            ),
                          );
                        },
                        child: Card(
                          color: const Color.fromARGB(255, 238, 201, 187),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Image.network(
                                    cat.url,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    loadingBuilder: (
                                      context,
                                      child,
                                      loadingProgress,
                                    ) {
                                      if (loadingProgress == null) return child;
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(Icons.error),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    cat.breed,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    LikeButton(
                      onPressed:
                          () => context.read<CatCubit>().fetchRandomCat(),
                      icon: Icons.thumb_down,
                    ),
                    LikeButton(
                      onPressed: () {
                        context.read<LikedCatsCubit>().likeCat(cat);
                        context.read<CatCubit>().fetchRandomCat();
                      },
                      icon: Icons.thumb_up,
                    ),
                  ],
                ),
              ],
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
