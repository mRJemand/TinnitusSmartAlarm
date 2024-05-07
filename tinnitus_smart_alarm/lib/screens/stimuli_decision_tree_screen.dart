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
  String? _stimuliType;
  String? _finalRecommendation;

  void _updateRecommendation() {
    if (_tinnitusType == 'Tonaler Tinnitus') {
      if (_isFrequencyKnown == true) {
        switch (_specificFrequency) {
          case '250 Hz':
            _finalRecommendation = '''
Empfehlung:
- Notched Noise (`wn_am_10_notch_250.mp3`)
''';
            break;
          case '500 Hz':
            _finalRecommendation = '''
Empfehlung:
- Notched Noise (`wn_am_10_notch_500.mp3`)
''';
            break;
          case '3000 Hz':
            _finalRecommendation = '''
Empfehlung:
- Notched Noise (`wn_am_10_notch_3000.mp3`)
''';
            break;
          case '4000 Hz':
            _finalRecommendation = '''
Empfehlung:
- Natürliche Stimuli: Notched Music (`notched_music_4000.mp3`)
- Digitale Stimuli:
  - Notched Noise (`wn_am_10_notch_4000.mp3`)
  - Amplitudenmodulierte Töne (`wn_am_10_notch_4000.mp3`)
  - Frequenzmodulierte Töne (`wn_fm_10_notch_4000.mp3`)
''';
            break;
          case '6000 Hz':
            _finalRecommendation = '''
Empfehlung:
- Notched Noise (`wn_am_10_notch_6000.mp3`)
''';
            break;
          case '8000 Hz':
            _finalRecommendation = '''
Empfehlung:
- Notched Noise (`wn_am_10_notch_8000.mp3`)
''';
            break;
          default:
            _finalRecommendation =
                'Bitte wählen Sie eine gültige Frequenz aus.';
        }
      } else {
        _finalRecommendation = '''
Empfehlung:
- Natürliche Stimuli:
  - Wasserfallrauschen (`waterfall.mp3`)
  - Vogelgezwitscher (`birds.mp3`)
  - Meeresrauschen (`sea_waves.mp3`)
- Digitale Stimuli:
  - Weißes Rauschen (`wn.mp3`)
  - Rosa Rauschen (`pink_noise.mp3`)
''';
      }
    } else if (_tinnitusType == 'Rauschähnlicher Tinnitus') {
      if (_isFrequencyKnown == true) {
        switch (_specificFrequency) {
          case '250 Hz':
            _finalRecommendation = '''
Empfehlung:
- Notched Noise (`wn_am_10_notch_250.mp3`)
''';
            break;
          case '500 Hz':
            _finalRecommendation = '''
Empfehlung:
- Notched Noise (`wn_am_10_notch_500.mp3`)
''';
            break;
          case '3000 Hz':
            _finalRecommendation = '''
Empfehlung:
- Notched Noise (`wn_am_10_notch_3000.mp3`)
''';
            break;
          case '4000 Hz':
            _finalRecommendation = '''
Empfehlung:
- Natürliche Stimuli: Notched Music (`notched_music_4000.mp3`)
- Digitale Stimuli:
  - Notched Noise (`wn_am_10_notch_4000.mp3`)
  - Amplitudenmodulierte Töne (`wn_am_10_notch_4000.mp3`)
  - Frequenzmodulierte Töne (`wn_fm_10_notch_4000.mp3`)
''';
            break;
          case '6000 Hz':
            _finalRecommendation = '''
Empfehlung:
- Notched Noise (`wn_am_10_notch_6000.mp3`)
''';
            break;
          case '8000 Hz':
            _finalRecommendation = '''
Empfehlung:
- Notched Noise (`wn_am_10_notch_8000.mp3`)
''';
            break;
          default:
            _finalRecommendation =
                'Bitte wählen Sie eine gültige Frequenz aus.';
        }
      } else {
        _finalRecommendation = '''
Empfehlung:
- Natürliche Stimuli:
  - Meeresrauschen (`sea_waves.mp3`)
  - Wasserfallrauschen (`waterfall.mp3`)
  - Regenrauschen (`rain.mp3`)
  - Blätterrauschen (`leaves.mp3`)
  - Kaminfeuer (`fireplace.mp3`)
- Digitale Stimuli:
  - Weißes Rauschen (`wn.mp3`)
  - Rosa Rauschen (`pink_noise.mp3`)
''';
      }
    } else if (_tinnitusType == 'Gemischter Tinnitus') {
      if (_isFrequencyKnown == true) {
        switch (_specificFrequency) {
          case '250 Hz':
            _finalRecommendation = '''
Empfehlung:
- Notched Noise (`wn_am_10_notch_250.mp3`)
''';
            break;
          case '500 Hz':
            _finalRecommendation = '''
Empfehlung:
- Notched Noise (`wn_am_10_notch_500.mp3`)
''';
            break;
          case '3000 Hz':
            _finalRecommendation = '''
Empfehlung:
- Notched Noise (`wn_am_10_notch_3000.mp3`)
''';
            break;
          case '4000 Hz':
            _finalRecommendation = '''
Empfehlung:
- Natürliche Stimuli: Notched Music (`notched_music_4000.mp3`)
- Digitale Stimuli:
  - Notched Noise (`wn_am_10_notch_4000.mp3`)
  - Amplitudenmodulierte Töne (`wn_am_10_notch_4000.mp3`)
  - Frequenzmodulierte Töne (`wn_fm_10_notch_4000.mp3`)
''';
            break;
          case '6000 Hz':
            _finalRecommendation = '''
Empfehlung:
- Notched Noise (`wn_am_10_notch_6000.mp3`)
''';
            break;
          case '8000 Hz':
            _finalRecommendation = '''
Empfehlung:
- Notched Noise (`wn_am_10_notch_8000.mp3`)
''';
            break;
          default:
            _finalRecommendation =
                'Bitte wählen Sie eine gültige Frequenz aus.';
        }
      } else {
        _finalRecommendation = '''
Empfehlung:
- Natürliche Stimuli:
  - Meeresrauschen (`sea_waves.mp3`)
  - Wasserfallrauschen (`waterfall.mp3`)
  - Regenrauschen (`rain.mp3`)
- Digitale Stimuli:
  - Weißes Rauschen (`wn.mp3`)
  - Rosa Rauschen (`pink_noise.mp3`)
''';
      }
    }

    setState(() {});
  }

  void _goBack() {
    if (_finalRecommendation != null) {
      _finalRecommendation = null;
    } else if (_specificFrequency != null) {
      _specificFrequency = null;
    } else if (_stimuliType != null) {
      _stimuliType = null;
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
                  ListTile(
                    title:
                        const Text('Tonaler Tinnitus (z.B. Klingeln, Piepen)'),
                    leading: Radio<String>(
                      value: 'Tonaler Tinnitus',
                      groupValue: _tinnitusType,
                      onChanged: (value) {
                        setState(() {
                          _tinnitusType = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text(
                        'Rauschähnlicher Tinnitus (z.B. Rauschen, Zischen)'),
                    leading: Radio<String>(
                      value: 'Rauschähnlicher Tinnitus',
                      groupValue: _tinnitusType,
                      onChanged: (value) {
                        setState(() {
                          _tinnitusType = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text(
                        'Gemischter Tinnitus (Kombination aus beiden Tinnitus-Typen)'),
                    leading: Radio<String>(
                      value: 'Gemischter Tinnitus',
                      groupValue: _tinnitusType,
                      onChanged: (value) {
                        setState(() {
                          _tinnitusType = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            if (_tinnitusType != null && _isFrequencyKnown == null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Frage 2: Ist Ihre Tinnitusfrequenz bekannt?',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ListTile(
                    title: const Text('Ja'),
                    leading: Radio<bool>(
                      value: true,
                      groupValue: _isFrequencyKnown,
                      onChanged: (value) {
                        setState(() {
                          _isFrequencyKnown = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Nein'),
                    leading: Radio<bool>(
                      value: false,
                      groupValue: _isFrequencyKnown,
                      onChanged: (value) {
                        setState(() {
                          _isFrequencyKnown = value;
                        });
                      },
                    ),
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
                  ListTile(
                    title: const Text('250 Hz'),
                    leading: Radio<String>(
                      value: '250 Hz',
                      groupValue: _specificFrequency,
                      onChanged: (value) {
                        setState(() {
                          _specificFrequency = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('500 Hz'),
                    leading: Radio<String>(
                      value: '500 Hz',
                      groupValue: _specificFrequency,
                      onChanged: (value) {
                        setState(() {
                          _specificFrequency = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('3000 Hz'),
                    leading: Radio<String>(
                      value: '3000 Hz',
                      groupValue: _specificFrequency,
                      onChanged: (value) {
                        setState(() {
                          _specificFrequency = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('4000 Hz'),
                    leading: Radio<String>(
                      value: '4000 Hz',
                      groupValue: _specificFrequency,
                      onChanged: (value) {
                        setState(() {
                          _specificFrequency = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('6000 Hz'),
                    leading: Radio<String>(
                      value: '6000 Hz',
                      groupValue: _specificFrequency,
                      onChanged: (value) {
                        setState(() {
                          _specificFrequency = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('8000 Hz'),
                    leading: Radio<String>(
                      value: '8000 Hz',
                      groupValue: _specificFrequency,
                      onChanged: (value) {
                        setState(() {
                          _specificFrequency = value;
                        });
                      },
                    ),
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
