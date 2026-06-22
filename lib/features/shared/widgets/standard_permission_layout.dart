import 'package:flutter/material.dart';
import '../../../app/config/size_config.dart';
import '../../../app/config/ui_constants.dart';

class StandardPermissionLayout extends StatelessWidget {
  final String title;
  final String subtitle;
  final String centralText;
  final String allowText;
  final String cancelText;
  final VoidCallback onAllow;
  final VoidCallback onCancel;
  final bool isBottomSheet;

  const StandardPermissionLayout({
    super.key,
    this.title = 'Allow Access',
    required this.subtitle,
    this.centralText = '?',
    this.allowText = 'Allow',
    this.cancelText = 'Cancel',
    required this.onAllow,
    required this.onCancel,
    this.isBottomSheet = true,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final content = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: isBottomSheet
            ? BorderRadius.only(
                topLeft: Radius.circular(24.s),
                topRight: Radius.circular(24.s),
              )
            : BorderRadius.circular(24.s),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFEAEA), // Gradient
            Colors.white,
          ],
          stops: [0.0, 0.25],
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 32.s, horizontal: 24.s),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Circle status icon
          Container(
            width: 100.s,
            height: 100.s,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 16.s,
                  spreadRadius: 2.s,
                  offset: Offset(0, 4.s),
                ),
              ],
            ),
            child: Center(
              child: Text(
                centralText,
                style: TextStyle(
                  color: const Color(0xFFBA1A1A),
                  fontSize: 48.s,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          SizedBox(height: 20.s),
          // Title
          Text(
            title,
            style: TextStyle(
              color: const Color(0xFFBA1A1A),
              fontSize: 20.s,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.s),
          // Subtitle / Body
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.s),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 15.s,
                height: 1.4,
              ),
            ),
          ),
          SizedBox(height: 32.s),
          // Buttons row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Cancel Action
              SizedBox(
                width: 140.s,
                child: OutlinedButton(
                  onPressed: onCancel,
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
                      fontSize: 16.s,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 24.s),
              // Allow Action
              SizedBox(
                width: 140.s,
                child: ElevatedButton(
                  onPressed: onAllow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFBA1A1A),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(vertical: 14.s),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.s),
                    ),
                  ),
                  child: Text(
                    allowText,
                    style: TextStyle(
                      fontSize: 16.s,
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

    if (isBottomSheet) {
      return content;
    } else {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.s),
          child: Material(
            color: Colors.transparent,
            child: content,
          ),
        ),
      );
    }
  }
}
