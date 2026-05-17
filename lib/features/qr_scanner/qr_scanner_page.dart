import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart'; // [NEW] For runtime permissions

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
    _checkPermission(); // [PERMISSIONS] Check on startup
    // [ANIMATION] Initialize the scanning line animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  // [LOGIC] Requests camera permission at runtime
  Future<void> _checkPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      _isPermissionGranted = status.isGranted;
    });
  }

  // [LOGIC] Handles the detected barcode data
  void _handleBarcode(BarcodeCapture capture) {
    if (_isScanCompleted) return;

    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        setState(() => _isScanCompleted = true);
        
        // [FEEDBACK] Show the result in a bottom sheet
        _showResultSheet(barcode.rawValue!);
        break;
      }
    }
  }

  // [UI] Displays a premium bottom sheet with the scanned data
  void _showResultSheet(String data) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false, // Force user to use "Scan Again" or "Close"
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
            const Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 15),
            const Text(
              'Item Detected',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF8C0404)),
            ),
            const SizedBox(height: 10),
            Text(
              'Scanned Data: $data',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
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
                    child: const Text('SCAN AGAIN'),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Logic for viewing item details will go here in the future
                      Navigator.pop(context);
                      Navigator.pop(context); // Go back to Home
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8C0404),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('VIEW ITEM'),
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
    // [LOGIC] Re-check permission if user returns to the app from Settings
    if (state == AppLifecycleState.resumed) {
      _checkPermission();
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
      backgroundColor: Colors.black,
      body: !_isPermissionGranted
          ? _buildPermissionDeniedView() // [UI] Show error if no camera access
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

  // [UI] Helper for permission denied state
  Widget _buildPermissionDeniedView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.camera_alt_outlined, color: Colors.white54, size: 80),
          const SizedBox(height: 20),
          const Text(
            'Camera Access Denied',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Please enable camera permissions in your settings to use the scanner.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => openAppSettings(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8C0404),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
            child: const Text('OPEN SETTINGS'),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => _checkPermission(),
            child: const Text('RETRY', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('GO BACK', style: TextStyle(color: Colors.white54)),
          ),
        ],
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
