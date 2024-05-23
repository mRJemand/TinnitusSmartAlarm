import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tinnitus_smart_alarm/services/firestore_manager.dart';

class TinnitusSurvey extends StatefulWidget {
  final String? stimuliName;
  final String? frequency;

  const TinnitusSurvey({
    super.key,
    required this.frequency,
    required this.stimuliName,
  });

  @override
  _TinnitusSurveyState createState() => _TinnitusSurveyState();
}

class _TinnitusSurveyState extends State<TinnitusSurvey> {
  double _lautstaerke = 0;
  double _unangenehmheit = 0;
  double _ignorierbarkeit = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              AppLocalizations.of(context)!.survey,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.question1,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Slider(
              value: _lautstaerke,
              min: 0,
              max: 10,
              divisions: 10,
              label: _lautstaerke.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _lautstaerke = value;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    AppLocalizations.of(context)!.question1ScalaMin,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Flexible(
                  child: Text(
                    AppLocalizations.of(context)!.question1ScalaMax,
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.question2,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Slider(
              value: _unangenehmheit,
              min: 0,
              max: 10,
              divisions: 10,
              label: _unangenehmheit.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _unangenehmheit = value;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    AppLocalizations.of(context)!.question2ScalaMin,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Flexible(
                  child: Text(
                    AppLocalizations.of(context)!.question2ScalaMax,
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.question3,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Slider(
              value: _ignorierbarkeit,
              min: 0,
              max: 10,
              divisions: 10,
              label: _ignorierbarkeit.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _ignorierbarkeit = value;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    AppLocalizations.of(context)!.question3ScalaMin,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                Flexible(
                  child: Text(
                    AppLocalizations.of(context)!.question3ScalaMax,
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.cancel_outlined),
                    label: Text(AppLocalizations.of(context)!.cancel),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      FirestoreManager firestoreManager = FirestoreManager();
                      firestoreManager.sendAnswersToFirestore(
                          easyToIgnore: _ignorierbarkeit,
                          uncomfortable: _unangenehmheit,
                          volume: _lautstaerke,
                          stimuliName: widget.stimuliName ?? '',
                          frequency: widget.frequency ?? '');
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.save_outlined),
                    label: Text(AppLocalizations.of(context)!.save),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
