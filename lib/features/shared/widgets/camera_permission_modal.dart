import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../app/config/routes.dart';
import 'standard_permission_layout.dart';

class CameraPermissionModal {
  /// Silently checks permission. If already granted, executes [onAllow].
  /// Otherwise, displays the custom bottom sheet modal.
  static Future<void> startScannerFlow(BuildContext context, {VoidCallback? onAllow}) async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      if (context.mounted) {
        if (onAllow != null) {
          onAllow();
        } else {
          Navigator.pushNamed(context, AppRoutes.qrScanner);
        }
      }
      return;
    }

    if (context.mounted) {
      showCameraPermissionBottomSheet(context, onAllow: onAllow);
    }
  }

  /// Displays the custom "Allow Access" bottom sheet modal overlaying the active page.
  static void showCameraPermissionBottomSheet(BuildContext context, {VoidCallback? onAllow}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StandardPermissionLayout(
          subtitle: 'Would you allow this app to \n have access on your camera ?',
          onCancel: () => Navigator.pop(context),
          onAllow: () async {
            // Request camera permission
            final status = await Permission.camera.request();
            if (!context.mounted) return;

            // Close the bottom sheet modal first
            Navigator.pop(context);

            if (status.isGranted) {
              if (onAllow != null) {
                onAllow();
              } else {
                Navigator.pushNamed(context, AppRoutes.qrScanner);
              }
            } else if (status.isPermanentlyDenied) {
              await openAppSettings();
            }
          },
        );
      },
    );
  }
}
