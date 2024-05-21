import 'package:flutter/material.dart';
import 'package:tinnitus_smart_alarm/widgets/feedback_form.dart';

class FeedbackFormPage extends StatelessWidget {
  const FeedbackFormPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback Formular'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: FeedbackForm(),
      ),
    );
  }
}
