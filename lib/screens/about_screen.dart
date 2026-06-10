import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('À propos')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nom : AKPONIKPE Akinlaiya G.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text('Source des données : Tontine'),
            Text('Date de collecte : '),
            SizedBox(height: 20),
            Text('Preuves : '),
          ],
        ),
      ),
    );
  }
}
