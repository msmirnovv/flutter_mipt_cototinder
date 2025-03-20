import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final Map<String, dynamic> catData;

  const DetailScreen({super.key, required this.catData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          catData["breeds"].isEmpty || !catData["breeds"][0].containsKey("name")
              ? "Unknown"
              : catData["breeds"][0]["name"],
        ),
      ),
      body: Column(
        children: [
          Image.network(
            '${catData['url']}?api_key=live_KonzsrutZWsnhgBGS2aPuDuahDQ3pwHfSxQRQgkOC3oSIHSwmws8S2QzVKUPpZ1T',
          ),
          Text(
            'Описание: ${catData["breeds"].isEmpty || !catData["breeds"][0].containsKey("description") ? "Similar cat" : catData["breeds"][0]["description"]}',
          ),
          Text(
            'Темперамент: ${catData["breeds"].isEmpty || !catData["breeds"][0].containsKey("temperament") ? "Calm" : catData["breeds"][0]["temperament"]}',
          ),
          Text(
            'Происхождение: ${catData["breeds"].isEmpty || !catData["breeds"][0].containsKey("origin") ? "Calm" : catData["breeds"][0]["origin"]}',
          ),
        ],
      ),
    );
  }
}
