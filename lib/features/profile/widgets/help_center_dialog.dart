import 'package:flutter/material.dart';
import '../../../app/config/ui_constants.dart';

/// A centered dialog pop-up displaying the system Help Center options in an elegant manner.
class HelpCenterDialog extends StatelessWidget {
  const HelpCenterDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.s),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Modal Top Navigation Bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.s, vertical: 6.s),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black87, size: 24.s),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Help Center',
                      style: TextStyle(
                        color: const Color(0xFFBA1A1A),
                        fontSize: 18.s,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 48.s), // Spacer to balance the back button
              ],
            ),
          ),
          Divider(height: 1.s, color: const Color(0xFFEEEEEE)),

          // Scrollable Body Content
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(left: 30.s, right: 30.s, top: 20.s, bottom: 20.s),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Experiencing Errors?\nContact our Tech Support.',
                    style: TextStyle(
                      fontSize: 17.s,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 25.s),
                  
                  // Contact 1: I-TRAC Development Team
                  _buildContactSection(
                    name: 'I-TRAC Development Team',
                    email: 'itrac2026@gmail.com',
                    phone: '09994600625',
                  ),
                  
                  // Padding(
                  //   padding: EdgeInsets.symmetric(vertical: 15.s),
                  //   child: Divider(
                  //     height: 1.s,
                  //     color: const Color(0xFFEEEEEE),
                  //   ),
                  // ),
                  
                  // // Contact 2: John Rex Duran
                  // _buildContactSection(
                  //   name: 'John Rex Duran',
                  //   email: 'johnrex.duran@tup.edu.ph',
                  //   phone: '09615033412',
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper: builds contact section for support personnel.
  Widget _buildContactSection({
    required String name,
    required String email,
    required String phone,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: 25 .s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 16.s,
              fontWeight: FontWeight.bold,
              color: const Color(0xFFBA1A1A),
            ),
          ),
          SizedBox(height: 8.s),
          // Email Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.alternate_email,
                color: Colors.grey.shade500,
                size: 20.s,
              ),
              SizedBox(width: 12.s),
              Expanded(
                child: Text(
                  email,
                  style: TextStyle(
                    fontSize: 15.s,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.s),
          // Phone Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.phone_outlined,
                color: Colors.grey.shade500,
                size: 20.s,
              ),
              SizedBox(width: 12.s),
              Expanded(
                child: Text(
                  phone,
                  style: TextStyle(
                    fontSize: 15.s,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
