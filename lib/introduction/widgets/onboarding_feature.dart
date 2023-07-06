// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/shared/cards/cards.dart';

class OnboardingFeature extends StatelessWidget {
  const OnboardingFeature({
    required this.icon,
    required this.title,
    required this.description,
    this.cardColor,
    super.key,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color? cardColor;

  @override
  Widget build(BuildContext context) {
    final isDarkModeOn = Theme.of(context).brightness == Brightness.dark;

    return DataCard(
      margin: EdgeInsets.zero,
      child: Row(
        children: [
          Icon(
            icon,
            size: 36,
          ),
          const SizedBox(width: Constants.listSpacing),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  description,
                  style: isDarkModeOn
                      ? Constants.descStyleDark
                      : Constants.descStyleLight,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
