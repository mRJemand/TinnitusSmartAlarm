// stimuli_decision_tree_screen.dart
import 'package:flutter/material.dart';

class TinnitusDecisionTreeScreen extends StatefulWidget {
  const TinnitusDecisionTreeScreen({Key? key}) : super(key: key);

  @override
  _TinnitusDecisionTreeScreenState createState() =>
      _TinnitusDecisionTreeScreenState();
}

class _TinnitusDecisionTreeScreenState
    extends State<TinnitusDecisionTreeScreen> {
  String? _tinnitusType;
  bool? _isFrequencyKnown;
  String? _specificFrequency;
  String? _finalRecommendation;
  List<String> finalCategoryNames = [];
  String? finalFrequeny = '';

  void _updateRecommendation() {
    if (_tinnitusType == 'Tonaler Tinnitus') {
      if (_isFrequencyKnown == true) {
        switch (_specificFrequency) {
          case '250 Hz':
            finalFrequeny = '250 Hz';
            finalCategoryNames.add('unnatural_pos');
            finalCategoryNames.add('natural_plus');
            break;
          case '500 Hz':
            finalFrequeny = '500 Hz';
            finalCategoryNames.add('unnatural_pos');
            finalCategoryNames.add('natural_plus');
            break;
          case '1000 Hz':
            finalFrequeny = '1000 Hz';
            finalCategoryNames.add('unnatural_pos');
            finalCategoryNames.add('natural_plus');
            break;
          case '2000 Hz':
            finalFrequeny = '2000 Hz';
            finalCategoryNames.add('unnatural_pos');
            finalCategoryNames.add('natural_plus');
            break;
          case '3000 Hz':
            finalFrequeny = '3000 Hz';
            finalCategoryNames.add('unnatural_pos');
            finalCategoryNames.add('natural_plus');
            break;
          case '4000 Hz':
            finalFrequeny = '4000 Hz';
            finalCategoryNames.add('unnatural_pos');
            finalCategoryNames.add('natural_plus');
            break;
          case '6000 Hz':
            finalFrequeny = '6000 Hz';
            finalCategoryNames.add('unnatural_pos');
            finalCategoryNames.add('natural_plus');
            break;
          case '8000 Hz':
            finalFrequeny = '8000 Hz';
            finalCategoryNames.add('unnatural_pos');
            finalCategoryNames.add('natural_plus');
            break;
          default:
            _finalRecommendation =
                'Bitte wählen Sie eine gültige Frequenz aus.';
        }
      } else {
        finalCategoryNames.add('natural_neg');
        finalCategoryNames.add('unnatural_neg');
      }
    } else if (_tinnitusType == 'Rauschähnlicher Tinnitus') {
      if (_isFrequencyKnown == true) {
        switch (_specificFrequency) {
          case '250 Hz':
            finalFrequeny = '250 Hz';
            finalCategoryNames.add('unnatural_pos');
            finalCategoryNames.add('natural_plus');
            break;
          case '500 Hz':
            finalFrequeny = '500 Hz';
            finalCategoryNames.add('unnatural_pos');
            finalCategoryNames.add('natural_plus');
            break;

          case '1000 Hz':
            finalFrequeny = '1000 Hz';
            finalCategoryNames.add('unnatural_pos');
            finalCategoryNames.add('natural_plus');
            break;
          case '2000 Hz':
            finalFrequeny = '1000 Hz';
            finalCategoryNames.add('unnatural_pos');
            finalCategoryNames.add('natural_plus');
            break;
          case '3000 Hz':
            finalFrequeny = '3000 Hz';
            finalCategoryNames.add('unnatural_pos');
            finalCategoryNames.add('natural_plus');
            break;
          case '4000 Hz':
            finalFrequeny = '4000 Hz';
            finalCategoryNames.add('unnatural_pos');
            finalCategoryNames.add('natural_plus');
            break;
          case '6000 Hz':
            finalFrequeny = '6000 Hz';
            finalCategoryNames.add('unnatural_pos');
            finalCategoryNames.add('natural_plus');
            break;
          case '8000 Hz':
            finalFrequeny = '8000 Hz';
            finalCategoryNames.add('unnatural_pos');
            finalCategoryNames.add('natural_plus');
            break;
          default:
            finalCategoryNames.add('unnatural_pos');
            finalCategoryNames.add('natural_plus');
            _finalRecommendation =
                'Bitte wählen Sie eine gültige Frequenz aus.';
        }
      } else {
        finalCategoryNames.add('unnatural_pos');
        finalCategoryNames.add('natural_plus');
      }
    } else if (_tinnitusType == 'Gemischter Tinnitus') {
      if (_isFrequencyKnown == true) {
        switch (_specificFrequency) {
          case '250 Hz':
            finalFrequeny = '250 Hz';
            finalCategoryNames.add('unnatural_pos');
            finalCategoryNames.add('natural_plus');
            break;
          case '500 Hz':
            finalFrequeny = '500 Hz';
            finalCategoryNames.add('unnatural_pos');
            finalCategoryNames.add('natural_plus');
            break;
          case '1000 Hz':
            finalFrequeny = '1000 Hz';
            finalCategoryNames.add('unnatural_pos');
            finalCategoryNames.add('natural_plus');
            break;
          case '2000 Hz':
            finalFrequeny = '2000 Hz';
            finalCategoryNames.add('unnatural_pos');
            finalCategoryNames.add('natural_plus');
            break;
          case '3000 Hz':
            finalFrequeny = '3000 Hz';
            finalCategoryNames.add('unnatural_pos');
            finalCategoryNames.add('natural_plus');
            break;
          case '4000 Hz':
            finalFrequeny = '4000 Hz';
            finalCategoryNames.add('unnatural_pos');
            finalCategoryNames.add('natural_plus');
            break;
          case '6000 Hz':
            finalFrequeny = '6000 Hz';
            finalCategoryNames.add('unnatural_pos');
            finalCategoryNames.add('natural_plus');
            break;
          case '8000 Hz':
            finalFrequeny = '8000 Hz';
            finalCategoryNames.add('unnatural_pos');
            finalCategoryNames.add('natural_plus');
            break;
          default:
            finalCategoryNames.add('unnatural_pos');
            finalCategoryNames.add('natural_plus');
            _finalRecommendation =
                'Bitte wählen Sie eine gültige Frequenz aus.';
        }
      } else {
        finalCategoryNames.add('unnatural_pos');
        finalCategoryNames.add('natural_plus');
      }
    }

    setState(() {});
  }

  void _setTinnitusType(String value) {
    setState(() {
      _tinnitusType = value;
      _isFrequencyKnown = null;
      _specificFrequency = null;
      _finalRecommendation = null;
    });
  }

  void _setIsFrequencyKnown(bool value) {
    setState(() {
      _isFrequencyKnown = value;
      _specificFrequency = null;
      _finalRecommendation = null;
    });
  }

  void _setSpecificFrequency(String value) {
    setState(() {
      _specificFrequency = value;
      _finalRecommendation = null;
    });
  }

  void _goBack() {
    if (_finalRecommendation != null) {
      _finalRecommendation = null;
    } else if (_specificFrequency != null) {
      _specificFrequency = null;
    } else if (_isFrequencyKnown != null) {
      _isFrequencyKnown = null;
    } else {
      _tinnitusType = null;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tinnitus-Entscheidungsbaum'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (_tinnitusType == null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Frage 1: Welchen Tinnitus-Typ haben Sie?',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ElevatedButton(
                    onPressed: () => _setTinnitusType('Tonaler Tinnitus'),
                    child:
                        const Text('Tonaler Tinnitus (z.B. Klingeln, Piepen)'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () =>
                        _setTinnitusType('Rauschähnlicher Tinnitus'),
                    child: const Text(
                        'Rauschähnlicher Tinnitus (z.B. Rauschen, Zischen)'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _setTinnitusType('Gemischter Tinnitus'),
                    child: const Text(
                        'Gemischter Tinnitus (Kombination aus beiden Tinnitus-Typen)'),
                  ),
                ],
              ),
            if (_tinnitusType != null && _isFrequencyKnown == null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Frage 2: Ist Ihre Tinnitusfrequenz bekannt?',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ElevatedButton(
                    onPressed: () => _setIsFrequencyKnown(true),
                    child: const Text('Ja'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _setIsFrequencyKnown(false),
                    child: const Text('Nein'),
                  ),
                ],
              ),
            if (_isFrequencyKnown == true && _specificFrequency == null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                      'Frage 3: Welche spezifische Frequenz entspricht Ihrem Tinnitus?',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ElevatedButton(
                    onPressed: () => _setSpecificFrequency('250 Hz'),
                    child: const Text('250 Hz'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _setSpecificFrequency('500 Hz'),
                    child: const Text('500 Hz'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _setSpecificFrequency('1000 Hz'),
                    child: const Text('1000 Hz'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _setSpecificFrequency('2000 Hz'),
                    child: const Text('2000 Hz'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _setSpecificFrequency('3000 Hz'),
                    child: const Text('3000 Hz'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _setSpecificFrequency('4000 Hz'),
                    child: const Text('4000 Hz'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _setSpecificFrequency('6000 Hz'),
                    child: const Text('6000 Hz'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _setSpecificFrequency('8000 Hz'),
                    child: const Text('8000 Hz'),
                  ),
                ],
              ),
            if (_finalRecommendation == null &&
                (_isFrequencyKnown == false || _specificFrequency != null))
              ElevatedButton(
                onPressed: _updateRecommendation,
                child: const Text('Empfehlungen anzeigen'),
              ),
            if (_finalRecommendation != null)
              Text(_finalRecommendation!,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _goBack,
              child: const Text('Zurück'),
            ),
          ],
        ),
      ),
    );
  }
}
