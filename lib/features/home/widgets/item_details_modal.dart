import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A centered dialog pop-up displaying the details of a clicked inventory item.
/// Currently uses high-fidelity hardcoded data for demonstration.
class ItemDetailsModal extends StatefulWidget {
  const ItemDetailsModal({super.key});

  @override
  State<ItemDetailsModal> createState() => _ItemDetailsModalState();
}

class _ItemDetailsModalState extends State<ItemDetailsModal> {
  bool _isDescriptionExpanded = false;
  late TapGestureRecognizer _tapGestureRecognizer;

  final String _fullDescription =
      "Custom NVIDIA T239 chip featuring an 8-core ARM Cortex-A78C CPU, 128-bit memory bus with up to 102.4 GB/s bandwidth, 1536 CUDA cores on Ampere architecture, support for DLSS 2.0 and Ray Tracing, 8GB of LPDDR5 RAM, and 64GB of expandable eMMC high-speed internal storage.";

  final String _truncatedDescription =
      "Custom NVIDIA T239 chip featuring an 8-core ARM Cortex-A78C CPU... ";

  @override
  void initState() {
    super.initState();
    _tapGestureRecognizer = TapGestureRecognizer()
      ..onTap = () {
        setState(() {
          _isDescriptionExpanded = !_isDescriptionExpanded;
        });
      };
  }

  @override
  void dispose() {
    _tapGestureRecognizer.dispose();
    super.dispose();
  }

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
                  child: Text(
                    'Nintendo Switch',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF8C0404),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 48), // Balancing width for centered title
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),

          // Scrollable Body Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Upload Photo Box with Red Border
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: const Color(0xFF8C0404),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/images/upload-photo.svg',
                          height: 95,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            debugPrint('SVG Upload Photo Error: $error');
                            return const Icon(
                              Icons.cloud_upload_outlined,
                              size: 70,
                              color: Color(0xFF8C0404),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Tap to upload photo',
                          style: TextStyle(
                            color: Color(0xFF8C0404),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 14),
                        // Divider Row with "or"
                        Row(
                          children: [
                            Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'or',
                                style: TextStyle(color: Colors.grey[400], fontSize: 13),
                              ),
                            ),
                            Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
                          ],
                        ),
                        const SizedBox(height: 14),
                        // Open Camera Button
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8C0404),
                            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Open camera',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Metadata Table / Details List
                  _buildDetailRow('Location', 'Add Location', showEdit: true),
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  _buildDetailRow('Date', '10/09/2020'),
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  _buildDetailRow('Stock', '1'),
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  _buildDetailRow('Unit', '1'),
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  _buildDescriptionDetailRow(
                    'Description',
                    _isDescriptionExpanded ? _fullDescription : _truncatedDescription,
                    _isDescriptionExpanded ? ' See less' : ' See more',
                  ),
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  _buildDetailRow('Quantity', '1'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a standard row for key-value pair item details.
  Widget _buildDetailRow(String label, String value, {bool showEdit = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: showEdit ? Colors.grey[600] : Colors.black87,
                fontSize: 15,
                fontWeight: showEdit ? FontWeight.w500 : FontWeight.bold,
              ),
            ),
          ),
          if (showEdit)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F1F1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.edit_outlined,
                size: 20,
                color: Colors.black54,
              ),
            ),
        ],
      ),
    );
  }

  /// Builds a details row specifically styled for multi-line description with tap expander.
  Widget _buildDescriptionDetailRow(String label, String text, String actionText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
                children: [
                  TextSpan(text: text),
                  TextSpan(
                    text: actionText,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                    recognizer: _tapGestureRecognizer,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
