import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart'; // [NEW] For runtime permissions
import 'package:provider/provider.dart';
import 'package:mobile/app/controllers/auth_controller.dart';
import 'package:mobile/data/services/api_service.dart';
import '../shared/widgets/custom_alert_dialog.dart';

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
    // Show a loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          color: Colors.white,
          elevation: 4,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Color(0xFF8C0404)),
                SizedBox(height: 15),
                Text(
                  'Claiming items...',
                  style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final authController = Provider.of<AuthController>(context, listen: false);
      final token = authController.token;
      
      if (token == null) {
        Navigator.pop(context); // Dismiss loading dialog
        _showErrorSheet('Authentication token not found. Please log in again.');
        return;
      }

      final result = await ApiService().assignMrItems(qrCode, token);

      if (!mounted) return;
      Navigator.pop(context); // Dismiss loading dialog

      if (result['status'] == 'success') {
        final List<dynamic> items = result['data']?['items'] ?? [];
        _showSuccessDialog(qrCode, items);
      } else {
        _showErrorSheet(result['message'] ?? 'An unknown error occurred.');
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Dismiss loading dialog
      _showErrorSheet('An error occurred: ${e.toString()}');
    }
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
              ConstrainedBox(
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
                          final stock = item['stock'] ?? 'N/A';

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
              ),
            ],
          ),
        );
      },
    );
  }

  // [UI] Displays an error bottom sheet with a warning
  void _showErrorSheet(String errorMessage) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      builder: (context) => Container(
        padding: const EdgeInsets.all(25),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
            ),
            const SizedBox(height: 25),
            const Icon(Icons.error_outline, color: Colors.red, size: 50),
            const SizedBox(height: 15),
            const Text(
              'Scanning Failed',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(height: 10),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() => _isScanCompleted = false);
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF8C0404),
                      side: const BorderSide(color: Color(0xFF8C0404)),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('SCAN AGAIN', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context); // Go back to Home
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8C0404),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('CLOSE', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
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
                    color: const Color(0xFF8C0404),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF8C0404).withOpacity(0.5),
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
                    'SCANNER',
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
          
          const Positioned(
            bottom: 140,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Place the QR code inside the box',
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
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFEAEA), // Soft light pink/red glow
            Colors.white,
          ],
          stops: [0.0, 0.35],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Status Icon Container
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  '?',
                  style: TextStyle(
                    color: Color(0xFF8C0404),
                    fontSize: 56,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Title
            const Text(
              'Allow Access',
              style: TextStyle(
                color: Color(0xFF8C0404),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Would you like to allow this app have access to your camera ?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 48),

            // Buttons row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Cancel Action
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 36),

                // Allow Action
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: _requestPermission,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8C0404),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Allow',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
              color: Colors.white.withOpacity(0.2),
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
      ..color = const Color(0xFF8C0404)
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
