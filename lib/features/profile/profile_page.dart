import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import '../../app/config/constants.dart';
import '../../app/config/ui_constants.dart';
import 'package:mobile/app/controllers/auth_controller.dart';
import 'package:mobile/app/controllers/profile_controller.dart';
import '../../data/models/user_model.dart';
import '../../data/services/api_service.dart';
import 'widgets/general_info_dialog.dart';
import 'widgets/faq_dialog.dart';
import '../shared/widgets/gallery_access_modal.dart';
import '../shared/widgets/confirmation_dialog.dart';
import '../shared/widgets/custom_alert_dialog.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = true;
  List<dynamic> _items = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authController = Provider.of<AuthController>(context, listen: false);
      final token = authController.token;
      if (token == null) {
        setState(() {
          _errorMessage = 'Session expired.';
          _isLoading = false;
        });
        return;
      }

      final result = await ApiService().getMrItems(token);
      if (!mounted) return;

      if (result['status'] == 'success') {
        setState(() {
          _items = result['data']?['items'] ?? [];
          _isLoading = false;
        });
      } else {
        final errorMsg = result['message'] ?? 'Failed to load items.';
        setState(() {
          _errorMessage = errorMsg;
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (!mounted) return;
      final errorMsg = 'An error occurred: ${e.toString()}';
      setState(() {
        _errorMessage = errorMsg;
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get status bar height so we manually push content below system status bar icons
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final user = context.watch<AuthController>().loggedInUser;

    return Container(
      color: const Color(0xFFF5EFE6), // Light beige background
      child: Column(
        children: [
          // ─── Red Header Area ────────────────────────────────────────────
          Container(
            width: double.infinity,
            color: const Color(0xFF8C0404),
            padding: EdgeInsets.only(
              top: statusBarHeight, // respect the system status bar
              left: 10.s,
              right: 10.s,
              bottom: 20.s,
            ),
            child: Row(
              children: [
                // Back button – tapping returns to the Home Page
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.s),
                  onPressed: () {
                    // Logic to navigate back to Home index in MainScaffold
                    // For now, since it's an IndexedStack, usually we don't have a "back" 
                    // unless we specifically want to switch tabs.
                    // But if this is used as a standalone, we keep it.
                  },
                ),
                // Centered page title
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 48.0.s),
                    child: Center(
                      child: Text(
                        'My Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.s,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 40.s),

          // ─── Scrollable Body ─────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildProfileCard(context, user),
                  SizedBox(height: 35.s),
                  _buildStatisticsSection(),
                  SizedBox(height: 30.s),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, UserModel? user) {
    final name = user?.fullName ?? 'User Name';
    final role = user?.roleName ?? user?.departmentName ?? 'Unassigned Role/Department';
    final profilePhoto = user?.profilePhoto;

    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: EdgeInsets.only(top: 60.s, left: 15.s, right: 15.s),
          padding: EdgeInsets.only(top: 70.s, left: 20.s, right: 20.s, bottom: 20.s),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.s),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 12.s,
                offset: Offset(0, 5.s),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.s,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 5.s),
              Text(
                role,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.s,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF8C0404),
                ),
              ),
              SizedBox(height: 25.s),
              _buildMenuButton(
                label: 'General Information',
                onPressed: () => _showGeneralInfoModal(context, user),
              ),
              SizedBox(height: 12.s),
              _buildMenuButton(
                label: 'I-TRAC Manual Booklet',
                icon: Icons.help_outline,
                onPressed: () => _showFaqModal(context),
              ),
              SizedBox(height: 12.s),
              _buildMenuButton(
                label: 'Log out',
                icon: Icons.logout,
                isPrimary: true,
                onPressed: () => _showLogoutConfirmation(context),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Center(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blueAccent, width: 4.s),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8.s,
                        offset: Offset(0, 4.s),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 55.s,
                    backgroundColor: const Color(0xFF2C2F33),
                    backgroundImage: NetworkImage(
                      profilePhoto != null 
                          ? '${ApiConstants.storageUrl}$profilePhoto'
                          : '${ApiConstants.storageUrl}img/profiles/blank.avif'
                    ),
                  ),
                ),
                Positioned(
                  bottom: 5.s,
                  right: 5.s,
                  child: GestureDetector(
                    onTap: () {
                      _showGalleryAccessModal(context);
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: EdgeInsets.all(6.s),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF8C0404)),
                      ),
                      child: Icon(Icons.edit_outlined, size: 18.s, color: Colors.black87),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuButton({
    required String label,
    IconData? icon,
    bool isPrimary = false,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10.s),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.s, vertical: 14.s),
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFF8C0404) : Colors.white,
          borderRadius: BorderRadius.circular(10.s),
          border: isPrimary ? null : Border.all(color: const Color(0xFF8C0404)),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: isPrimary ? Colors.white : Colors.black87,
                size: 24.s,
              ),
              SizedBox(width: 15.s),
            ],
            Text(
              label,
              style: TextStyle(
                color: isPrimary ? Colors.white : Colors.black87,
                fontSize: 16.s,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsSection() {
    if (_errorMessage != null) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0.s),
        child: InkWell(
          onTap: _fetchItems,
          child: Container(
            padding: EdgeInsets.all(12.s),
            decoration: BoxDecoration(
              color: const Color(0xFF8C0404).withOpacity(0.05),
              borderRadius: BorderRadius.circular(8.s),
              border: Border.all(color: const Color(0xFF8C0404).withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh, color: const Color(0xFF8C0404), size: 18.s),
                SizedBox(width: 8.s),
                Text(
                  'Failed to load counts. Tap to retry.',
                  style: TextStyle(
                    color: const Color(0xFF8C0404),
                    fontSize: 12.s,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final allCount = _isLoading ? '-' : _items.length.toString();
    final equipmentCount = _isLoading
        ? '-'
        : _items.where((item) => item['category'] == 'Equipment').length.toString();
    final appliancesCount = _isLoading
        ? '-'
        : _items.where((item) => item['category'] == 'Semi-Expendable').length.toString();
    final suppliesCount = _isLoading
        ? '-'
        : _items.where((item) => item['category'] == 'Supplies').length.toString();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0.s),
      child: Column(
        children: [
          Row(
            children: [
              _buildStatBox(
                svgPath: 'assets/images/mr-all.svg',
                count: allCount,
              ),
              _buildStatBox(
                svgPath: 'assets/images/mr-equipment.svg',
                count: equipmentCount,
              ),
              _buildStatBox(
                svgPath: 'assets/images/mr-semi-expandable.svg',
                count: appliancesCount,
              ),
              _buildStatBox(
                svgPath: 'assets/images/mr-supplies.svg',
                count: suppliesCount,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox({
    required String svgPath,
    required String count,
  }) {
    return Expanded(
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Container(
            margin: EdgeInsets.only(top: 30.s, left: 6.s, right: 6.s),
            width: double.infinity,
            constraints: BoxConstraints(minHeight: 80.s),
            padding: EdgeInsets.only(top: 35.s, left: 4.s, right: 4.s, bottom: 10.s),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.s),
              border: Border.all(color: const Color(0xFF8C0404)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 4.s,
                  offset: Offset(0, 2.s),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  count,
                  style: TextStyle(
                    color: const Color(0xFF8C0404),
                    fontSize: 22.s,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            child: SvgPicture.asset(
              svgPath,
              width: 60.s,
              height: 60.s,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60.s,
                  height: 60.s,
                  decoration: const BoxDecoration(
                    color: Color(0xFF8C0404),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: Colors.white,
                    size: 30.s,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showGeneralInfoModal(BuildContext context, UserModel? user) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 20.s, vertical: 24.s),
        child: GeneralInfoDialog(user: user),
      ),
    );
  }

  void _showFaqModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 20.s, vertical: 24.s),
        child: const FaqDialog(),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return ConfirmationDialog(
          message: 'Log out',
          subtitle: 'Are you sure you want to log out?',
          icon: Icons.logout,
          color: const Color(0xFF8C0404),
          confirmText: 'Log out',
          onConfirm: () async {
            final authController = context.read<AuthController>();
            await authController.logout();
            if (context.mounted) {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            }
          },
        );
      },
    );
  }

  void _showGalleryAccessModal(BuildContext context) {
    GalleryAccessModal.startGalleryFlow(
      context,
      onAllow: () => _pickAndCropImage(context),
    );
  }

  Future<void> _pickAndCropImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    if (!context.mounted) return;

    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop',
          toolbarColor: Colors.white,
          toolbarWidgetColor: Colors.black87,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
          cropStyle: CropStyle.circle,
          hideBottomControls: false,
        ),
        IOSUiSettings(
          title: 'Crop',
          cropStyle: CropStyle.circle,
          aspectRatioLockEnabled: true,
        ),
      ],
    );

    if (croppedFile != null && context.mounted) {
      _uploadAvatar(context, File(croppedFile.path));
    }
  }

  Future<void> _uploadAvatar(BuildContext context, File file) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return const CustomAlertDialog(
          message: 'Uploading photo...',
          icon: Icons.cloud_upload_outlined,
          color: Color(0xFF8C0404),
          child: Center(
            child: CircularProgressIndicator(color: Color(0xFF8C0404)),
          ),
        );
      },
    );

    final profileController = Provider.of<ProfileController>(context, listen: false);
    final error = await profileController.updateAvatar(file);

    if (!context.mounted) return;
    Navigator.pop(context);

    if (error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile photo updated successfully!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
