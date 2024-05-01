import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tinnitus_smart_alarm/services/firestore_manager.dart';

class TinnitusSurvey extends StatefulWidget {
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
            const SizedBox(
              height: 8,
            ),
            Text(
              AppLocalizations.of(context)!.question1,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              AppLocalizations.of(context)!.question1Scala,
              style: Theme.of(context).textTheme.bodySmall,
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
            Text(
              AppLocalizations.of(context)!.question2,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              AppLocalizations.of(context)!.question2Scala,
              style: Theme.of(context).textTheme.bodySmall,
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
            Text(
              AppLocalizations.of(context)!.question3,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              AppLocalizations.of(context)!.question3Scala,
              style: Theme.of(context).textTheme.bodySmall,
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
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.cancel_outlined),
                  label: Text(AppLocalizations.of(context)!.cancel),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // todo adjust stimuliName and frequency
                    FirestoreManager firestoreManager = FirestoreManager();
                    firestoreManager.sendAnswersToFirestore(
                        easyToIgnore: _ignorierbarkeit,
                        uncomfortable: _unangenehmheit,
                        volume: _lautstaerke,
                        stimuliName: 'Noch Kein Stimuli',
                        frequency: 'no frequency');
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.save_outlined),
                  label: Text(AppLocalizations.of(context)!.save),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
