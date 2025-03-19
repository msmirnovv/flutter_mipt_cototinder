import 'package:flutter/material.dart';
import 'detail_screen.dart';  // Импортируйте файл с DetailScreen
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';
import 'package:logger/logger.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Map<String, dynamic>? _catData;
  int _likesCount = 0;
  final Logger logger = Logger(); 

  Future<void> _fetchRandomCat() async {
    try{
      final response = await http.get(Uri.parse('https://api.thecatapi.com/v1/images/search?api_key=live_KonzsrutZWsnhgBGS2aPuDuahDQ3pwHfSxQRQgkOC3oSIHSwmws8S2QzVKUPpZ1T'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data.isNotEmpty) {
          setState(() {
            _catData = data[0];
          });
          logger.i('Cat data fetched successfully: ${_catData}');  // Логирование успешного запроса
        } else {
          logger.e('Invalid data format from API');  // Логирование ошибки формата данных
          throw Exception('Invalid data format');
        }
      } else {
        logger.e('Failed to load cat: ${response.statusCode}');  // Логирование ошибки HTTP
        throw Exception('Failed to load cat');
      }
    } catch (e) {
      logger.e('Error fetching cat data: $e');  // Логирование исключения
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
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {},
          ),
          Text('$_likesCount'),
        ],
      ),
      body: _catData == null || _catData == null || _catData!.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(catData: _catData!),
                      ),
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: '${_catData!['url']}?api_key=live_KonzsrutZWsnhgBGS2aPuDuahDQ3pwHfSxQRQgkOC3oSIHSwmws8S2QzVKUPpZ1T',
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) {
                      print('Error loading image: $error');
                      return Icon(Icons.error);
                    },
                  ),
                ),
                Text(_catData!['id']),
                Row(  
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    LikeButton(onPressed: _handleDislike, icon: Icons.thumb_down),
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

  LikeButton({required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
    );
  }
}