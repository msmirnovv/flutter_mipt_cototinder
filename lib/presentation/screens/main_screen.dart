import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../cubits/cat_cubit.dart';
import '../cubits/liked_cats_cubit.dart';
import 'detailed_screen.dart';
import '../widgets/like_button.dart';
import 'liked_cats_screen.dart';
import '../cubits/connectivity_cubit.dart';

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
            return BlocBuilder<ConnectivityCubit, ConnectivityState>(
              builder: (context, connectivityState) {
                final text =
                    connectivityState.online
                        ? 'Сеть восстановлена'
                        : 'Вы оффлайн';
                final color =
                    connectivityState.online ? Colors.green : Colors.red;

                if (connectivityState.online) {
                  Future.delayed(Duration.zero, () {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(text), backgroundColor: color),
                      );
                    }
                  });
                }

                if (!connectivityState.online) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlocBuilder<CatCubit, CatState>(
                        builder: (context, state) {
                          if (state is CatError) {
                            return const Center(
                              child: Text('Ошибка загрузки котов.'),
                            );
                          } else if (state is CatLoaded) {
                            final cachedCat = state.cat;
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
                                      context.read<LikedCatsCubit>().likeCat(
                                        cachedCat,
                                      );
                                      context.read<CatCubit>().fetchRandomCat();
                                      return true;
                                    },
                                    cardBuilder: (context, index, h, v) {
                                      return GestureDetector(
                                        onTap:
                                            () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (_) => DetailedScreen(
                                                      cat: cachedCat,
                                                    ),
                                              ),
                                            ),
                                        child: Card(
                                          color: const Color.fromARGB(
                                            255,
                                            238,
                                            201,
                                            187,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          elevation: 4,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            child: Column(
                                              children: [
                                                Expanded(
                                                  child: CachedNetworkImage(
                                                    imageUrl: cachedCat.url,
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    placeholder:
                                                        (_, __) => const Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                    errorWidget:
                                                        (_, __, ___) =>
                                                            const Icon(
                                                              Icons.error,
                                                            ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                    8.0,
                                                  ),
                                                  child: Text(
                                                    cachedCat.breed,
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                              ],
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                    ],
                  );
                }

                return Column(
                  children: [
                    Text(text, style: TextStyle(color: color)),
                    ElevatedButton(
                      onPressed:
                          () => context.read<CatCubit>().fetchRandomCat(),
                      child: const Text('Загрузить котов'),
                    ),
                  ],
                );
              },
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
                    cardBuilder: (context, index, h, v) {
                      return GestureDetector(
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailedScreen(cat: cat),
                              ),
                            ),
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
                                  child: CachedNetworkImage(
                                    imageUrl: cat.url,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    placeholder:
                                        (_, __) => const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                    errorWidget:
                                        (_, __, ___) => const Icon(Icons.error),
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
