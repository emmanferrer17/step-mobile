import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color color;
  final VoidCallback? onClose;

  const CustomAlertDialog({
    key,
    required this.message,
    required this.icon,
    required this.color,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Close Button in the top right
            Positioned(
              top: -20,
              right: -14,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.black54, size: 22),
                onPressed: () {
                  Navigator.pop(context);
                  if (onClose != null) {
                    onClose!();
                  }
                },
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                // Circular container for the Icon
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.12),
                        blurRadius: 15,
                        spreadRadius: 3,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      color: color,
                      size: 48,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Message text
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
