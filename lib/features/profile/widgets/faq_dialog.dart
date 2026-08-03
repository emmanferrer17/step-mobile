import 'package:flutter/material.dart';
import '../../../app/config/app_colors.dart';

/// A centered dialog pop-up displaying the system FAQs in an elegant, interactive manner.
class FaqDialog extends StatelessWidget {
  const FaqDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: AppColors.modalBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Modal Top Navigation Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: AppColors.textDark),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'FAQs',
                      style: TextStyle(
                        color: AppColors.primaryRed,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48), // Spacer to balance the back button
              ],
            ),
          ),
          Divider(height: 1, color: AppColors.divider),

          // Scrollable FAQ Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Theme(
                // Remove the default expansion tile border lines for a cleaner card layout
                data: Theme.of(context).copyWith(
                  dividerColor: Colors.transparent,
                ),
                child: Column(
                  children: [
                    _buildFaqItem(
                      question: 'Lorem Ipsum Dolor Sit Amet?',
                      answer: 'Lorem Ipsum Dolor Sit Amet, consectetur adipiscing elit. Aenean euismod bibendum laoreet. Proin gravida dolor sit amet.',
                    ),
                    const SizedBox(height: 12),
                    _buildFaqItem(
                      question: 'Lorem Ipsum Dolor Sit Amet?',
                      answer: 'Lorem Ipsum Dolor Sit Amet, consectetur adipiscing elit. Aenean euismod bibendum laoreet. Proin gravida dolor sit amet.',
                    ),
                    const SizedBox(height: 12),
                    _buildFaqItem(
                      question: 'Lorem Ipsum Dolor Sit Amet?',
                      answer: 'Lorem Ipsum Dolor Sit Amet, consectetur adipiscing elit. Aenean euismod bibendum laoreet. Proin gravida dolor sit amet.',
                    ),
                    const SizedBox(height: 12),
                    _buildFaqItem(
                      question: 'Lorem Ipsum Dolor Sit Amet?',
                      answer: 'Lorem Ipsum Dolor Sit Amet, consectetur adipiscing elit. Aenean euismod bibendum laoreet. Proin gravida dolor sit amet.',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper: builds an elegantly styled expandable FAQ card.
  Widget _buildFaqItem({required String question, required String answer}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryRed.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: TextStyle(
            color: AppColors.primaryRed,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconColor: AppColors.primaryRed,
        collapsedIconColor: AppColors.primaryRed.withOpacity(0.8),
        childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 10),
          Text(
            answer,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textDark,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
