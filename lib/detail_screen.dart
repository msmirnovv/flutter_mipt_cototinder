import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> catData;

  DetailScreen({required this.catData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(catData['id']),
      ),
      body: Column(
        children: [
          Image.network(catData['url']),
          Text('Описание: Кот'),
          Text('Темперамент: Спокойный'),
        ],
      ),
    );
  }
}