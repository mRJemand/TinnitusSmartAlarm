import 'package:flutter/material.dart';

class StimuliDescriptionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stimuli Erklärung'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Erklärung verwendete Stimuli / Auditorische Stimuli für Tinnitus-Behandlung DE',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Die App beinhaltet 64 unterschiedlich konzipierte auditorische Stimuli, die in vier spezifische Kategorien gegliedert sind. Jede Kategorie beinhaltet 16 Sounds, die sich in Herkunft (natürlich oder digital) und Bezug zu Tinnitus (spezifisch oder nicht-spezifisch) unterscheiden:',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              BulletList([
                'Natürlich und spezifisch',
                'Natürlich und nicht-spezifisch',
                'Digital und spezifisch',
                'Digital und nicht-spezifisch',
              ]),
              SizedBox(height: 16),
              _buildSection(
                title: '1. Natürlich und spezifisch',
                content:
                    'Diese Kategorie umfasst natürliche Geräusche, die speziell auf eine Tinnitusfrequenz von 4 kHz abgestimmt sind, um die Wahrnehmung von Tinnitus gezielt zu beeinflussen. Beispiele hierfür sind speziell modulierte Rauschgeräusche, die helfen können, Tinnitus wahrnehmbar zu maskieren.',
                imagePath: 'assets/images/natuerlich_spezifisch.png',
              ),
              _buildSection(
                title: '2. Natürlich und nicht-spezifisch',
                content:
                    'Diese Stimuli bestehen aus natürlichen Geräuschen, die keine direkte Anpassung auf die Tinnitusfrequenz aufweisen. Sie variieren in ihrer spektralen Komplexität und temporalen Modulation, wie etwa das Rauschen von Wasserfällen oder Meereswellen, die allgemein beruhigende Effekte haben, jedoch nicht spezifisch auf Tinnitus abzielen.',
                imagePath: 'assets/images/natuerlich_nicht_spezifisch.png',
              ),
              _buildSection(
                title: '3. Digital und spezifisch',
                content:
                    'In dieser Kategorie sind digitale Sounds enthalten, die auf die Tinnitusfrequenz von 4 kHz ausgerichtet sind. Diese können durch Frequenz- und Amplitudenmodulationen gestaltet sein, um das tinnitusbezogene Hörerlebnis zu beeinflussen, beispielsweise durch Erzeugung eines Piepens oder eines pulsierenden Rauschens.',
                imagePath: 'assets/images/digital_spezifisch.png',
              ),
              _buildSection(
                title: '4. Digital und nicht-spezifisch',
                content:
                    'Diese Gruppe umfasst digitale Geräusche, die keine spezifische Ausrichtung auf die Tinnitusfrequenz haben. Sie bieten eine Vielfalt an Klängen, die für eine breitere auditive Stimulation sorgen, wie tiefere Töne und ungefiltertes digitales Rauschen, welche die Wahrnehmung von Tinnitus durch unterschiedliche akustische Umgebungen beeinflussen können.',
                imagePath: 'assets/images/digital_nicht_spezifisch.png',
              ),
              SizedBox(height: 16),
              Text(
                'Zusätzliche Überlegungen:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Die Stimuli innerhalb jeder Kategorie wurden sorgfältig nach spektraler Komplexität und temporaler Modulation ausgewählt, um die auditive Erfahrung zu maximieren. Beispiele hierfür sind das einfache Pfeifen eines Wasserkessels oder das komplexe Rauschen einer Dusche, die je nach Stimulus von minimaler bis maximaler Modulation variieren können. Diese sorgfältige Auswahl hilft, die Effektivität der Tinnitusbehandlung durch akustische Stimulation zu maximieren.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    required String imagePath,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Image.asset(
          imagePath,
          fit: BoxFit.contain,
        ),
        SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

class BulletList extends StatelessWidget {
  final List<String> items;
  BulletList(this.items);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) => _buildBulletItem(item)).toList(),
    );
  }

  Widget _buildBulletItem(String item) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(
              item,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
