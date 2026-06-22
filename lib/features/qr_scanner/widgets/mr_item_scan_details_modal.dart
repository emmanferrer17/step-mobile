import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile/app/config/constants.dart';
import 'package:mobile/app/config/ui_constants.dart';

class MrItemScanDetailsModal extends StatelessWidget {
  final Map<String, dynamic> itemDetails;

  const MrItemScanDetailsModal({super.key, required this.itemDetails});

  String _formatDate(String? dateString) {
    if (dateString == null || dateString == 'N/A') return 'N/A';
    try {
      final DateTime dt = DateTime.parse(dateString);
      return "${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}/${dt.year}";
    } catch (e) {
      return dateString;
    }
  }

  // Fix #3: same SVG assets as home_page.dart category chips
  String _categoryIconPath(String category) {
    switch (category) {
      case 'Equipment':
        return 'assets/images/equipment.svg';
      case 'Semi-Expendable':
        return 'assets/images/semi-expendable.svg';
      default:
        return 'assets/images/all.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    final String name        = itemDetails['item_name']     ?? 'N/A';
    final String spec        = itemDetails['specification'] ?? 'N/A';
    final String owner       = itemDetails['owner']         ?? 'N/A';
    final String dateScanned = itemDetails['date_scanned']  ?? 'N/A';
    final String category    = itemDetails['category']      ?? '';
    final String? image      = itemDetails['image'];

    final bool hasImage     = image != null && image.trim().isNotEmpty;
    final String iconPath   = _categoryIconPath(category);

    return hasImage
        ? _buildHasImageLayout(context, name, spec, owner, dateScanned, iconPath, image)
        : _buildNoImageLayout(context, name, spec, owner, dateScanned, iconPath);
  }

  // ─── Shared header row: back arrow + category badge + item name ─────────────
  Widget _buildHeader(BuildContext context, String name, String iconPath) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Fix #1: back arrow is now in the same row as icon + name
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: Icon(Icons.arrow_back, color: Colors.black87, size: 24.s),
          onPressed: () => Navigator.pop(context),
        ),
        SizedBox(width: 10.s),
        // Category badge using the same SVG as home_page.dart
        Container(
          width: 36.s,
          height: 36.s,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFBA1A1A),
          ),
          child: Center(
            child: SvgPicture.asset(
              iconPath,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              width: 20.s,
              height: 20.s,
            ),
          ),
        ),
        SizedBox(width: 10.s),
        Expanded(
          child: Text(
            name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xFFBA1A1A),
              fontSize: 17.s,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // ─── Layout 1: No Image ─────────────────────────────────────────────────────
  Widget _buildNoImageLayout(
    BuildContext context,
    String name,
    String spec,
    String owner,
    String dateScanned,
    String iconPath,
  ) {
    return Container(
      padding: EdgeInsets.fromLTRB(12.s, 14.s, 16.s, 20.s),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.s),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fix #1: single row — back arrow + badge + name, all on same line
          _buildHeader(context, name, iconPath),
          Divider(height: 24.s, color: const Color(0xFFEEEEEE)),
          _buildDetailRow('Owner',         owner),
          _buildDetailRow('Specification', spec),
          _buildDetailRow('Date Received', _formatDate(dateScanned)),
          SizedBox(height: 4.s),
        ],
      ),
    );
  }

  // ─── Layout 2: Has Image ────────────────────────────────────────────────────
  // Fix #2: header (back + badge + name) at top, then image, then details.
  // Back arrow replaces the X close button.
  Widget _buildHasImageLayout(
    BuildContext context,
    String name,
    String spec,
    String owner,
    String dateScanned,
    String iconPath,
    String imagePath,
  ) {
    final String fullImageUrl = '${ApiConstants.storageUrl}$imagePath';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.s),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header — identical to Layout 1
          Padding(
            padding: EdgeInsets.fromLTRB(12.s, 14.s, 16.s, 0),
            child: _buildHeader(context, name, iconPath),
          ),

          Divider(
            height: 20.s,
            color: const Color(0xFFEEEEEE),
            indent: 16.s,
            endIndent: 16.s,
          ),

          // Full-width image
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.s),
            child: AspectRatio(
              aspectRatio: 1.33,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.s),
                child: Image.network(
                  fullImageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.broken_image,
                      size: 50.s,
                      color: const Color(0xFFBA1A1A),
                    ),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 8.s),

          // Fix #2 + #6: details sit directly below image, with increased left padding
          Padding(
            padding: EdgeInsets.fromLTRB(28.s, 4.s, 16.s, 20.s),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDetailRow('Owner',         owner),
                _buildDetailRow('Specification', spec),
                _buildDetailRow('Date Received', _formatDate(dateScanned)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Detail row shared by both layouts
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.s),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120.s,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14.s,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 12.s),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: const Color(0xFF333333),
                fontSize: 14.s,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
