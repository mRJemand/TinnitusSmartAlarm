import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  final List<String> _finalCategoryNames = [];
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
    });
  }

  void _setIsFrequencyKnown(bool value) {
    setState(() {
      _isFrequencyKnown = value;
      _specificFrequency = null;
    });
    if (!value) {
      _updateRecommendation();
    }
  }

  void _setSpecificFrequency(String value) {
    setState(() {
      _specificFrequency = value;
    });
    _updateRecommendation();
  }

  void _goBack() {
    if (_finalCategoryNames.isNotEmpty) {
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
        title: Text(AppLocalizations.of(context)!.stimulationFilterWizard),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (_tinnitusType == null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      AppLocalizations.of(context)!.whatTypeOfTinnitusDoYouHave,
                      style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _setTinnitusType('Tonaler Tinnitus'),
                      child: Text(
                          AppLocalizations.of(context)!.tonalTinnitusWithEg),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () =>
                          _setTinnitusType('Rauschähnlicher Tinnitus'),
                      child: Text(AppLocalizations.of(context)!
                          .noiseLikeTinnitusWithEg),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _setTinnitusType('Gemischter Tinnitus'),
                      child: Text(
                          AppLocalizations.of(context)!.mixedTinnitusWithEg),
                    ),
                  ),
                ],
              ),
            if (_tinnitusType != null && _isFrequencyKnown == null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      AppLocalizations.of(context)!
                          .isYourTinnitusFrequencyKnown,
                      style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _setIsFrequencyKnown(true),
                      child: Text(AppLocalizations.of(context)!.yes),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _setIsFrequencyKnown(false),
                      child: Text(AppLocalizations.of(context)!.no),
                    ),
                  ),
                ],
              ),
            if (_isFrequencyKnown == true && _specificFrequency == null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      AppLocalizations.of(context)!
                          .whichSpecificFrequencyCorrespondsToYourTinnitus,
                      style: Theme.of(context).textTheme.titleMedium),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _setSpecificFrequency('250 Hz'),
                      child: const Text('250 Hz'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _setSpecificFrequency('500 Hz'),
                      child: const Text('500 Hz'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _setSpecificFrequency('1000 Hz'),
                      child: const Text('1000 Hz'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _setSpecificFrequency('2000 Hz'),
                      child: const Text('2000 Hz'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _setSpecificFrequency('3000 Hz'),
                      child: const Text('3000 Hz'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _setSpecificFrequency('4000 Hz'),
                      child: const Text('4000 Hz'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _setSpecificFrequency('6000 Hz'),
                      child: const Text('6000 Hz'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _setSpecificFrequency('8000 Hz'),
                      child: const Text('8000 Hz'),
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
