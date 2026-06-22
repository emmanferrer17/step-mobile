import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/app/controllers/profile_controller.dart';
import 'package:mobile/features/shared/widgets/custom_alert_dialog.dart';
import '../../../data/models/user_model.dart';

/// A centered dialog pop-up displaying the user's detailed profile information.
class GeneralInfoDialog extends StatefulWidget {
  final UserModel? user;

  const GeneralInfoDialog({super.key, this.user});

  @override
  State<GeneralInfoDialog> createState() => _GeneralInfoDialogState();
}

class _GeneralInfoDialogState extends State<GeneralInfoDialog> {
  bool _isChangingPassword = false;

  // Form and controllers
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Password obscuring flags
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  bool _isLoading = false;
  String? _apiSuccessMessage;
  String? _apiGeneralErrorMessage;

  String? _currentPasswordError;
  String? _newPasswordError;
  String? _confirmPasswordError;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localUser = widget.user;
    final String middleNameVal = (localUser == null || localUser.middleName.isEmpty) ? 'N/A' : localUser.middleName;
    final String suffixVal = (localUser == null || localUser.suffix.isEmpty) ? 'N/A' : localUser.suffix;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: _isChangingPassword
          ? _buildChangePasswordView()
          : _buildGeneralInfoView(middleNameVal, suffixVal),
    );
  }

  Widget _buildGeneralInfoView(String middleNameVal, String suffixVal) {
    final localUser = widget.user;
    return Column(
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
                      color: Color(0xFFBA1A1A),
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
    );
  }

  Widget _buildChangePasswordView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Modal Top Navigation Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: () {
                  setState(() {
                    _isChangingPassword = false;
                    _clearErrorsAndInputs();
                  });
                },
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'Change Password',
                    style: TextStyle(
                      color: Color(0xFFBA1A1A),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFFEEEEEE)),

        // Scrollable Body Content
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 15),
                  if (_apiGeneralErrorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red.shade800, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _apiGeneralErrorMessage!,
                              style: TextStyle(color: Colors.red.shade800, fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                  if (_apiSuccessMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_outline, color: Colors.green.shade800, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _apiSuccessMessage!,
                              style: TextStyle(color: Colors.green.shade800, fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                  _buildOutlinedPasswordField(
                    label: 'Current Password',
                    controller: _currentPasswordController,
                    obscureText: _obscureCurrentPassword,
                    onToggle: () => setState(() => _obscureCurrentPassword = !_obscureCurrentPassword),
                    errorText: _currentPasswordError,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'This field is required';
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  _buildOutlinedPasswordField(
                    label: 'New Password',
                    controller: _newPasswordController,
                    obscureText: _obscureNewPassword,
                    onToggle: () => setState(() => _obscureNewPassword = !_obscureNewPassword),
                    errorText: _newPasswordError,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'This field is required';
                      if (v.length < 8) return 'Password must be at least 8 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  _buildOutlinedPasswordField(
                    label: 'Confirm New Password',
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    onToggle: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                    errorText: _confirmPasswordError,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'This field is required';
                      if (v != _newPasswordController.text) return 'Passwords do not match';
                      return null;
                    },
                  ),
                  const SizedBox(height: 25),
                  _buildSaveChangesButton(),
                  const SizedBox(height: 12),
                  _buildGoBackButton(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOutlinedPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
    String? errorText,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      style: const TextStyle(
        color: Colors.black87,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        labelStyle: TextStyle(
          color: Colors.grey.shade700,
          fontSize: 12,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFBA1A1A), width: 1.5),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: Colors.grey.shade500,
            size: 20,
          ),
          onPressed: onToggle,
        ),
      ),
    );
  }

  Widget _buildSaveChangesButton() {
    return InkWell(
      onTap: _isLoading ? null : _handleSaveChanges,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: _isLoading ? Colors.grey : const Color(0xFFBA1A1A),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            else ...[
              const Icon(Icons.check, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              const Text(
                'Save Changes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGoBackButton() {
    return InkWell(
      onTap: () {
        setState(() {
          _isChangingPassword = false;
          _clearErrorsAndInputs();
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_back, color: Colors.grey.shade700, size: 20),
            const SizedBox(width: 8),
            Text(
              'Go Back',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSaveChanges() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _apiGeneralErrorMessage = null;
        _apiSuccessMessage = null;
        _currentPasswordError = null;
        _newPasswordError = null;
        _confirmPasswordError = null;
      });

      final profileController = Provider.of<ProfileController>(context, listen: false);

      final profileData = {
        'user_firstname': widget.user?.firstName ?? '',
        'user_middlename': widget.user?.middleName ?? '',
        'user_lastname': widget.user?.lastName ?? '',
        'user_suffix': widget.user?.suffix ?? '',
        'user_contactno': widget.user?.contactNo ?? '',
      };

      final passwordData = {
        'current_password': _currentPasswordController.text,
        'new_password': _newPasswordController.text,
        'confirm_password': _confirmPasswordController.text,
      };

      final error = await profileController.updateAccountDetails(
        profileData: profileData,
        passwordData: passwordData,
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      if (error == null) {
        setState(() {
          _isChangingPassword = false;
          _clearErrorsAndInputs();
        });
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (dialogCtx) => const CustomAlertDialog(
            message: 'New password has been saved!',
            icon: Icons.check,
            color: Color(0xFF00C853),
          ),
        );
      } else {
        setState(() {
          _currentPasswordError = error['current_password'];
          _newPasswordError = error['new_password'];
          _confirmPasswordError = error['confirm_password'];
          _apiGeneralErrorMessage = error['general'];
        });
      }
    }
  }

  void _clearErrorsAndInputs() {
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
    _apiGeneralErrorMessage = null;
    _apiSuccessMessage = null;
    _currentPasswordError = null;
    _newPasswordError = null;
    _confirmPasswordError = null;
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
      padding: const EdgeInsets.only(left: 16, bottom: 3),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
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
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _isChangingPassword = true;
                });
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Icon(
                  Icons.edit_outlined,
                  size: 20,
                  color: Color.fromARGB(255, 73, 40, 40),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
