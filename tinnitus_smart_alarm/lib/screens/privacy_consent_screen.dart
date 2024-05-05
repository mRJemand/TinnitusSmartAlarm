import 'package:flutter/material.dart';

class PrivacyConsentScreen extends StatelessWidget {
  final Function(bool) onConsent;

  const PrivacyConsentScreen({required this.onConsent});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Datensammlung'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Einwilligung zur Datensammlung',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Wir sammeln Daten, um die App zu verbessern. \n\nBitte stimmen Sie der Datensammlung zu oder lehnen Sie sie ab.',
              style: TextStyle(fontSize: 16),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => onConsent(false),
                  child: Text('Ablehnen'),
                ),
                ElevatedButton(
                  onPressed: () => onConsent(true),
                  child: Text('Zustimmen'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
