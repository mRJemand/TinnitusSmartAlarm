import 'package:flutter/material.dart';
import 'package:tinnitus_smart_alarm/models/tip.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TipDetailScreen extends StatefulWidget {
  final Tip tip;

  const TipDetailScreen({Key? key, required this.tip}) : super(key: key);

  @override
  _TipDetailScreenState createState() => _TipDetailScreenState();
}

class _TipDetailScreenState extends State<TipDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tip.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ExpansionTile(
              expandedAlignment: FractionalOffset.topLeft,
              title: Row(
                children: [
                  const Icon(Icons.track_changes),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    AppLocalizations.of(context)!.objective,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              initiallyExpanded: true,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    widget.tip.objective,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            ExpansionTile(
              expandedAlignment: FractionalOffset.topLeft,
              title: Row(
                children: [
                  const Icon(Icons.tips_and_updates_outlined),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    AppLocalizations.of(context)!.tip,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              initiallyExpanded: true,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    widget.tip.tip,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            ExpansionTile(
              expandedAlignment: FractionalOffset.topLeft,
              title: Row(
                children: [
                  const Icon(Icons.description_outlined),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    AppLocalizations.of(context)!.explanation,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              initiallyExpanded: true,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    widget.tip.explanation,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPanel(String title, String content) {
    return ExpansionTile(
      expandedAlignment: FractionalOffset.topLeft,
      title: Row(
        children: [
          Icon(Icons.access_alarm_sharp),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.left,
          ),
        ],
      ),
      initiallyExpanded: true,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }
}
