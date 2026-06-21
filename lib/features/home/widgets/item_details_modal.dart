import 'dart:io';
import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../app/config/constants.dart';
import '../../../app/config/size_config.dart';
import '../../../app/config/ui_constants.dart';
import '../../../app/controllers/home_controller.dart';
import '../../shared/widgets/camera_permission_modal.dart';
import '../../shared/widgets/gallery_access_modal.dart';
import '../../shared/widgets/full_screen_image_viewer.dart';
import '../../shared/widgets/custom_alert_dialog.dart';
import '../../shared/widgets/confirmation_dialog.dart';

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
  late TextEditingController _buildingController;
  late TextEditingController _roomController;
  String? _currentLocation;

  // Image editing UI state variables
  final List<File> _tempSelectedImages = [];
  bool _isUploading = false;
  List<String> _currentImagePaths = [];
  bool _isAddingMore = false;
  int _currentCarouselIndex = 0;
  final PageController _pageController = PageController();

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
      // Support both new " - " and old ", " formats
      final parts = _currentLocation!.contains(' - ') 
          ? _currentLocation!.split(' - ')
          : _currentLocation!.split(',');

      if (parts.length > 1) {
        building = parts[0].trim();
        room = parts[1].trim();
      } else {
        building = _currentLocation!.trim();
      }
    }
    _buildingController = TextEditingController(text: building);
    _roomController = TextEditingController(text: room);

    // Initialize image state
    _initializeImages(widget.itemDetails['item_images']);
  }

  void _initializeImages(dynamic rawImages) {
    _currentImagePaths = [];
    
    if (rawImages != null && rawImages is List) {
      for (var img in rawImages) {
        if (img is Map && img.containsKey('img_path')) {
          _currentImagePaths.add(img['img_path'].toString());
        } else if (img is String) {
          _currentImagePaths.add(img);
        }
      }
    } else if (rawImages is String && rawImages.isNotEmpty) {
      // Fallback for old data or single string paths
      try {
        final decoded = json.decode(rawImages);
        if (decoded is List) {
          for (var item in decoded) {
            if (item is Map && item.containsKey('img_path')) {
              _currentImagePaths.add(item['img_path'].toString());
            } else {
              _currentImagePaths.add(item.toString());
            }
          }
        } else {
          _currentImagePaths = [rawImages.trim()];
        }
      } catch (e) {
        _currentImagePaths = [rawImages.trim()];
      }
    }
  }

  @override
  void dispose() {
    _tapGestureRecognizer.dispose();
    _buildingController.dispose();
    _roomController.dispose();
    _pageController.dispose();
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
    SizeConfig().init(context);
    final name = widget.itemDetails['item_name'] ?? 'Unknown Item';
    final quantity = widget.itemDetails['quantity']?.toString() ?? '1';
    final unit = widget.itemDetails['unit'] ?? 'pcs';
    final stock = widget.itemDetails['stock'] ?? 'N/A';
    final dateScanned = widget.itemDetails['date_scanned'];
    final description = widget.itemDetails['specification'] ?? 'No specifications provided.';

    final bool isDescLong = description.length > 80;
    final String displayDescription = _isDescriptionExpanded 
        ? description 
        : (isDescLong ? "${description.substring(0, 80)}... " : description);

    // Tray is visible in "Draft/Edit Mode"
    final bool isDraftMode = _isAddingMore || _tempSelectedImages.isNotEmpty;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(viewInsets: EdgeInsets.zero),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.s),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Modal Top Navigation Bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.s, vertical: 6.s),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black87, size: 24.s),
                  onPressed: () => Navigator.pop(context, false),
                ),
                Expanded(
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: TextStyle(
                          color: const Color(0xFF8C0404),
                          fontSize: 18.s,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 48.s), // Balancing width for centered title
              ],
            ),
          ),
          Divider(height: 1, color: const Color(0xFFEEEEEE)),

          // Scrollable Body Content
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.s),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Photo display area (Red Container)
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 205.s, 
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.s),
                          border: Border.all(
                            color: const Color(0xFF8C0404),
                            width: 1.5.s,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(13.5.s),
                          child: _buildPhotoContent(),
                        ),
                      ),
                      
                      // Primary Remove Button (Draft Mode Only)
                      if (isDraftMode && (_currentImagePaths.isNotEmpty || _tempSelectedImages.isNotEmpty))
                        Positioned(
                          top: -10.s,
                          right: -10.s,
                          child: _buildRemoveButton(0, isPrimary: true),
                        ),
                    ],
                  ),
                  
                  // Horizontal Tray (Visible when in Draft/Adding Mode)
                  if (isDraftMode) ...[
                    SizedBox(height: 12.s),
                    _buildImageSlotsTray(),
                  ],

                  SizedBox(height: 18.s),

                  // Metadata Table / Details List
                  _buildLocationRow(),
                  Divider(height: 1, color: const Color(0xFFEEEEEE)),
                  _buildDetailRow('Date Scanned', _formatDate(dateScanned)),
                  Divider(height: 1, color: const Color(0xFFEEEEEE)),
                  _buildDetailRow('Stock No.', stock),
                  Divider(height: 1, color: const Color(0xFFEEEEEE)),
                  _buildDetailRow('Unit', unit),
                  Divider(height: 1, color: const Color(0xFFEEEEEE)),
                  _buildDescriptionDetailRow(
                    'Description',
                    displayDescription,
                    isDescLong ? (_isDescriptionExpanded ? ' See less' : ' See more') : '',
                  ),
                  Divider(height: 1, color: const Color(0xFFEEEEEE)),
                  _buildDetailRow('Quantity', quantity),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildPhotoContent() {
    final int savedCount = _currentImagePaths.length;
    final int tempCount = _tempSelectedImages.length;
    final int totalCount = savedCount + tempCount;

    // SCENARIO 1: DRAFT/EDIT MODE
    if (_isAddingMore || tempCount > 0) {
      final bool isEmptyDraft = totalCount == 0;
      
      return Stack(
        clipBehavior: Clip.none,
        children: [
          if (!isEmptyDraft)
            _buildImageItem(0, isPrimary: true)
          else
            _buildSelectionPlaceholder(),

          // Floating Action Buttons (Bottom Right)
          if (!isEmptyDraft)
            Positioned(
              bottom: 10,
              right: 10,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSaveButton(),
                  const SizedBox(width: 8),
                  _buildCancelButton(),
                ],
              ),
            ),
        ],
      );
    }

    // SCENARIO 2: PREVIEW MODE (Carousel)
    if (savedCount > 0) {
      return Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentCarouselIndex = index;
              });
            },
            itemCount: savedCount,
            itemBuilder: (context, index) {
              final path = _currentImagePaths[index];
              return GestureDetector(
                onTap: () => FullScreenImageViewer.show(
                  context,
                  imageUrls: _currentImagePaths
                      .map((e) => '${ApiConstants.storageUrl}$e')
                      .toList(),
                  initialIndex: index,
                ),
                child: Hero(
                  tag: 'item_image_$index',
                  child: Image.network(
                    '${ApiConstants.storageUrl}$path',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(Icons.broken_image, size: 50, color: Color(0xFF8C0404)),
                    ),
                  ),
                ),
              );
            },
          ),

          // Indicator Dots
          if (savedCount > 1)
            Positioned(
              bottom: 15,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(savedCount, (index) {
                  return Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentCarouselIndex == index
                          ? const Color(0xFF8C0404)
                          : Colors.grey.withValues(alpha: 0.5),
                    ),
                  );
                }),
              ),
            ),

          // Action Button (Enter Edit Mode) - Changed to Upward Arrow
          Positioned(
            bottom: 10,
            right: 10,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isAddingMore = true;
                  _tempSelectedImages.clear();
                });
              },
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.file_upload_outlined,
                  color: Color(0xFF8C0404),
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      );
    }

    // SCENARIO 3: EMPTY STATE
    return _buildSelectionPlaceholder();
  }

  Widget _buildSaveButton() {
    return _isUploading
        ? const SizedBox(
            width: 38,
            height: 38,
            child: CircularProgressIndicator(
                color: Color(0xFF8C0404),
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8C0404))),
          )
        : GestureDetector(
            onTap: () => _handleSaveImages(),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFF8C0404),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 4, offset: const Offset(0, 2)),
                ],
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 20),
            ),
          );
  }

  Widget _buildCancelButton() {
    if (_isUploading) return const SizedBox.shrink();
    return GestureDetector(
      onTap: () {
        setState(() {
          _tempSelectedImages.clear();
          _isAddingMore = false;
        });
      },
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        child: const Icon(Icons.close, color: Color(0xFF8C0404), size: 20),
      ),
    );
  }

  /// Helper to build an image container (Primary or Slot).
  Widget _buildImageItem(int index, {bool isPrimary = false}) {
    final int savedCount = _currentImagePaths.length;
    final bool isSaved = index < savedCount;
    
    Widget imageWidget;
    if (isSaved) {
      imageWidget = Image.network(
        '${ApiConstants.storageUrl}${_currentImagePaths[index]}',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
      );
    } else {
      imageWidget = Image.file(
        _tempSelectedImages[index - savedCount],
        fit: BoxFit.cover,
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: isPrimary ? null : () => _handleSwapWithPrimary(index),
          child: SizedBox.expand(child: imageWidget),
        ),
        // Tray slots remove buttons (Primary remove button is at build() level)
        if (!isPrimary)
          Positioned(
            top: -6,
            right: -6,
            child: _buildRemoveButton(index, isPrimary: false),
          ),
      ],
    );
  }

  /// Plain White Circle, No Border, Black X icon
  Widget _buildRemoveButton(int index, {required bool isPrimary}) {
    return GestureDetector(
      onTap: () => _handleRemoveFromSequence(index),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 4, spreadRadius: 1),
          ],
        ),
        child: Icon(
          Icons.close, 
          size: isPrimary ? 16 : 10, 
          color: Colors.black,
        ),
      ),
    );
  }

  Future<void> _handleRemoveFromSequence(int index) async {
    final int savedCount = _currentImagePaths.length;
    if (index < savedCount) {
       await _handleDeleteImage(index);
    } else {
       setState(() {
         _tempSelectedImages.removeAt(index - savedCount);
       });
    }
  }

  void _handleSwapWithPrimary(int index) {
    if (index == 0) return;
    
    setState(() {
      List<dynamic> combined = [..._currentImagePaths, ..._tempSelectedImages];
      final item0 = combined[0];
      combined[0] = combined[index];
      combined[index] = item0;
      
      _currentImagePaths.clear();
      _tempSelectedImages.clear();
      for (var item in combined) {
        if (item is String) {
          _currentImagePaths.add(item);
        } else if (item is File) {
          _tempSelectedImages.add(item);
        }
      }
    });
  }

  Widget _buildSelectionPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => _showGalleryAccessModal(context),
          child: SvgPicture.asset(
            'assets/images/upload-photo.svg',
            height: 75,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.cloud_upload_outlined, size: 55, color: Color(0xFF8C0404));
            },
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => _showGalleryAccessModal(context),
          child: const Text(
            'Tap to upload photo',
            style: TextStyle(color: Color(0xFF8C0404), fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text('or', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
            ),
            Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
          ],
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => _showCameraPermissionModal(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8C0404),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 0,
          ),
          child: const Text(
            'Open camera',
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildImageSlotsTray() {
    final int totalCount = _currentImagePaths.length + _tempSelectedImages.length;

    return Row(
      children: List.generate(4, (index) {
        final int logicalIdx = index + 1;
        final bool hasImage = logicalIdx < totalCount;
        final bool isFirstEmpty = logicalIdx == totalCount;

        return Expanded(
          child: Container(
            height: 65,
            margin: EdgeInsets.only(
              left: index == 0 ? 0 : 5,
              right: index == 3 ? 0 : 5,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: hasImage ? const Color(0xFF8C0404) : Colors.grey.shade300,
                width: hasImage ? 1 : 0.5,
              ),
            ),
            clipBehavior: Clip.none,
            child: hasImage
                ? _buildImageItem(logicalIdx)
                : (isFirstEmpty && totalCount < 5
                    ? InkWell(
                        onTap: () => _showAddMoreOptions(context),
                        child: const Center(
                          child: Icon(Icons.add, color: Color(0xFF8C0404), size: 24),
                        ),
                      )
                    : null),
          ),
        );
      }),
    );
  }

  void _showAddMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library, color: Color(0xFF8C0404)),
            title: const Text('Add from Gallery'),
            onTap: () {
              Navigator.pop(context);
              _pickImagesFromGallery();
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt, color: Color(0xFF8C0404)),
            title: const Text('Add from Camera'),
            onTap: () {
              Navigator.pop(context);
              _showCameraPermissionModal(context);
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.fromLTRB(30.s, 11.s, 0, 11.s),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 110.s,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey, fontSize: 15.s, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.black87, fontSize: 15.s, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationRow() {
    return Padding(
      padding: EdgeInsets.fromLTRB(30.s, 11.s, 0, 11.s),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 110.s,
            child: Text('Location', style: TextStyle(color: Colors.grey, fontSize: 15.s, fontWeight: FontWeight.w500)),
          ),
          Expanded(
            child: _buildLocationViewMode(),
          ),
        ],
      ),
    );
  }

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
              fontSize: 15.s,
              fontWeight: hasLocation ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
        SizedBox(width: 8.s),
        GestureDetector(
          onTap: () => _showLocationEditModal(),
          child: Container(
            width: 38.s,
            height: 38.s,
            decoration: BoxDecoration(color: const Color(0xFFF2F2F2), borderRadius: BorderRadius.circular(8.s)),
            child: Icon(Icons.edit_outlined, color: Colors.black87, size: 20.s),
          ),
        ),
      ],
    );
  }

  void _showLocationEditModal() {
    // Keep local copy of current values in case of cancel
    final String initialBuilding = _buildingController.text;
    final String initialRoom = _roomController.text;

    showDialog(
      context: context,
      builder: (dialogContext) => CustomAlertDialog(
        message: 'Edit Location',
        color: const Color(0xFF8C0404),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _buildingController,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  hintText: 'Building / Office',
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _roomController,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  hintText: 'Room number',
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8C0404),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                    ),
                    onPressed: () async {
                      final itemId = widget.itemDetails['mr_id'] ?? widget.itemDetails['id'];
                      final b = _buildingController.text.trim();
                      final r = _roomController.text.trim();

                      final homeController = Provider.of<HomeController>(context, listen: false);
                      final result = await homeController.updateItemLocation(
                        itemId is int ? itemId : int.parse(itemId.toString()),
                        b,
                        r,
                      );

                      if (mounted) {
                        if (result['error'] == null) {
                          setState(() {
                            if (b.isNotEmpty && r.isNotEmpty) {
                              _currentLocation = '$b - $r';
                            } else if (b.isNotEmpty) {
                              _currentLocation = b;
                            } else if (r.isNotEmpty) {
                              _currentLocation = r;
                            } else {
                              _currentLocation = null;
                            }
                          });
                          if (dialogContext.mounted) {
                            Navigator.pop(dialogContext);
                          }
                        } else {
                          _showAlertDialog(
                            message: 'Update failed',
                            subtitle: result['error'],
                            icon: Icons.error_outline,
                            color: Colors.red,
                          );
                        }
                      }
                    },
                    child: const Text('Save Changes', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.black54),
                    onPressed: () {
                      _buildingController.text = initialBuilding;
                      _roomController.text = initialRoom;
                      Navigator.pop(dialogContext);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionDetailRow(String label, String text, String actionText) {
    return Padding(
      padding: EdgeInsets.fromLTRB(30.s, 11.s, 0, 11.s),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110.s,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey, fontSize: 15.s, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 12.s,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nunito',
                ),
                children: [
                  TextSpan(text: text),
                  if (actionText.isNotEmpty)
                    TextSpan(
                      text: actionText,
                      style: TextStyle(
                        color: const Color(0xFF8C0404), 
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Nunito',
                        fontSize: 12.s,
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

  void _showGalleryAccessModal(BuildContext context) {
    GalleryAccessModal.startGalleryFlow(
      context,
      onAllow: () => _pickImagesFromGallery(),
    );
  }

  void _showCameraPermissionModal(BuildContext context) {
    CameraPermissionModal.startScannerFlow(
      context,
      onAllow: () => _pickImage(ImageSource.camera),
    );
  }

  Future<void> _pickImagesFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage(imageQuality: 70);
    
    if (images.isEmpty) return;
    if (!mounted) return;

    final int availableSlots = 5 - (_currentImagePaths.length + _tempSelectedImages.length);
    final List<XFile> toProcess = images.take(availableSlots).toList();

    for (var xfile in toProcess) {
      setState(() {
        _tempSelectedImages.add(File(xfile.path));
      });
    }

    setState(() {
      _isAddingMore = false; 
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source, imageQuality: 70);
    if (image == null) return;

    if (!mounted) return;

    setState(() {
      if ((_currentImagePaths.length + _tempSelectedImages.length) < 5) {
        _tempSelectedImages.add(File(image.path));
      }
      _isAddingMore = false;
    });
  }

  Future<void> _handleSaveImages() async {
    final itemId = widget.itemDetails['mr_id'] ?? widget.itemDetails['id'];
    if (itemId == null) {
       _showAlertDialog(
        message: 'Item ID not found.',
        icon: Icons.error_outline,
        color: Colors.red,
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    final homeController = Provider.of<HomeController>(context, listen: false);
    
    // ATOMIC BATCH SYNC:
    // This sends the ordered sequence of existing paths AND all new files in ONE request.
    // This removes all race conditions and ensures every image is correctly saved.
    final syncResult = await homeController.syncItemImages(
      itemId is int ? itemId : int.parse(itemId.toString()),
      _currentImagePaths,
      _tempSelectedImages,
    );

    if (!mounted) return;

    setState(() {
      _isUploading = false;
    });

    if (syncResult['error'] == null) {
      setState(() {
        _tempSelectedImages.clear();
        _isAddingMore = false;
        if (syncResult['all_images'] != null) {
          _initializeImages(syncResult['all_images']);
        }
      });

      _showAlertDialog(
        message: 'Image updated successfully!',
        subtitle: 'You can now see your uploaded image.',
        icon: Icons.check_circle_outline,
        color: Colors.green,
      );
    } else {
      _showAlertDialog(
        message: 'Upload failed',
        subtitle: syncResult['error'],
        icon: Icons.error_outline,
        color: Colors.red,
      );
    }
  }

  Future<void> _handleDeleteImage(int index) async {
    final int savedCount = _currentImagePaths.length;
    final bool isSaved = index < savedCount;

    if (isSaved) {
      final itemId = widget.itemDetails['mr_id'] ?? widget.itemDetails['id'];

      showDialog(
        context: context,
        builder: (context) => ConfirmationDialog(
          message: 'Delete Image',
          subtitle: 'Are you sure you want to permanently delete this image from the server?',
          icon: Icons.delete_outline,
          color: const Color(0xFF8C0404),
          confirmText: 'Delete',
          onConfirm: () async {
            setState(() => _isUploading = true);
            final homeController = Provider.of<HomeController>(context, listen: false);
            final deleteResult = await homeController.deleteItemImage(
              itemId is int ? itemId : int.parse(itemId.toString()),
              _currentImagePaths[index],
            );

            if (mounted) {
              setState(() => _isUploading = false);
              if (deleteResult['error'] == null) {
                setState(() {
                  if (deleteResult['all_images'] != null) {
                    _initializeImages(deleteResult['all_images']);
                  } else {
                    _currentImagePaths.removeAt(index);
                  }
                  if (_currentCarouselIndex >= _currentImagePaths.length) {
                    _currentCarouselIndex = (_currentImagePaths.length - 1).clamp(0, 999);
                  }
                });
                _showAlertDialog(
                  message: 'Image deleted',
                  icon: Icons.delete_sweep_outlined,
                  color: Colors.green,
                );
              } else {
                _showAlertDialog(
                  message: 'Deletion failed',
                  subtitle: deleteResult['error'],
                  icon: Icons.error_outline,
                  color: Colors.red,
                );
              }
            }
          },
        ),
      );
    } else {
      setState(() {
        _tempSelectedImages.removeAt(index - savedCount);
      });
    }
  }

  void _showAlertDialog({required String message, String? subtitle, required IconData icon, required Color color, VoidCallback? onButtonPressed}) {
    showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        message: message,
        subtitle: subtitle,
        icon: icon,
        color: color,
        buttonText: 'Okay',
        onButtonPressed: onButtonPressed,
      ),
    );
  }
}
