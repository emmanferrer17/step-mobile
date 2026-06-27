import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart'; // [NEW] For runtime permissions
import 'package:provider/provider.dart';
import 'package:mobile/app/controllers/auth_controller.dart';
import 'package:mobile/data/services/api_service.dart';
import '../shared/widgets/custom_alert_dialog.dart';
import '../shared/widgets/standard_permission_layout.dart';
import '../../app/config/ui_constants.dart';
import 'widgets/mr_item_scan_details_modal.dart';

/// [MVC - VIEW]
/// QRScannerPage provides a premium camera interface with an overlay,
/// animations, and camera controls.
class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  // Controller for the camera functionality
  final MobileScannerController controller = MobileScannerController();
  
  // Animation controller for the scanning line
  late AnimationController _animationController;

  // [STATE] Track if we've already detected a barcode to prevent multiple triggers
  bool _isScanCompleted = false;
  
  // [STATE] Track camera permission status
  bool _isPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // [OBSERVER] To detect when user returns from settings
    _checkPermissionSilently(); // [PERMISSIONS] Check status silently on startup
    // [ANIMATION] Initialize the scanning line animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  // [LOGIC] Checks camera permission silently without requesting
  Future<void> _checkPermissionSilently() async {
    final status = await Permission.camera.status;
    if (mounted) {
      setState(() {
        _isPermissionGranted = status.isGranted;
      });
    }
  }

  // [LOGIC] Requests camera permission at runtime when clicking Allow
  Future<void> _requestPermission() async {
    final status = await Permission.camera.request();
    if (mounted) {
      setState(() {
        _isPermissionGranted = status.isGranted;
      });
    }
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  // [LOGIC] Handles the detected barcode data
  void _handleBarcode(BarcodeCapture capture) {
    if (_isScanCompleted) return;

    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        setState(() => _isScanCompleted = true);
        
        // Call API to process the QR code scan
        _processScan(barcode.rawValue!);
        break;
      }
    }
  }

  // [LOGIC] Communicates with the API to claim items for this DA QR Code
  Future<void> _processScan(String qrCode) async {
    final String trimmedQr = qrCode.trim();
    final bool isLookup = trimmedQr.startsWith('MR-');
    final bool isBatchAssignment = trimmedQr.startsWith('RIS-') || trimmedQr.startsWith('PAR-');

    if (!isLookup && !isBatchAssignment) {
      _showErrorDialog('Invalid QR code format. Please scan a valid RIS/PAR form or an item\'s printed sticker QR.');
      return;
    }

    // Show a loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const CustomAlertDialog(
        message: 'Processing form...',
        icon: Icons.sync,
        color: Color(0xFFBA1A1A),
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFFBA1A1A)),
        ),
      ),
    );

    try {
      final authController = Provider.of<AuthController>(context, listen: false);
      final token = authController.token;
      
      if (token == null) {
        Navigator.pop(context); // Dismiss loading dialog
        _showErrorDialog('Authentication token not found. Please log in again.');
        return;
      }

      if (isLookup) {
        final result = await ApiService().lookupMrItem(trimmedQr, token);

        if (!mounted) return;
        Navigator.pop(context); // Dismiss loading dialog

        if (result['status'] == 'success') {
          final Map<String, dynamic> itemDetails = result['data']?['data'] ?? {};
          _showItemDetailsDialog(itemDetails);
        } else {
          _showErrorDialog(result['message'] ?? 'An unknown error occurred.');
        }
      } else {
        final result = await ApiService().assignMrItems(trimmedQr, token);

        if (!mounted) return;
        Navigator.pop(context); // Dismiss loading dialog

        if (result['status'] == 'success') {
          final List<dynamic> items = result['data']?['items'] ?? [];
          _showSuccessDialog(trimmedQr, items);
        } else {
          final message = result['message']?.toString() ?? '';
          if (message.toLowerCase().contains('already claimed')) {
            final List<dynamic> items = result['data']?['items'] ?? [];
            _showAlreadyClaimedDialog(trimmedQr, items);
          } else {
            _showErrorDialog(message.isEmpty ? 'An unknown error occurred.' : message);
          }
        }
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Dismiss loading dialog
      _showErrorDialog('An error occurred: ${e.toString()}');
    }
  }

  // [UI] Displays a custom modal dialog showing item details using MrItemScanDetailsModal
  void _showItemDetailsDialog(Map<String, dynamic> itemDetails) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 20.s, vertical: 24.s),
        child: MrItemScanDetailsModal(itemDetails: itemDetails),
      ),
    ).then((_) {
      if (mounted) {
        setState(() => _isScanCompleted = false);
      }
    });
  }


  // [UI] Displays a dialog for already claimed property
  void _showAlreadyClaimedDialog(String qrCode, List<dynamic> items) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return CustomAlertDialog(
          message: 'Property already claimed',
          subtitle: 'This item is already in your inventory.',
          icon: Icons.info_outline,
          color: const Color(0xFFFBC02D), // Yellowish for warning/info
          buttonText: 'Okay',
          onButtonPressed: () {
            Navigator.pop(dialogCtx);
            setState(() => _isScanCompleted = false);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(height: 1, color: Colors.black12),
              const SizedBox(height: 12),
              const Text(
                'Item Summary:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black45,
                ),
              ),
              const SizedBox(height: 8),
              _buildItemsList(items),
            ],
          ),
        );
      },
    );
  }

  // Helper to build the items list for dialogs
  Widget _buildItemsList(List<dynamic> items) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 180),
      child: items.isEmpty
          ? const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'No items to list.',
                style: TextStyle(color: Colors.black54),
              ),
            )
          : ListView.separated(
              shrinkWrap: true,
              itemCount: items.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = items[index];
                final name = item['item_name'] ?? 'Unknown Item';
                final qty = item['quantity'] ?? 1;
                final unit = item['unit'] ?? 'pcs';
                final specs = item['specification'] ?? '';

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                            ),
                            if (specs.toString().isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                specs.toString(),
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.black54,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '$qty $unit',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7CB342),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  // [UI] Displays a success dialog with the list of claimed items
  void _showSuccessDialog(String qrCode, List<dynamic> items) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        return CustomAlertDialog(
          message: 'Property is successfully claimed.',
          subtitle: 'The items are now available in your inventory.',
          icon: Icons.check,
          color: const Color(0xFF7CB342),
          buttonText: 'View items',
          onButtonPressed: () {
            Navigator.pop(dialogCtx); // Close the dialog
            Navigator.pop(context); // Go back to Home
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(height: 1, color: Colors.black12),
              const SizedBox(height: 12),
              const Text(
                'Summary of Scanned Items:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black45,
                ),
              ),
              const SizedBox(height: 8),
              _buildItemsList(items),
            ],
          ),
        );
      },
    );
  }

  // [UI] Displays an error dialog with a warning
  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => CustomAlertDialog(
        message: 'Scanning Failed',
        subtitle: errorMessage,
        icon: Icons.priority_high,
        color: Colors.red,
        buttonText: 'Try again',
        showArrow: false,
        onButtonPressed: () {
          Navigator.pop(dialogCtx);
          setState(() => _isScanCompleted = false);
        },
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // [LOGIC] Re-check permission silently if user returns to the app from Settings
    if (state == AppLifecycleState.resumed) {
      _checkPermissionSilently();
    }
  }

  @override
  void dispose() {
    // [CLEANUP] Dispose all controllers and observers
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scanWindow = Rect.fromCenter(
      center: Offset(MediaQuery.of(context).size.width / 2, MediaQuery.of(context).size.height / 2),
      width: 250,
      height: 250,
    );

    return Scaffold(
      backgroundColor: _isPermissionGranted ? Colors.black : Colors.white,
      body: !_isPermissionGranted
          ? _buildCustomPermissionPromptView()
          : Stack(
              children: [
                // [CAMERA VIEW]
          MobileScanner(
            controller: controller,
            scanWindow: scanWindow,
            onDetect: _handleBarcode, // [LOGIC] Delegate to our handler
          ),

          // [OVERLAY] Custom painter for the dimmed background and cut-out square
          CustomPaint(
            painter: ScannerOverlayPainter(scanWindow: scanWindow),
            child: Container(),
          ),

          // [SCANNING LINE] Animated line moving up and down the scan window
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Positioned(
                top: scanWindow.top + (scanWindow.height * _animationController.value),
                left: scanWindow.left,
                right: scanWindow.right,
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    color: const Color(0xFFBA1A1A),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFBA1A1A).withValues(alpha: 0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // [APP BAR OVERLAY] Custom app bar because the body is black
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'QR Scanner',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2),
                  ),
                  const SizedBox(width: 48), // Spacer for centering
                ],
              ),
            ),
          ),

          // [CONTROLS] Flash and Camera flip
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildControlButton(
                  icon: Icons.flashlight_on,
                  onPressed: () => controller.toggleTorch(),
                  label: 'Flash',
                ),
                _buildControlButton(
                  icon: Icons.cameraswitch,
                  onPressed: () => controller.switchCamera(),
                  label: 'Flip',
                ),
              ],
            ),
          ),
          
          Positioned(
            top: scanWindow.bottom + 20,
            left: 0,
            right: 0,
            child: const Center(
              child: Text(
                'Align the QR code within the frame to scan',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // [UI] Premium Custom Camera Permission Access Prompt (replaces native primer/black denied screen)
  Widget _buildCustomPermissionPromptView() {
    return StandardPermissionLayout(
      isBottomSheet: false,
      subtitle: 'Would you like to allow this app have access to your camera ?',
      onCancel: () => Navigator.pop(context),
      onAllow: _requestPermission,
    );
  }

  Widget _buildControlButton({required IconData icon, required VoidCallback onPressed, required String label}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}

/// [PAINTER] Draws a semi-transparent overlay with a clear "scan window" rectangle
class ScannerOverlayPainter extends CustomPainter {
  final Rect scanWindow;

  ScannerOverlayPainter({required this.scanWindow});

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final cutOutPath = Path()..addRect(scanWindow);

    // [DIMMING] The area outside the scan window
    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutOutPath,
    );

    canvas.drawPath(backgroundWithCutout, backgroundPaint);

    // [BORDER] The white border around the scan window
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    canvas.drawRect(scanWindow, borderPaint);
    
    // [CORNERS] Accent corners in red
    final cornerPaint = Paint()
      ..color = const Color(0xFFBA1A1A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0;
    
    const double cornerSize = 20.0;
    
    // Top Left
    canvas.drawLine(Offset(scanWindow.left, scanWindow.top), Offset(scanWindow.left + cornerSize, scanWindow.top), cornerPaint);
    canvas.drawLine(Offset(scanWindow.left, scanWindow.top), Offset(scanWindow.left, scanWindow.top + cornerSize), cornerPaint);
    
    // Top Right
    canvas.drawLine(Offset(scanWindow.right, scanWindow.top), Offset(scanWindow.right - cornerSize, scanWindow.top), cornerPaint);
    canvas.drawLine(Offset(scanWindow.right, scanWindow.top), Offset(scanWindow.right, scanWindow.top + cornerSize), cornerPaint);
    
    // Bottom Left
    canvas.drawLine(Offset(scanWindow.left, scanWindow.bottom), Offset(scanWindow.left + cornerSize, scanWindow.bottom), cornerPaint);
    canvas.drawLine(Offset(scanWindow.left, scanWindow.bottom), Offset(scanWindow.left, scanWindow.bottom - cornerSize), cornerPaint);
    
    // Bottom Right
    canvas.drawLine(Offset(scanWindow.right, scanWindow.bottom), Offset(scanWindow.right - cornerSize, scanWindow.bottom), cornerPaint);
    canvas.drawLine(Offset(scanWindow.right, scanWindow.bottom), Offset(scanWindow.right, scanWindow.bottom - cornerSize), cornerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
