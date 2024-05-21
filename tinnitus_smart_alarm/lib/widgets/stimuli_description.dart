import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StimuliDescriptionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.stimuliDescriptionTitle,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.stimuliDescription1,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            _buildSection(
              title: AppLocalizations.of(context)!.naturalPlus,
              content:
                  AppLocalizations.of(context)!.stimuliDescriptionPartNatSpec,
              imagePath: 'assets/images/natuerlich_spezifisch.png',
            ),
            _buildSection(
              title: AppLocalizations.of(context)!.naturalNeg,
              content: AppLocalizations.of(context)!
                  .stimuliDescriptionPartNatNotSpec,
              imagePath: 'assets/images/natuerlich_nicht_spezifisch.png',
            ),
            _buildSection(
              title: AppLocalizations.of(context)!.unnaturalPos,
              content: AppLocalizations.of(context)!
                  .stimuliDescriptionPartDigitalSpec,
              imagePath: 'assets/images/digital_spezifisch.png',
            ),
            _buildSection(
              title: AppLocalizations.of(context)!.unnaturalNeg,
              content: AppLocalizations.of(context)!
                  .stimuliDescriptionPartDigitalNotSpec,
              imagePath: 'assets/images/digital_nicht_spezifisch.png',
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!
                  .stimuliDescriptionAdditionalConsiderationsTitle,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!
                  .stimuliDescriptionAdditionalConsiderationsText,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!
                  .stimuliDescriptionPersonalizationTitle,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!
                  .stimuliDescriptionPersonalizationText,
              style: const TextStyle(fontSize: 16),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.close_outlined),
                label: Text(AppLocalizations.of(context)!.close),
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
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
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Image.asset(
          imagePath,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(fontSize: 16),
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
