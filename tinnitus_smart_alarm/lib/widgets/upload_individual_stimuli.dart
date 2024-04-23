import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinnitus_smart_alarm/models/stimuli.dart';
import 'package:tinnitus_smart_alarm/services/dialogs.dart';
import 'package:tinnitus_smart_alarm/services/stimuli_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

class UploadIndividualStimuli extends StatefulWidget {
  const UploadIndividualStimuli({super.key});

  @override
  State<UploadIndividualStimuli> createState() =>
      _UploadIndividualStimuliState();
}

class _UploadIndividualStimuliState extends State<UploadIndividualStimuli> {
  TextEditingController displaynameController = TextEditingController();
  bool hasSpecialFrequency = false;
  String? selectedFrequency;
  String? filepath;
  final _formKey = GlobalKey<FormState>();

  final List<String> frequencies = [
    '250 Hz',
    '500 Hz',
    '1000 Hz',
    '2000 Hz',
    '3000 Hz',
    '4000 Hz',
    '6000 Hz',
    '8000 Hz'
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: displaynameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.pleaseEnterSomeText;
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.displayname,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.text_fields),
              ),
            ),
            const SizedBox(height: 10),
            SwitchListTile(
              title: Text(AppLocalizations.of(context)!.frequencySpecific),
              value: hasSpecialFrequency,
              onChanged: (bool value) {
                setState(
                  () {
                    hasSpecialFrequency = value;
                  },
                );
              },
              secondary: const Icon(Icons.hearing),
            ),
            if (hasSpecialFrequency)
              Column(
                children: [
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.selectFrequency,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.waves),
                    ),
                    value: selectedFrequency,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedFrequency = newValue!;
                      });
                    },
                    items: frequencies
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            if (filepath != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "${AppLocalizations.of(context)!.selectedFile}: ${p.basename(filepath!)}"),
              ),
            ElevatedButton.icon(
              onPressed: () => _pickFile(),
              icon: const Icon(Icons.audio_file_outlined),
              label: Text(filepath == null
                  ? AppLocalizations.of(context)!.chooseFile
                  : AppLocalizations.of(context)!.chooseDifferentFile),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _saveForm(context);
                }
              },
              icon: const Icon(Icons.save_outlined),
              label: Text(AppLocalizations.of(context)!.save),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        filepath = result.files.single.path;
      });
    }
  }

  Future<void> _saveForm(BuildContext context) async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String newFilePath = p.join(appDir.path, p.basename(filepath!));

    File originalFile = File(filepath!);
    await originalFile.copy(newFilePath);

    StimuliManager stimuliManager = StimuliManager();
    var uuid = Uuid();
    Stimuli newStimuli = Stimuli(
      id: uuid.v1(),
      categoryId: 5,
      categoryName: 'individual',
      displayName: displaynameController.text,
      filename: p.basename(newFilePath),
      filepath: newFilePath,
      frequency: hasSpecialFrequency ? selectedFrequency : null,
      hasSpecialFrequency: hasSpecialFrequency,
      isIndividual: true,
    );

    try {
      await stimuliManager.addStimuli(newStimuli);
      Navigator.pop(context, true);
    } catch (e) {
      Dialogs.showErrorDialog(context, e.toString());
    }
  }

  @override
  void dispose() {
    displaynameController.dispose();
    super.dispose();
  }
}
