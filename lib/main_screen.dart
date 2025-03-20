import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'detail_screen.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:logger/logger.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  Map<String, dynamic>? _catData;
  int _likesCount = 0;
  final CardSwiperController _swiperController = CardSwiperController();
  final Logger logger = Logger();

  Future<void> _fetchRandomCat() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.thecatapi.com/v1/images/search?has_breeds=true&api_key=live_KonzsrutZWsnhgBGS2aPuDuahDQ3pwHfSxQRQgkOC3oSIHSwmws8S2QzVKUPpZ1T',
        ),
      );
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data.isNotEmpty) {
          setState(() {
            _catData = data[0];
          });
          logger.i('Cat url: ${_catData!['url']}');
          logger.i('Cat data fetched successfully: $_catData');
        } else {
          logger.e('Invalid data format from API');
          throw Exception('Invalid data format');
        }
      } else {
        logger.e('Failed to load cat: ${response.statusCode}');
        throw Exception('Failed to load cat');
      }
    } catch (e) {
      logger.e('Error fetching cat data: $e');
      throw Exception('Error: $e');
    }
  }
  void _loadNewCat() async {
    setState(() {
      _fetchRandomCat();
    });
  }
  void _handleLike() {
    setState(() {
      _likesCount++;
      logger.d('Liked! Total likes: $_likesCount');
      _fetchRandomCat();
    });
  }

  void _handleDislike() {
    setState(() {
      logger.d('Disliked!');
      _fetchRandomCat();
    });
  }

  @override
  void initState() {
    super.initState();
    logger.i('MainScreen initialized');
    _fetchRandomCat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Кототиндер'),
        actions: [
          IconButton(icon: Icon(Icons.favorite), onPressed: () {}),
          Text('$_likesCount'),
        ],
      ),
      body:
          _catData == null || _catData!.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 400,
                    child: CardSwiper(
                      controller: _swiperController,
                      cardsCount: _catData != null ? 1 : 0,
                      numberOfCardsDisplayed: 1,
                      onSwipe: (index, previousIndex, direction) {
                        _loadNewCat();
                        if (direction == CardSwiperDirection.right) {
                          setState(() {
                            _likesCount++;
                          });
                        }
                        return true;
                      },
                      cardBuilder:
                          (context, index, horizontalIndex, verticalIndex) {
                        if (_catData == null) return const SizedBox();
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => DetailScreen(catData: _catData!),
                              ),
                            );
                          },
                          child: Card(
                            color: Color.fromARGB(255, 238, 201, 187),
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
                                      imageUrl: _catData!["url"],
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      placeholder: (context, url) =>
                                          const Center(
                                              child:
                                                  CircularProgressIndicator()),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      _catData!["breeds"][0]["name"],
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
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
                        onPressed: _handleDislike,
                        icon: Icons.thumb_down,
                      ),
                      LikeButton(onPressed: _handleLike, icon: Icons.thumb_up),
                    ],
                  ),
                ],
              ),
    );
  }
}

class LikeButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;

  const LikeButton({super.key, required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return IconButton(icon: Icon(icon), onPressed: onPressed);
  }
}
