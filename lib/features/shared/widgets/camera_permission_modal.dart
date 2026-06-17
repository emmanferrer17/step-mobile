import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../app/config/routes.dart';

class CameraPermissionModal {
  /// Silently checks permission. If already granted, navigates to the QR scanner directly.
  /// Otherwise, displays the custom bottom sheet modal.
  static Future<void> startScannerFlow(BuildContext context) async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      if (context.mounted) {
        Navigator.pushNamed(context, AppRoutes.qrScanner);
      }
      return;
    }

    if (context.mounted) {
      showCameraPermissionBottomSheet(context);
    }
  }

  /// Displays the custom "Allow Access" bottom sheet modal overlaying the active page.
  static void showCameraPermissionBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFEAEA), // Gradient
                Colors.white,
              ],
              stops: [0.0, 0.25],
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Circle status icon containing question mark
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 16,
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
                      fontSize: 48,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              const Text(
                'Allow Access',
                style: TextStyle(
                  color: Color(0xFF8C0404),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              // Subtitle / Body
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Would you allow this app to \n have access on your camera ?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Buttons row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Cancel Action
                  SizedBox(
                    width: 140,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey.shade600,
                        side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),

                  // Allow Action
                  SizedBox(
                    width: 140,
                    child: ElevatedButton(
                      onPressed: () async {
                        // Request camera permission
                        final status = await Permission.camera.request();
                        if (!context.mounted) return;
                        
                        // Close the bottom sheet modal first
                        Navigator.pop(context);
                        
                        if (status.isGranted) {
                          Navigator.pushNamed(context, AppRoutes.qrScanner);
                        } else if (status.isPermanentlyDenied) {
                          await openAppSettings();
                        }
                      },
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
        );
      },
    );
  }
}
