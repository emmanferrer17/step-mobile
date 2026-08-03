import 'package:flutter/material.dart';
import '../../../app/config/app_colors.dart';
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

    final Color gradStart = AppColors.isDarkMode
        ? AppColors.primaryRed.withOpacity(0.08)
        : const Color(0xFFFFEAEA);
    final Color gradEnd = AppColors.modalBackground;

    final content = Container(
      decoration: BoxDecoration(
        color: AppColors.modalBackground,
        borderRadius: isBottomSheet
            ? BorderRadius.only(
                topLeft: Radius.circular(24.s),
                topRight: Radius.circular(24.s),
              )
            : BorderRadius.circular(24.s),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            gradStart,
            gradEnd,
          ],
          stops: const [0.0, 0.25],
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
              color: AppColors.modalBackground,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
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
                  color: AppColors.primaryRed,
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
              color: AppColors.primaryRed,
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
                color: AppColors.textGrey,
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
                    foregroundColor: AppColors.textMuted,
                    side: BorderSide(color: AppColors.borderLight, width: 1.5.s),
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
                    backgroundColor: AppColors.primaryRed,
                    foregroundColor: AppColors.buttonPrimaryForeground,
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
