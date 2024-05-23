import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrivacyConsentScreen extends StatelessWidget {
  final Function(bool) onConsent;

  const PrivacyConsentScreen({required this.onConsent});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.dataProtection)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.dataProtectionNotice,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(
                height: 8.0,
              ),
              Text(
                AppLocalizations.of(context)!.dataPrivacyText,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () => onConsent(false),
                    child: Text(AppLocalizations.of(context)!.decline),
                  ),
                  ElevatedButton(
                    onPressed: () => onConsent(true),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    child: Text(AppLocalizations.of(context)!.agree),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
