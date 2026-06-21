import 'package:flutter/material.dart';
import '../../../app/config/size_config.dart';
import '../../../app/config/ui_constants.dart';

class CustomAlertDialog extends StatelessWidget {
  final String message;
  final String? subtitle;
  final IconData? icon;
  final Color color;
  final VoidCallback? onClose;
  final Widget? child;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const CustomAlertDialog({
    super.key,
    required this.message,
    this.subtitle,
    this.icon,
    required this.color,
    this.onClose,
    this.child,
    this.buttonText,
    this.onButtonPressed,
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
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Close Button in the top right
            Positioned(
              top: -20.s,
              right: -14.s,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.black54, size: 22.s),
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
                if (icon != null) ...[
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
                ],
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
                if (child != null) ...[
                  SizedBox(height: 20.s),
                  child!,
                ],
                if (buttonText != null) ...[
                  SizedBox(height: 24.s),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.s),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14.s),
                        elevation: 0,
                      ),
                      onPressed: () {
                        if (onButtonPressed != null) {
                          onButtonPressed!();
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            buttonText!,
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
