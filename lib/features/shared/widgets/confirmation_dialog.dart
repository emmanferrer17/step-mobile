import 'package:flutter/material.dart';
import '../../../app/config/size_config.dart';
import '../../../app/config/ui_constants.dart';

class ConfirmationDialog extends StatelessWidget {
  final String message;
  final String? subtitle;
  final IconData icon;
  final Color color;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const ConfirmationDialog({
    super.key,
    required this.message,
    this.subtitle,
    required this.icon,
    required this.color,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    required this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.s),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.s, vertical: 30.s),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.s),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10.s),
            // Circular container for the Icon
            Container(
              width: 90.s,
              height: 90.s,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.12),
                    blurRadius: 15.s,
                    spreadRadius: 3.s,
                    offset: Offset(0, 5.s),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: color,
                  size: 48.s,
                ),
              ),
            ),
            SizedBox(height: 24.s),
            // Title Message text
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.s,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            if (subtitle != null) ...[
              SizedBox(height: 8.s),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.s,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
            ],
            SizedBox(height: 32.s),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      if (onCancel != null) onCancel!();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey.shade600,
                      side: BorderSide(color: Colors.grey.shade300, width: 1.5.s),
                      padding: EdgeInsets.symmetric(vertical: 14.s),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.s),
                      ),
                    ),
                    child: Text(
                      cancelText,
                      style: TextStyle(
                        fontSize: 15.s,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.s),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 14.s),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.s),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          confirmText,
                          style: TextStyle(
                            fontSize: 15.s,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8.s),
                        Icon(Icons.arrow_forward, size: 18.s),
                      ],
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
}
