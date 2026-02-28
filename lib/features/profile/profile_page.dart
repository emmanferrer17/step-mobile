import 'package:flutter/material.dart';
import '../../app/config/routes.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get status bar height so we manually push content below system status bar icons
    final double statusBarHeight = MediaQuery.of(context).padding.top;

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
                  _buildProfileCard(),

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
      floatingActionButton: _buildQRButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  /// Builds the white profile card that overlaps the red header via a top Stack.
  /// The CircleAvatar is Positioned above the card so it appears to float on the
  /// boundary between the red header and the white card.
  Widget _buildProfileCard() {
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
              const Text(
                'Patrick Justin Ariado',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 25),

              // ── Info Rows – Email, Role, Department ─────────────────
              _buildInfoRow(
                icon: Icons.email_outlined,
                text: 'gilbert.pinili@tup.edu.ph',
              ),
              const Divider(height: 25, color: Color(0xFFEEEEEE)),
              _buildInfoRow(
                icon: Icons.work_outline,
                text: 'Faculty',
              ),
              const Divider(height: 25, color: Color(0xFFEEEEEE)),
              _buildInfoRow(
                icon: Icons.groups_outlined,
                text: 'Assistant Director for Research and Extension Office',
              ),

              const SizedBox(height: 30),

              // ── Action Buttons – Edit Profile & Log out ─────────────
              Row(
                children: [
                  // "edit profile" button – solid red fill
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {}, // Logic will be added later
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8C0404),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Edit',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  // "Log out" button – white fill with red border
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {}, // Logic will be added later
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF8C0404)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Log out',
                        style: TextStyle(color: Color(0xFF8C0404), fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // ── Floating CircleAvatar ──────────────────────────────────────
        // Positioned at top so it straddles the header/card boundary
        Positioned(
          top: 0,
          child: Container(
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
            child: const CircleAvatar(
              radius: 55,
              backgroundColor: Color(0xFF2C2F33),
              child: Icon(Icons.person, size: 80, color: Colors.white54),
            ),
          ),
        ),
      ],
    );
  }

  /// Helper: builds one info row with a circular red icon and detail text.
  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Circular red icon container
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Color(0xFF8C0404),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 15),
        // Detail text, wrapped so it doesn't overflow
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ),
      ],
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
  Widget _buildQRButton() {
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
        onPressed: () {},
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.qr_code_scanner, color: Color(0xFF8C0404), size: 28),
            SizedBox(height: 2),
            Text(
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
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.inventory_2_outlined, color: Color(0xFF8C0404)),
                    SizedBox(height: 4),
                    Text(
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
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person, color: Color(0xFF8C0404)),
                    SizedBox(height: 4),
                    Text(
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
}
