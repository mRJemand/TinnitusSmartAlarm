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
            _buildPanel(
                AppLocalizations.of(context)!.objective, widget.tip.objective),
            _buildPanel(AppLocalizations.of(context)!.tip, widget.tip.tip),
            _buildPanel(AppLocalizations.of(context)!.explanation,
                widget.tip.explanation),
          ],
        ),
      ),
    );
  }

  Widget _buildPanel(String title, String content) {
    return ExpansionTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      initiallyExpanded: true,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
