import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../app/config/constants.dart';

/// A centered dialog pop-up displaying the details of a clicked inventory item.
class ItemDetailsModal extends StatefulWidget {
  final Map<String, dynamic> itemDetails;
  
  const ItemDetailsModal({super.key, required this.itemDetails});

  @override
  State<ItemDetailsModal> createState() => _ItemDetailsModalState();
}

class _ItemDetailsModalState extends State<ItemDetailsModal> {
  bool _isDescriptionExpanded = false;
  late TapGestureRecognizer _tapGestureRecognizer;
  
  // Location editing UI state variables
  bool _isEditingLocation = false;
  late TextEditingController _buildingController;
  late TextEditingController _roomController;
  String? _currentLocation;

  @override
  void initState() {
    super.initState();
    _tapGestureRecognizer = TapGestureRecognizer()
      ..onTap = () {
        setState(() {
          _isDescriptionExpanded = !_isDescriptionExpanded;
        });
      };

    // Initialize location state
    _currentLocation = widget.itemDetails['location'];
    if (_currentLocation == 'Unknown Location') {
      _currentLocation = null;
    }

    // Parse existing location into building and room controllers
    String building = '';
    String room = '';
    if (_currentLocation != null && _currentLocation!.isNotEmpty) {
      final parts = _currentLocation!.split(',');
      if (parts.length > 1) {
        building = parts[0].trim();
        room = parts[1].trim();
      } else {
        building = _currentLocation!.trim();
      }
    }
    _buildingController = TextEditingController(text: building);
    _roomController = TextEditingController(text: room);
  }

  @override
  void dispose() {
    _tapGestureRecognizer.dispose();
    _buildingController.dispose();
    _roomController.dispose();
    super.dispose();
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'N/A';
    try {
      final DateTime dt = DateTime.parse(dateString);
      return "${dt.month.toString().padLeft(2, '0')}/${dt.day.toString().padLeft(2, '0')}/${dt.year}";
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.itemDetails['item_name'] ?? 'Unknown Item';
    final location = widget.itemDetails['location'] ?? 'Unknown Location';
    final quantity = widget.itemDetails['quantity']?.toString() ?? '1';
    final unit = widget.itemDetails['unit'] ?? 'pcs';
    final stock = widget.itemDetails['stock'] ?? 'N/A';
    final imagePath = widget.itemDetails['item_image'];
    final dateScanned = widget.itemDetails['date_scanned'];
    final description = widget.itemDetails['specification'] ?? 'No specifications provided.';

    final bool isDescLong = description.length > 80;
    final String displayDescription = _isDescriptionExpanded 
        ? description 
        : (isDescLong ? "${description.substring(0, 80)}... " : description);

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
                Expanded(
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF8C0404),
                      fontSize: 18,
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
                  // Photo display area
                  Container(
                    width: double.infinity,
                    height: imagePath != null ? 180 : 205,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: const Color(0xFF8C0404),
                        width: 1.5,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: imagePath != null
                        ? Image.network(
                            '${ApiConstants.storageUrl}$imagePath',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => const Center(
                              child: Icon(Icons.broken_image, size: 50, color: Color(0xFF8C0404)),
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/upload-photo.svg',
                                height: 75,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  debugPrint('SVG Upload Photo Error: $error');
                                  return const Icon(
                                    Icons.cloud_upload_outlined,
                                    size: 55,
                                    color: Color(0xFF8C0404),
                                  );
                                },
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Tap to upload photo',
                                style: TextStyle(
                                  color: Color(0xFF8C0404),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(
                                      'or',
                                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                                    ),
                                  ),
                                  Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF8C0404),
                                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'Open camera',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                  const SizedBox(height: 18),

                  // Metadata Table / Details List
                  _buildLocationRow(),
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  _buildDetailRow('Date Scanned', _formatDate(dateScanned)),
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  _buildDetailRow('Stock No.', stock),
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  _buildDetailRow('Unit', unit),
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  _buildDescriptionDetailRow(
                    'Description',
                    displayDescription,
                    isDescLong ? (_isDescriptionExpanded ? ' See less' : ' See more') : '',
                  ),
                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  _buildDetailRow('Quantity', quantity),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a standard row for key-value pair item details.
  Widget _buildDetailRow(String label, String value) {
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
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the Location row supporting View Mode and Edit Mode.
  Widget _buildLocationRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        crossAxisAlignment: _isEditingLocation ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 110,
            child: Text(
              'Location',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: _isEditingLocation
                ? _buildLocationEditFields()
                : _buildLocationViewMode(),
          ),
        ],
      ),
    );
  }

  /// View Mode: displays location string or "Add Location" placeholder with a pencil icon
  Widget _buildLocationViewMode() {
    final bool hasLocation = _currentLocation != null && _currentLocation!.isNotEmpty;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            hasLocation ? _currentLocation! : 'Add Location',
            style: TextStyle(
              color: hasLocation ? Colors.black87 : Colors.grey.shade500,
              fontSize: 15,
              fontWeight: hasLocation ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            setState(() {
              _isEditingLocation = true;
            });
          },
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.edit_outlined,
              color: Colors.black87,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  /// Edit Mode: displays Building / Office & Room number TextFields with save/cancel options
  Widget _buildLocationEditFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Building / Office
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _buildingController,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              hintText: 'Building / Office',
              hintStyle: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Room number
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _roomController,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              hintText: 'Room number',
              hintStyle: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Check (save) & X (cancel) buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Save Button
            GestureDetector(
              onTap: () {
                setState(() {
                  final b = _buildingController.text.trim();
                  final r = _roomController.text.trim();
                  if (b.isNotEmpty && r.isNotEmpty) {
                    _currentLocation = '$b, $r';
                  } else if (b.isNotEmpty) {
                    _currentLocation = b;
                  } else if (r.isNotEmpty) {
                    _currentLocation = r;
                  } else {
                    _currentLocation = null;
                  }
                  _isEditingLocation = false;
                });
              },
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF8C0404),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Cancel Button
            GestureDetector(
              onTap: () {
                setState(() {
                  // Revert inputs
                  String building = '';
                  String room = '';
                  if (_currentLocation != null && _currentLocation!.isNotEmpty) {
                    final parts = _currentLocation!.split(',');
                    if (parts.length > 1) {
                      building = parts[0].trim();
                      room = parts[1].trim();
                    } else {
                      building = _currentLocation!.trim();
                    }
                  }
                  _buildingController.text = building;
                  _roomController.text = room;
                  _isEditingLocation = false;
                });
              },
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F2F2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ],
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
                  fontFamily: 'Nunito',
                ),
                children: [
                  TextSpan(text: text),
                  if (actionText.isNotEmpty)
                    TextSpan(
                      text: actionText,
                      style: const TextStyle(
                        color: Color(0xFF8C0404),
                        fontWeight: FontWeight.bold,
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
