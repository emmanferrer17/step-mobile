import 'package:flutter/material.dart';
import '../home/widgets/item_details_modal.dart';

/// A modern, fullscreen screen displaying the inventory Archive log matching the user's reference mockup.
class ArchivePage extends StatelessWidget {
  const ArchivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE6), // Matching home screen light beige background
      appBar: AppBar(
        backgroundColor: const Color(0xFF8C0404), // Dark red university brand color
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 26),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Archive',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            // Date Group: Today
            _buildDateGroupCard(
              context,
              dateLabel: 'Date Received: Today',
              items: [
                {'name': 'Nintendo Switch', 'po': 'PO-202601001-102'},
                {'name': 'Nintendo Switch', 'po': 'PO-202601001-101'},
              ],
            ),
            const SizedBox(height: 12),

            // Date Group: September 12, 2023
            _buildDateGroupCard(
              context,
              dateLabel: 'Date Received: September 12, 2023',
              items: [
                {'name': 'Nintendo Switch', 'po': 'PO-202601001-099'},
                {'name': 'Nintendo Switch', 'po': 'PO-202601001-100'},
              ],
            ),
            const SizedBox(height: 12),

            // Date Group: October 19, 2006
            _buildDateGroupCard(
              context,
              dateLabel: 'Date Received: October 19, 2006',
              items: [
                {'name': 'Nintendo Switch', 'po': 'PO-202601001-098'},
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Helper: builds a date-grouped card enclosing receipt logs and action items.
  Widget _buildDateGroupCard(
    BuildContext context, {
    required String dateLabel,
    required List<Map<String, String>> items,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header Bar displaying Date Received
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              dateLabel,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),

          // Item listings inside the group
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFEEEEEE)),
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Item details text
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name']!,
                          style: const TextStyle(
                            color: Color(0xFF8C0404),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['po']!,
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    // view details -> action button
                    GestureDetector(
                      onTap: () => _showItemDetailsModal(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF8C0404),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'view details',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Helper: displays the floating popup dialog showing item details when view details is tapped.
  void _showItemDetailsModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: ItemDetailsModal(),
      ),
    );
  }
}
