// stimuli_decision_tree_screen.dart
import 'package:flutter/material.dart';

class TinnitusDecisionTreeScreen extends StatefulWidget {
  final Function(List<String> categoryNames, String? frequency) onSubmitt;

  const TinnitusDecisionTreeScreen({
    Key? key,
    required this.onSubmitt,
  }) : super(key: key);

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
  List<String> _finalCategoryNames = [];
  String? _finalFrequency = '';

  void _updateRecommendation() {
    if (_tinnitusType == 'Tonaler Tinnitus') {
      if (_isFrequencyKnown == true) {
        switch (_specificFrequency) {
          case '250 Hz':
            _finalFrequency = '250 Hz';
            _finalCategoryNames.add('unnatural_pos');
            _finalCategoryNames.add('unnatural_neg');
            break;
          case '500 Hz':
            _finalFrequency = '500 Hz';
            _finalCategoryNames.add('unnatural_pos');
            _finalCategoryNames.add('unnatural_neg');
            break;
          case '1000 Hz':
            _finalFrequency = '1000 Hz';
            _finalCategoryNames.add('unnatural_pos');
            _finalCategoryNames.add('unnatural_neg');
            break;
          case '2000 Hz':
            _finalFrequency = '2000 Hz';
            _finalCategoryNames.add('unnatural_pos');
            _finalCategoryNames.add('unnatural_neg');
            break;
          case '3000 Hz':
            _finalFrequency = '3000 Hz';
            _finalCategoryNames.add('unnatural_pos');
            _finalCategoryNames.add('unnatural_neg');
            break;
          case '4000 Hz':
            _finalFrequency = '4000 Hz';
            _finalCategoryNames.add('unnatural_pos');
            _finalCategoryNames.add('unnatural_neg');
            break;
          case '6000 Hz':
            _finalFrequency = '6000 Hz';
            _finalCategoryNames.add('unnatural_pos');
            _finalCategoryNames.add('unnatural_neg');
            break;
          case '8000 Hz':
            _finalFrequency = '8000 Hz';
            _finalCategoryNames.add('unnatural_pos');
            _finalCategoryNames.add('unnatural_neg');
            break;
          default:
            _finalRecommendation =
                'Bitte wählen Sie eine gültige Frequenz aus.';
        }
      } else {
        _finalCategoryNames.add('natural_neg');
        _finalCategoryNames.add('unnatural_neg');
      }
    } else if (_tinnitusType == 'Rauschähnlicher Tinnitus') {
      if (_isFrequencyKnown == true) {
        switch (_specificFrequency) {
          case '250 Hz':
            _finalFrequency = '250 Hz';
            _finalCategoryNames.add('natural_plus');
            _finalCategoryNames.add('natural_neg');
            break;
          case '500 Hz':
            _finalFrequency = '500 Hz';
            _finalCategoryNames.add('natural_plus');
            _finalCategoryNames.add('natural_neg');
            break;

          case '1000 Hz':
            _finalFrequency = '1000 Hz';
            _finalCategoryNames.add('natural_plus');
            _finalCategoryNames.add('natural_neg');
            break;
          case '2000 Hz':
            _finalFrequency = '1000 Hz';
            _finalCategoryNames.add('natural_plus');
            _finalCategoryNames.add('natural_neg');
            break;
          case '3000 Hz':
            _finalFrequency = '3000 Hz';
            _finalCategoryNames.add('natural_plus');
            _finalCategoryNames.add('natural_neg');
            break;
          case '4000 Hz':
            _finalFrequency = '4000 Hz';
            _finalCategoryNames.add('natural_plus');
            _finalCategoryNames.add('natural_neg');
            break;
          case '6000 Hz':
            _finalFrequency = '6000 Hz';
            _finalCategoryNames.add('natural_plus');
            _finalCategoryNames.add('natural_neg');
            break;
          case '8000 Hz':
            _finalFrequency = '8000 Hz';
            _finalCategoryNames.add('natural_plus');
            _finalCategoryNames.add('natural_neg');
            break;
          default:
            _finalCategoryNames.add('natural_plus');
            _finalCategoryNames.add('natural_neg');
            _finalRecommendation =
                'Bitte wählen Sie eine gültige Frequenz aus.';
        }
      } else {
        _finalCategoryNames.add('natural_plus');
        _finalCategoryNames.add('natural_neg');
      }
    } else if (_tinnitusType == 'Gemischter Tinnitus') {
      if (_isFrequencyKnown == true) {
        switch (_specificFrequency) {
          case '250 Hz':
            _finalFrequency = '250 Hz';
            _finalCategoryNames.add('natural_plus');
            _finalCategoryNames.add('natural_neg');
            _finalCategoryNames.add('unnatural_pos');
            _finalCategoryNames.add('unnatural_neg');
            break;
          case '500 Hz':
            _finalFrequency = '500 Hz';
            _finalCategoryNames.add('natural_plus');
            _finalCategoryNames.add('natural_neg');
            _finalCategoryNames.add('unnatural_pos');
            _finalCategoryNames.add('unnatural_neg');
            break;
          case '1000 Hz':
            _finalFrequency = '1000 Hz';
            _finalCategoryNames.add('natural_plus');
            _finalCategoryNames.add('natural_neg');
            _finalCategoryNames.add('unnatural_pos');
            _finalCategoryNames.add('unnatural_neg');
            break;
          case '2000 Hz':
            _finalFrequency = '2000 Hz';
            _finalCategoryNames.add('natural_plus');
            _finalCategoryNames.add('natural_neg');
            _finalCategoryNames.add('unnatural_pos');
            _finalCategoryNames.add('unnatural_neg');
            break;
          case '3000 Hz':
            _finalFrequency = '3000 Hz';
            _finalCategoryNames.add('natural_plus');
            _finalCategoryNames.add('natural_neg');
            _finalCategoryNames.add('unnatural_pos');
            _finalCategoryNames.add('unnatural_neg');
            break;
          case '4000 Hz':
            _finalFrequency = '4000 Hz';
            _finalCategoryNames.add('natural_plus');
            _finalCategoryNames.add('natural_neg');
            _finalCategoryNames.add('unnatural_pos');
            _finalCategoryNames.add('unnatural_neg');
            break;
          case '6000 Hz':
            _finalFrequency = '6000 Hz';
            _finalCategoryNames.add('natural_plus');
            _finalCategoryNames.add('natural_neg');
            _finalCategoryNames.add('unnatural_pos');
            _finalCategoryNames.add('unnatural_neg');
            break;
          case '8000 Hz':
            _finalFrequency = '8000 Hz';
            _finalCategoryNames.add('natural_plus');
            _finalCategoryNames.add('natural_neg');
            _finalCategoryNames.add('unnatural_pos');
            _finalCategoryNames.add('unnatural_neg');
            break;
          default:
            _finalCategoryNames.add('natural_plus');
            _finalCategoryNames.add('natural_neg');
            _finalCategoryNames.add('unnatural_pos');
            _finalCategoryNames.add('unnatural_neg');
            _finalRecommendation =
                'Bitte wählen Sie eine gültige Frequenz aus.';
        }
      } else {
        _finalCategoryNames.add('natural_plus');
        _finalCategoryNames.add('natural_neg');
        _finalCategoryNames.add('unnatural_pos');
        _finalCategoryNames.add('unnatural_neg');
      }
    }

    setState(() {});
    widget.onSubmitt(_finalCategoryNames, _finalFrequency);
    Navigator.pop(context);
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
    if (_finalCategoryNames.isNotEmpty) {
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
