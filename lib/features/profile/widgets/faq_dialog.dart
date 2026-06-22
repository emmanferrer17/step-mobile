import 'package:flutter/material.dart';

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
        color: Colors.white,
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
                  icon: const Icon(Icons.arrow_back, color: Colors.black87),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'FAQs',
                      style: TextStyle(
                        color: Color(0xFFBA1A1A),
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
          const Divider(height: 1, color: Color(0xFFEEEEEE)),

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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBA1A1A).withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
            color: Color(0xFFBA1A1A),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconColor: const Color(0xFFBA1A1A),
        collapsedIconColor: const Color(0xFFBA1A1A).withOpacity(0.8),
        childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 10),
          Text(
            answer,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
