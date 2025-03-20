import 'package:flutter/material.dart';
import 'detail_screen.dart';
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
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => DetailScreen(catData: _catData!),
                        ),
                      );
                    },
                    child:
                        _catData != null
                            ? Image.network(
                              '${_catData!['url']}?api_key=live_KonzsrutZWsnhgBGS2aPuDuahDQ3pwHfSxQRQgkOC3oSIHSwmws8S2QzVKUPpZ1T',
                              loadingBuilder: (
                                context,
                                child,
                                loadingProgress,
                              ) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Center(
                                  child: CircularProgressIndicator(
                                    value:
                                        loadingProgress.expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                (loadingProgress
                                                        .expectedTotalBytes ??
                                                    1)
                                            : null,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                logger.e('Error loading image: $error');
                                return Icon(Icons.error);
                              },
                            )
                            : CircularProgressIndicator(),
                  ),
                  Text(
                    _catData!["breeds"].isEmpty ||
                            !_catData!["breeds"][0].containsKey("name")
                        ? "Unknown"
                        : _catData!["breeds"][0]["name"],
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
