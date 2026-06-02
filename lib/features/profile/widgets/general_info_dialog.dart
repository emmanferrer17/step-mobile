import 'package:flutter/material.dart';
import '../../../data/models/user_model.dart';

/// A centered dialog pop-up displaying the user's detailed profile information.
class GeneralInfoDialog extends StatelessWidget {
  final UserModel? user;

  const GeneralInfoDialog({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    final localUser = user;
    final String middleNameVal = (localUser == null || localUser.middleName.isEmpty) ? 'N/A' : localUser.middleName;
    final String suffixVal = (localUser == null || localUser.suffix.isEmpty) ? 'N/A' : localUser.suffix;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 1.25,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Modal Top Navigation Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black87),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      'General Information',
                      style: TextStyle(
                        color: Color(0xFF8C0404),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 48), // Spacer to balance the back button
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),

          // Scrollable Body Content
          Flexible(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(left: 30, right: 30, top: 12, bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSectionTitle('Personal Information'),
                  _buildInfoField('First Name', localUser?.firstName ?? 'N/A'),
                  _buildInfoField('Middle Name', middleNameVal),
                  _buildInfoField('Last Name', localUser?.lastName ?? 'N/A'),
                  _buildInfoField('Suffix', suffixVal),
                  _buildInfoField('Contact No.', localUser?.contactNo ?? 'N/A'),
                  
                  const SizedBox(height: 10),
                  _buildSectionTitle('Account Setup'),
                  _buildInfoField('TUP-ID', localUser?.tupId ?? 'N/A'),
                  _buildInfoField('TUP Email', localUser?.email ?? 'N/A'),
                  _buildInfoField('User Type', localUser?.userType ?? 'N/A'),
                  _buildInfoField('Department/Office', localUser?.departmentName ?? 'N/A'),
                  _buildPasswordField('Password'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper: builds a section title for the modal.
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  /// Helper: builds a single labeled info field.
  Widget _buildInfoField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  /// Helper: builds a masked password field with a visibility icon.
  Widget _buildPasswordField(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '••••••••••••',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
