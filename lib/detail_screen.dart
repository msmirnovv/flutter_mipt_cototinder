import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> catData;

  DetailScreen({required this.catData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(catData['breeds'][0]['name']),
      ),
      body: Column(
        children: [
          Image.network(catData['url']),
          Text('Описание: ${catData['breeds'][0]['description']}'),
          Text('Темперамент: ${catData['breeds'][0]['temperament']}'),
        ],
      ),
    );
  }
}