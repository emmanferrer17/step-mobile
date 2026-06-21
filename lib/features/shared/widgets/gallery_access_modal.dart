import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'standard_permission_layout.dart';

class GalleryAccessModal extends StatelessWidget {
  final VoidCallback onAllow;

  const GalleryAccessModal({super.key, required this.onAllow});

  @override
  Widget build(BuildContext context) {
    return StandardPermissionLayout(
      subtitle: 'Would you like to allow this app have access to your gallery ?',
      onCancel: () => Navigator.pop(context),
      onAllow: () async {
        // 1. Request actual system permission
        PermissionStatus status;

        if (Platform.isAndroid) {
          // Request both as many devices/versions handle them differently
          final statuses = await [
            Permission.photos,
            Permission.storage,
          ].request();

          status = statuses[Permission.photos] ?? statuses[Permission.storage] ?? PermissionStatus.denied;

          // Double check if either is granted
          if (!status.isGranted) {
            if (statuses[Permission.storage]?.isGranted == true || statuses[Permission.photos]?.isGranted == true) {
              status = PermissionStatus.granted;
            }
          }
        } else {
          status = await Permission.photos.request();
        }

        if (!context.mounted) return;

        // 2. Close this custom modal
        Navigator.pop(context);

        // 3. If granted, proceed
        if (status.isGranted || status.isLimited) {
          onAllow();
        } else if (status.isPermanentlyDenied) {
          openAppSettings();
        }
      },
    );
  }

  /// Silently checks permission. If already granted, executes [onAllow].
  /// Otherwise, displays the custom bottom sheet modal.
  static Future<void> startGalleryFlow(BuildContext context, {required VoidCallback onAllow}) async {
    PermissionStatus status;
    if (Platform.isAndroid) {
      final photosStatus = await Permission.photos.status;
      final storageStatus = await Permission.storage.status;
      status = (photosStatus.isGranted || storageStatus.isGranted) ? PermissionStatus.granted : PermissionStatus.denied;
    } else {
      status = await Permission.photos.status;
    }

    if (status.isGranted || status.isLimited) {
      onAllow();
      return;
    }

    if (context.mounted) {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) => GalleryAccessModal(onAllow: onAllow),
      );
    }
  }
}
