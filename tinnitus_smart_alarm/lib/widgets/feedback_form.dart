import 'package:flutter/material.dart';
import 'package:tinnitus_smart_alarm/services/firestore_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FeedbackForm extends StatefulWidget {
  const FeedbackForm({Key? key}) : super(key: key);

  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  String? _email;
  String _feedbackType = '';
  String? _message;

  late List<String> _feedbackTypes;

  void _submitForm() {
    FirestoreManager firestoreManager = FirestoreManager();
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      firestoreManager.sendFeedbackToFirestore(
        name: _name,
        email: _email,
        feedbackType: _feedbackType,
        message: _message,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.feedbacksent)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _feedbackTypes = [
      AppLocalizations.of(context)!.wish,
      AppLocalizations.of(context)!.question,
      AppLocalizations.of(context)!.fault,
      AppLocalizations.of(context)!.other,
    ];
    if (_feedbackType.isEmpty) {
      _feedbackType = _feedbackTypes.first;
    }
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.name,
              border: const OutlineInputBorder(),
            ),
            onSaved: (value) => _name = value,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.email,
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (_feedbackType == AppLocalizations.of(context)!.question) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.pleaseEnterEmail;
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return AppLocalizations.of(context)!.invalidEmail;
                }
              } else if (value != null &&
                  value.isNotEmpty &&
                  !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return AppLocalizations.of(context)!.invalidEmail;
              }
              return null;
            },
            onSaved: (value) => _email = value,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.typeOfFeedback,
              border: const OutlineInputBorder(),
            ),
            value: _feedbackType,
            items: _feedbackTypes.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _feedbackType = value;
                });
              }
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.message,
              border: const OutlineInputBorder(),
            ),
            maxLines: 5,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppLocalizations.of(context)!.pleaseEnterMessage;
              }
              return null;
            },
            onSaved: (value) => _message = value,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text(AppLocalizations.of(context)!.submit),
          ),
        ],
      ),
    );
  }
}
