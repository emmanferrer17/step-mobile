import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import '../../app/config/routes.dart';
import '../../app/config/constants.dart';
import 'package:mobile/app/controllers/auth_controller.dart';
import 'package:mobile/app/controllers/profile_controller.dart';
import '../../data/models/user_model.dart';
import '../../data/services/api_service.dart';
import 'widgets/general_info_dialog.dart';
import 'widgets/faq_dialog.dart';
import '../shared/widgets/camera_permission_modal.dart';

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

    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE6), // Light beige background
      body: Column(
        children: [
          // ─── Red Header Area ────────────────────────────────────────────
          // Contains the status bar space, back arrow, and "My Profile" title.
          Container(
            width: double.infinity,
            color: const Color(0xFF8C0404),
            padding: EdgeInsets.only(
              top: statusBarHeight, // respect the system status bar
              left: 10,
              right: 10,
              bottom: 20,
            ),
            child: Row(
              children: [
                // Back button – tapping returns to the Home Page
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.home);
                  },
                ),
                // Centered page title with a right padding to visually balance the back button
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 48.0),
                    child: Center(
                      child: Text(
                        'My Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // ─── Scrollable Body ─────────────────────────────────────────────
          // Expanded so it fills all remaining space below the header.
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ── Profile Card (overlapping Avatar) ────────────────
                  // ──
                  // Uses a Stack so the CircleAvatar can "float" above the white card
                  _buildProfileCard(context, user),

                  const SizedBox(height: 35),

                  // ── Statistics Section ──────────────────────────────────
                  _buildStatisticsSection(),

                  // Space for the BottomAppBar so last content isn't hidden
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildQRButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  /// Builds the white profile card that overlaps the red header via a top Stack.
  /// The CircleAvatar is Positioned above the card so it appears to float on the
  /// boundary between the red header and the white card.
  Widget _buildProfileCard(BuildContext context, UserModel? user) {
    final name = user?.fullName ?? 'User Name';
    final role = user?.roleName ?? user?.departmentName ?? 'Unassigned Role/Department';
    final profilePhoto = user?.profilePhoto;

    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        // ── White Card Body ─────────────────────────────────────────────
        Container(
          // top margin = half the avatar height (radius 55 + border) so card sits below avatar
          margin: const EdgeInsets.only(top: 60, left: 15, right: 15),
          padding: const EdgeInsets.only(top: 70, left: 20, right: 20, bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              // User's full name
              Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 5),

              // Role/Dept (Red text)
              Text(
                role,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF8C0404),
                ),
              ),
              const SizedBox(height: 25),

              // ── Menu Buttons – General Info, Edit Profile & Log out ─────────────
              _buildMenuButton(
                label: 'General Information',
                onPressed: () => _showGeneralInfoModal(context, user),
              ),
              const SizedBox(height: 12),
              _buildMenuButton(
                label: 'FAQS',
                icon: Icons.help_outline,
                onPressed: () => _showFaqModal(context),
              ),
              const SizedBox(height: 12),
              _buildMenuButton(
                label: 'Log out',
                icon: Icons.logout,
                isPrimary: true,
                onPressed: () => _showLogoutConfirmation(context),
              ),
            ],
          ),
        ),

        // ── Floating CircleAvatar ──────────────────────────────────────
        // Positioned at top spanning full width so hit-testing registers touch events perfectly.
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
                    border: Border.all(color: Colors.blueAccent, width: 4),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 55,
                    backgroundColor: const Color(0xFF2C2F33),
                    backgroundImage: NetworkImage(
                      profilePhoto != null 
                          ? '${ApiConstants.storageUrl}$profilePhoto'
                          : '${ApiConstants.storageUrl}img/profiles/blank.avif'
                    ),
                  ),
                ),
                // Edit Icon Overlay wrapped with GestureDetector for 100% robust touch response
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: GestureDetector(
                    onTap: () {
                      debugPrint("Pencil avatar edit button tapped!");
                      _showGalleryAccessModal(context);
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: const EdgeInsets.all(6), // Slightly larger tap target
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF8C0404)),
                      ),
                      child: const Icon(Icons.edit_outlined, size: 18, color: Colors.black87),
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

  /// Helper: builds a menu button for the profile card.
  Widget _buildMenuButton({
    required String label,
    IconData? icon,
    bool isPrimary = false,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFF8C0404) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: isPrimary ? null : Border.all(color: const Color(0xFF8C0404)),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: isPrimary ? Colors.white : Colors.black87,
                size: 24,
              ),
              const SizedBox(width: 15),
            ],
            Text(
              label,
              style: TextStyle(
                color: isPrimary ? Colors.white : Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the statistics section below the profile card.
  /// Shows four horizontal category boxes: All Items, Equipments, Appliances, and Supplies & Material.
  Widget _buildStatisticsSection() {
    if (_errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: InkWell(
          onTap: _fetchItems,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF8C0404).withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF8C0404).withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.refresh, color: Color(0xFF8C0404), size: 18),
                const SizedBox(width: 8),
                const Text(
                  'Failed to load counts. Tap to retry.',
                  style: TextStyle(
                    color: Color(0xFF8C0404),
                    fontSize: 12,
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
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          // ── Category Breakdown Grid Row ─────────────────────────────
          // Four equal-width boxes utilizing vector SVGs copied from the web app
          Row(
            children: [
              _buildStatBox(
                svgPath: 'assets/images/mr-all.svg',
                count: allCount,
                label: 'All Items',
              ),
              _buildStatBox(
                svgPath: 'assets/images/mr-equipment.svg',
                count: equipmentCount,
                label: 'Equipments',
              ),
              _buildStatBox(
                svgPath: 'assets/images/mr-semi-expandable.svg',
                count: appliancesCount,
                label: 'Semi-expendables',
              ),
              _buildStatBox(
                svgPath: 'assets/images/mr-supplies.svg',
                count: suppliesCount,
                label: 'Supplies & Material',
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Helper: builds one square category statistic box using a vector SVG.
  Widget _buildStatBox({
    required String svgPath,
    required String count,
    required String label,
  }) {
    return Expanded(
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          // ── White Card Body (Container) ─────────────────────────────────
          Container(
            // Top margin for overlap alignment, left/right margins for clean gaps
            margin: const EdgeInsets.only(top: 30, left: 6, right: 6),
            width: double.infinity,
            height: 110, // Uniform slightly taller height
            padding: const EdgeInsets.only(top: 35, left: 4, right: 4, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF8C0404)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Item count (increased to 22px)
                Text(
                  count,
                  style: const TextStyle(
                    color: Color(0xFF8C0404),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                // Category label (increased to 11px, bold)
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF8C0404),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // ── Overlapping Circular SVG Icon (Top Layer) ────────────────────
          Positioned(
            top: 0,
            child: SvgPicture.asset(
              svgPath,
              width: 60,
              height: 60,
              errorBuilder: (context, error, stackTrace) {
                debugPrint('SVG Card Icon Error ($label): $error');
                return Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Color(0xFF8C0404),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.broken_image_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the QR scanner floating action button (center-docked).
  Widget _buildQRButton(BuildContext context) {
    return Container(
      width: 75,
      height: 75,
      margin: const EdgeInsets.only(top: 30),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: const Color(0xFF8C0404), width: 1.5),
      ),
      child: FloatingActionButton(
        elevation: 0,
        backgroundColor: Colors.white,
        shape: const CircleBorder(),
        onPressed: () {
          CameraPermissionModal.startScannerFlow(context);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/qr.svg',
              colorFilter: const ColorFilter.mode(
                Color(0xFF8C0404),
                BlendMode.srcIn,
              ),
              width: 28,
              height: 28,
              errorBuilder: (context, error, stackTrace) {
                debugPrint('SVG QR FAB Error (Profile View): $error');
                return const Icon(
                  Icons.qr_code_scanner,
                  color: Color(0xFF8C0404),
                  size: 28,
                );
              },
            ),
            const SizedBox(height: 4),
            const Text(
              'QR',
              style: TextStyle(
                color: Color(0xFF8C0404),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the bottom navigation bar with a notch for the FAB.
  /// On the Profile Page, the 'Profile' tab is shown as active (bold).
  Widget _buildBottomNav(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      shape: const CircularNotchedRectangle(),
      notchMargin: 6.0,
      padding: EdgeInsets.zero,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Inventory tab – tapping navigates back to Home
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.pushReplacementNamed(context, AppRoutes.home);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/images/inventory.svg',
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF8C0404),
                        BlendMode.srcIn,
                      ),
                      width: 24,
                      height: 24,
                      errorBuilder: (context, error, stackTrace) {
                        debugPrint('SVG Inventory Nav Error (Profile View): $error');
                        return const Icon(
                          Icons.inventory_2_outlined,
                          color: Color(0xFF8C0404),
                          size: 24,
                        );
                      },
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Inventory',
                      style: TextStyle(color: Color(0xFF8C0404), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 80), // Space for the FAB notch
            // Profile tab – currently active page
            Expanded(
              child: InkWell(
                onTap: () {}, // Already on Profile, no-op
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8C0404).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: SvgPicture.asset(
                        'assets/images/profile.svg',
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF8C0404),
                          BlendMode.srcIn,
                        ),
                        width: 24,
                        height: 24,
                        errorBuilder: (context, error, stackTrace) {
                          debugPrint('SVG Profile Nav Error (Profile View): $error');
                          return const Icon(
                            Icons.person,
                            color: Color(0xFF8C0404),
                            size: 24,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Profile',
                      style: TextStyle(
                        color: Color(0xFF8C0404),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Displays a floating pop-up dialog containing the user's detailed information.
  void _showGeneralInfoModal(BuildContext context, UserModel? user) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: GeneralInfoDialog(user: user),
      ),
    );
  }

  /// Displays a floating pop-up dialog containing the system FAQs.
  void _showFaqModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: FaqDialog(),
      ),
    );
  }

  /// Displays a logout confirmation modal and logs the user out if confirmed.
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text(
            'Log out',
            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF8C0404)),
          ),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel', style: TextStyle(color: Colors.black54)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8C0404),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () async {
                Navigator.pop(dialogContext); // close modal
                final authController = context.read<AuthController>();
                await authController.logout();
                if (context.mounted) {
                   Navigator.pushNamedAndRemoveUntil(context, AppRoutes.welcome, (route) => false);
                }
              },
              child: const Text('Log out'),
            ),
          ],
        );
      },
    );
  }

  // ─── Avatar Upload Logic ─────────────────────────────────────────

  /// Step 1: Shows the custom "Allow Access" modal exactly mimicking the screenshot.
  void _showGalleryAccessModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              // Faint red gradient at the top to match screenshot
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.red.withOpacity(0.1),
                  Colors.white,
                  Colors.white,
                ],
                stops: const [0.0, 0.3, 1.0],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Red question mark icon with circular border
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.red.shade100, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Text(
                    '?',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8C0404),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Allow Access',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8C0404),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Would you like to allow this app have access to your gallery ?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.black54, fontSize: 16),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8C0404),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.pop(dialogContext); // Close modal
                        _pickAndCropImage(context);   // Launch gallery
                      },
                      child: const Text(
                        'Allow',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Step 2: Picks the image and opens the circular cropper.
  Future<void> _pickAndCropImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    // Pick an image
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return; // User canceled picking

    if (!context.mounted) return;

    // Crop the image with a Circular UI
    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop',
          toolbarColor: Colors.white,
          toolbarWidgetColor: Colors.black87,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
          cropStyle: CropStyle.circle, // Forces a circle overlay!
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
      // Proceed to upload!
      _uploadAvatar(context, File(croppedFile.path));
    }
  }

  /// Step 3: Uploads the cropped image and updates the UI state.
  Future<void> _uploadAvatar(BuildContext context, File file) async {
    // Show a loading overlay dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFF8C0404)),
        );
      },
    );

    final profileController = Provider.of<ProfileController>(context, listen: false);
    final error = await profileController.updateAvatar(file);

    if (!context.mounted) return;
    
    // Dismiss loading overlay
    Navigator.pop(context);

    if (error == null) {
      // Success
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile photo updated successfully!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      // Failed
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
