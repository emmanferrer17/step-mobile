import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../app/config/routes.dart';
import 'standard_permission_layout.dart';

class CameraPermissionModal {
  /// Silently checks permission. If already granted, executes [onAllow] or pushes scanner.
  /// Returns the result of the scanner navigation if pushed.
  static Future<dynamic> startScannerFlow(BuildContext context, {VoidCallback? onAllow}) async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      if (context.mounted) {
        if (onAllow != null) {
          onAllow();
          return true;
        } else {
          return await Navigator.pushNamed(context, AppRoutes.qrScanner);
        }
      }
      return null;
    }

    if (context.mounted) {
      final result = await showCameraPermissionBottomSheet(context);
      if (result == 'granted' && context.mounted) {
        if (onAllow != null) {
          onAllow();
          return true;
        } else {
          return await Navigator.pushNamed(context, AppRoutes.qrScanner);
        }
      }
    }
    return null;
  }

  /// Displays the custom "Allow Access" bottom sheet modal overlaying the active page.
  static Future<dynamic> showCameraPermissionBottomSheet(BuildContext context) async {
    return await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StandardPermissionLayout(
          subtitle: 'Would you allow this app to \n have access on your camera ?',
          onCancel: () => Navigator.pop(context, 'cancelled'),
          onAllow: () async {
            // Request camera permission
            final status = await Permission.camera.request();
            if (!context.mounted) return;

            if (status.isGranted) {
              Navigator.pop(context, 'granted');
            } else if (status.isPermanentlyDenied) {
              await openAppSettings();
              Navigator.pop(context, 'denied');
            } else {
              Navigator.pop(context, 'denied');
            }
          },
        );
      },
    );
  }
}
