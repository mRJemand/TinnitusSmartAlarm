import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingScreen extends StatelessWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({super.key, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.welcome,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context)!.welcomeText1,
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 8),
              Text(AppLocalizations.of(context)!.welcomeText2,
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 8),
              Text(AppLocalizations.of(context)!.welcomeText3,
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 8),
              Text(AppLocalizations.of(context)!.welcomeText4,
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 8),
              const Divider(),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: onComplete,
                  child: Text(AppLocalizations.of(context)!.next),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
