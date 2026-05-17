import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../app/config/routes.dart';
import '../../app/config/constants.dart';
import '../../app/controllers/auth_controller.dart';
import '../../data/models/user_model.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
                  // ── Profile Card (overlapping Avatar) ──────────────────
                  // Uses a Stack so the CircleAvatar can "float" above the white card
                  _buildProfileCard(context, user),

                  const SizedBox(height: 20),

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
                label: 'Edit Profile',
                icon: Icons.edit_outlined,
                onPressed: () {},
              ),
              const SizedBox(height: 12),
              _buildMenuButton(
                label: 'Log out',
                icon: Icons.logout,
                isPrimary: true,
                onPressed: () {},
              ),
            ],
          ),
        ),

        // ── Floating CircleAvatar ──────────────────────────────────────
        // Positioned at top so it straddles the header/card boundary
        Positioned(
          top: 0,
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
                  backgroundImage: profilePhoto != null 
                      ? NetworkImage('${ApiConstants.storageUrl}$profilePhoto')
                      : null,
                  child: profilePhoto == null 
                      ? const Icon(Icons.person, size: 80, color: Colors.white54)
                      : null,
                ),
              ),
              // Edit Icon Overlay
              Positioned(
                bottom: 5,
                right: 5,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: const Icon(Icons.edit_outlined, size: 18, color: Colors.black54),
                ),
              ),
            ],
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
          border: isPrimary ? null : Border.all(color: Colors.grey.shade400),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: isPrimary ? Colors.white : Colors.black54,
                size: 24,
              ),
              const SizedBox(width: 15),
            ],
            Text(
              label,
              style: TextStyle(
                color: isPrimary ? Colors.white : Colors.black54,
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
  /// Shows a summary "All Items" row and four category boxes.
  Widget _buildStatisticsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          // ── "All Items" Summary Row ────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF8C0404).withOpacity(0.4)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      color: const Color(0xFF8C0404).withOpacity(0.8),
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'All Items',
                      style: TextStyle(color: Color(0xFF8C0404), fontSize: 16),
                    ),
                  ],
                ),
                // Total item count
                const Text(
                  '14',
                  style: TextStyle(
                    color: Color(0xFF8C0404),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // ── Category Breakdown Grid Row ─────────────────────────────
          // Four equal-width boxes: Equipment, Appliances, Furniture, Materials
          Row(
            children: [
              _buildStatBox(icon: Icons.memory, count: '4', label: 'Equipment'),
              _buildStatBox(icon: Icons.power, count: '2', label: 'Appliances'),
              _buildStatBox(icon: Icons.chair_outlined, count: '5', label: 'Furniture'),
              _buildStatBox(icon: Icons.handyman, count: '3', label: 'Materials'),
            ],
          ),
        ],
      ),
    );
  }

  /// Helper: builds one square category statistic box.
  Widget _buildStatBox({
    required IconData icon,
    required String count,
    required String label,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF8C0404).withOpacity(0.4)),
        ),
        child: Column(
          children: [
            // Red circular icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color(0xFF8C0404),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(height: 8),
            // Item count
            Text(
              count,
              style: const TextStyle(
                color: Color(0xFF8C0404),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            // Category label
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF8C0404),
                fontSize: 10,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
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
          Navigator.pushNamed(context, AppRoutes.qrScanner);
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

  /// Displays a modal containing the user's detailed information.
  void _showGeneralInfoModal(BuildContext context, UserModel? user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (_, controller) {
            return Column(
              children: [
                // Modal Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
                const Divider(height: 1),
                Expanded(
                  child: ListView(
                    controller: controller,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
                    children: [
                      _buildSectionTitle('Personal Information'),
                      _buildInfoField('First Name', user?.firstName ?? 'N/A'),
                      _buildInfoField('Middle Name', (user?.middleName == null || user!.middleName.isEmpty) ? 'N/A' : user.middleName),
                      _buildInfoField('Last Name', user?.lastName ?? 'N/A'),
                      _buildInfoField('Suffix', (user?.suffix == null || user!.suffix.isEmpty) ? 'N/A' : user.suffix),
                      _buildInfoField('Contact No.', user?.contactNo ?? 'N/A'),
                      
                      const SizedBox(height: 20),
                      _buildSectionTitle('Account Setup'),
                      _buildInfoField('TUP-ID', user?.tupId ?? 'N/A'),
                      _buildInfoField('TUP Email', user?.email ?? 'N/A'),
                      _buildInfoField('User Type', user?.userType ?? 'N/A'),
                      _buildInfoField('Department/Office', user?.departmentName ?? 'N/A'),
                      _buildPasswordField('Password'),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Helper: builds a section title for the modal.
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  /// Helper: builds a single labeled info field.
  Widget _buildInfoField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
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
      padding: const EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '••••••••••••',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  letterSpacing: 2,
                ),
              ),
              Icon(
                Icons.visibility_off_outlined,
                color: Colors.grey.shade600,
                size: 22,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
