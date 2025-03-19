import 'package:flutter/material.dart';
import 'detail_screen.dart';  // Импортируйте файл с DetailScreen
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Map<String, dynamic>? _catData;
  int _likesCount = 0;

  Future<void> _fetchRandomCat() async {
    final response = await http.get(Uri.parse('https://api.thecatapi.com/v1/images/search?has_breeds=true'));
    if (response.statusCode == 200) {
      setState(() {
        _catData = json.decode(response.body)[0];
      });
    } else {
      throw Exception('Failed to load cat');
    }
  }

  void _handleLike() {
    setState(() {
      _likesCount++;
      _fetchRandomCat();
    });
  }

  void _handleDislike() {
    setState(() {
      _fetchRandomCat();
    });
  }

  @override
  void initState() {
    super.initState();
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
      body: _catData == null
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
                    imageUrl: _catData!['url'],
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                Text(_catData!['breeds'][0]['name']),
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