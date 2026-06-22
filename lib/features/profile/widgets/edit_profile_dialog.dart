import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/user_model.dart';
import 'package:mobile/app/controllers/profile_controller.dart';

/// A fixed-height scrollable modal dialog allowing users to edit their profile details.
class EditProfileDialog extends StatefulWidget {
  final UserModel? user;

  const EditProfileDialog({super.key, this.user});

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  // Global key used to validate and submit the profile edit form.
  final _formKey = GlobalKey<FormState>();

  // Controllers representing personal information fields
  late TextEditingController _firstNameController;
  late TextEditingController _middleNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _suffixController;
  late TextEditingController _contactNoController;
  late TextEditingController _tupIdController;

  // Controllers representing administrative account setups (pre-filled and read-only)
  late TextEditingController _emailController;
  late TextEditingController _userTypeController;
  late TextEditingController _departmentController;

  // Controllers for password updates
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;

  // State flags for managing password visibility toggles
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  bool _isLoading = false;
  String? _apiSuccessMessage;
  String? _apiGeneralErrorMessage;

  String? _firstNameError;
  String? _lastNameError;
  String? _contactNoError;
  String? _currentPasswordError;
  String? _newPasswordError;
  String? _confirmPasswordError;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Initialize personal detail controllers with the user's current data or default to empty
    _firstNameController = TextEditingController(text: widget.user?.firstName ?? '');
    _middleNameController = TextEditingController(text: widget.user?.middleName ?? '');
    _lastNameController = TextEditingController(text: widget.user?.lastName ?? '');
    _suffixController = TextEditingController(text: widget.user?.suffix ?? '');
    _contactNoController = TextEditingController(text: widget.user?.contactNo ?? '');
    _tupIdController = TextEditingController(text: widget.user?.tupId ?? '');

    // Initialize administrative account setup details (typically read-only in edit mode)
    _emailController = TextEditingController(text: widget.user?.email ?? '');
    _userTypeController = TextEditingController(text: widget.user?.userType ?? '');
    _departmentController = TextEditingController(text: widget.user?.departmentName ?? '');

    // Password input controllers start as blank fields
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    // Clean up all text controllers when the widget is removed from the widget tree
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _suffixController.dispose();
    _contactNoController.dispose();
    _tupIdController.dispose();
    _emailController.dispose();
    _userTypeController.dispose();
    _departmentController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header (Sticky)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: const [
                Text(
                  'General Information',
                  style: TextStyle(
                    color: Color(0xFFBA1A1A),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),

          // Scrollable Body Content (Form)
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_apiSuccessMessage != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.green.shade300),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle_outline, color: Colors.green.shade800),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _apiSuccessMessage!,
                                style: TextStyle(
                                  color: Colors.green.shade800,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _apiSuccessMessage = null;
                                });
                              },
                              child: Icon(Icons.close, color: Colors.green.shade800, size: 18),
                            ),
                          ],
                        ),
                      ),
                    if (_apiGeneralErrorMessage != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.red.shade300),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline, color: Colors.red.shade800),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _apiGeneralErrorMessage!,
                                style: TextStyle(
                                  color: Colors.red.shade800,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _apiGeneralErrorMessage = null;
                                });
                              },
                              child: Icon(Icons.close, color: Colors.red.shade800, size: 18),
                            ),
                          ],
                        ),
                      ),
                    _buildSectionTitle('Personal Information'),
                    const SizedBox(height: 10),
                     _buildOutlinedField(
                      label: 'First Name',
                      controller: _firstNameController,
                      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                      errorText: _firstNameError,
                    ),
                    const SizedBox(height: 15),
                    _buildOutlinedField(
                      label: 'Middle Name',
                      controller: _middleNameController,
                      hintText: 'e.g., Santos',
                    ),
                    const SizedBox(height: 15),
                    _buildOutlinedField(
                      label: 'Last Name',
                      controller: _lastNameController,
                      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                      errorText: _lastNameError,
                    ),
                    const SizedBox(height: 15),
                    _buildOutlinedField(
                      label: 'Suffix',
                      controller: _suffixController,
                    ),
                    const SizedBox(height: 15),
                    _buildOutlinedField(
                      label: 'Contact No.',
                      controller: _contactNoController,
                      keyboardType: TextInputType.phone,
                      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                      errorText: _contactNoError,
                    ),
                    const SizedBox(height: 15),
                    _buildOutlinedField(
                      label: 'TUP ID',
                      controller: _tupIdController,
                      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                    ),

                    const SizedBox(height: 25),
                    _buildSectionTitle('Account Setup'),
                    const SizedBox(height: 10),
                    _buildOutlinedField(
                      label: 'TUP Email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      enabled: false, // administrative field
                    ),
                    const SizedBox(height: 15),
                    _buildOutlinedField(
                      label: 'User Type',
                      controller: _userTypeController,
                      enabled: false, // administrative field
                    ),
                    const SizedBox(height: 15),
                    _buildOutlinedField(
                      label: 'Department/Office',
                      controller: _departmentController,
                      enabled: false, // administrative field
                    ),

                    const SizedBox(height: 25),
                    _buildSectionTitle('Password'),
                    const SizedBox(height: 10),
                    _buildOutlinedPasswordField(
                      label: 'Current Password',
                      controller: _currentPasswordController,
                      obscureText: _obscureCurrentPassword,
                      onToggle: () => setState(() => _obscureCurrentPassword = !_obscureCurrentPassword),
                      errorText: _currentPasswordError,
                    ),
                    const SizedBox(height: 15),
                    _buildOutlinedPasswordField(
                      label: 'New Password',
                      controller: _newPasswordController,
                      obscureText: _obscureNewPassword,
                      onToggle: () => setState(() => _obscureNewPassword = !_obscureNewPassword),
                      errorText: _newPasswordError,
                    ),
                    const SizedBox(height: 15),
                    _buildOutlinedPasswordField(
                      label: 'Confirm Password',
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      onToggle: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                      errorText: _confirmPasswordError,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),

          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          // Sticky Bottom Actions
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildGoBackButton(context),
                const SizedBox(height: 12),
                _buildSaveChangesButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Helper: builds a section title for the modal.
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  /// Helper: builds a modern outlined TextFormField.
  Widget _buildOutlinedField({
    required String label,
    required TextEditingController controller,
    String? hintText,
    bool enabled = true,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    String? errorText,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(
        color: enabled ? Colors.black87 : Colors.black54,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        labelStyle: TextStyle(
          color: enabled ? Colors.grey.shade700 : Colors.grey.shade600,
          fontSize: 12,
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 14,
        ),
        filled: !enabled,
        fillColor: enabled ? Colors.transparent : Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFBA1A1A), width: 1.5),
        ),
      ),
    );
  }

  /// Helper: builds a modern password outlined TextFormField with a visibility eye icon.
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

  /// Helper: builds the Go Back action button.
  Widget _buildGoBackButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
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

  /// Helper: builds the Save Changes action button.
  Widget _buildSaveChangesButton(BuildContext context) {
    return InkWell(
      onTap: _isLoading
          ? null
          : () async {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  _isLoading = true;
                });

                final profileController = Provider.of<ProfileController>(context, listen: false);

                final profileData = {
                  'user_firstname': _firstNameController.text.trim(),
                  'user_middlename': _middleNameController.text.trim(),
                  'user_lastname': _lastNameController.text.trim(),
                  'user_suffix': _suffixController.text.trim(),
                  'user_contactno': _contactNoController.text.trim(),
                };

                Map<String, String>? passwordData;
                if (_currentPasswordController.text.isNotEmpty ||
                    _newPasswordController.text.isNotEmpty ||
                    _confirmPasswordController.text.isNotEmpty) {
                  passwordData = {
                    'current_password': _currentPasswordController.text,
                    'new_password': _newPasswordController.text,
                    'confirm_password': _confirmPasswordController.text,
                  };
                }

                // Clear all previous errors before sending requests
                setState(() {
                  _apiSuccessMessage = null;
                  _apiGeneralErrorMessage = null;
                  _firstNameError = null;
                  _lastNameError = null;
                  _contactNoError = null;
                  _currentPasswordError = null;
                  _newPasswordError = null;
                  _confirmPasswordError = null;
                });

                final error = await profileController.updateAccountDetails(
                  profileData: profileData,
                  passwordData: passwordData,
                );

                if (!context.mounted) return;

                setState(() {
                  _isLoading = false;
                });

                if (error == null) {
                  FocusScope.of(context).unfocus(); // Dismiss the soft keyboard
                  setState(() {
                    _apiSuccessMessage = 'Account details updated successfully!';
                  });
                  // Smoothly scroll back to the top of the modal dialog so the user immediately sees the inline success banner
                  _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                } else {
                  setState(() {
                    _firstNameError = error['user_firstname'];
                    _lastNameError = error['user_lastname'];
                    _contactNoError = error['user_contactno'];
                    _currentPasswordError = error['current_password'];
                    _newPasswordError = error['new_password'];
                    _confirmPasswordError = error['confirm_password'];
                    _apiGeneralErrorMessage = error['general'];
                  });
                }
              }
            },
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
}
