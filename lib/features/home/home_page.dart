import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../app/config/routes.dart';
import '../../app/config/constants.dart';
import '../../app/controllers/auth_controller.dart';
import 'widgets/filter_bottom_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int notificationCount = 2;

  final List<Map<String, dynamic>> categories = [
    {'name': 'All', 'iconPath': 'assets/images/all.svg', 'isSelected': true},
    {'name': 'Equipment', 'iconPath': 'assets/images/equipment.svg', 'isSelected': false},
    {'name': 'Semi-Expendable', 'iconPath': 'assets/images/semi-expendable.svg', 'isSelected': false},
    {'name': 'Supplies', 'iconPath': 'assets/images/supplies.svg', 'isSelected': false},
  ];

  final List<Map<String, String>> items = [
    {'name': 'Nintendo Switch', 'location': 'RM 103 - BASD'},
    {'name': 'Table', 'location': 'RM 103 - BASD'},
    {'name': 'Air Conditioning', 'location': 'RM 103 - BASD'},
    {'name': 'Epson Printer', 'location': 'RM 103 - BASD'},
    {'name': 'Chair', 'location': 'RM 103 - BASD'},
    {'name': 'Chair', 'location': 'RM 103 - BASD'},
    {'name': 'Chair', 'location': 'RM 103 - BASD'},
    {'name': 'Chair', 'location': 'RM 103 - BASD'},
    {'name': 'Chair', 'location': 'RM 103 - BASD'},
  ];

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final user = context.watch<AuthController>().loggedInUser;
    final displayName = user?.fullName ?? 'User';
    final profilePhoto = user?.profilePhoto;

    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE6), // Light beige background
      body: Column(
        children: [
          // Overlapping Header Section
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Red Background
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: statusBarHeight + 20,
                  left: 20,
                  right: 20,
                  bottom: 40,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF8C0404),
                ),
                child: _buildHeaderContent(displayName, profilePhoto),
              ),
              // Search Bar & Filter
              Positioned(
                bottom: -25,
                left: 20,
                right: 20,
                child: _buildSearchBarArea(),
              ),
            ],
          ),
          const SizedBox(height: 40),

          // Categories
          _buildCategories(),
          const SizedBox(height: 10),

          // Item List Box
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              clipBehavior: Clip.antiAlias,
              child: _buildItemList(),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildQRButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  /// Builds the top red header section containing:
  /// - User profile picture (CircleAvatar)
  /// - Greeting text ("Hello", User Name)
  /// - Notification bell icon with an unread count badge
  Widget _buildHeaderContent(String userName, String? profilePhoto) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blueAccent, width: 2),
              ),
              child: CircleAvatar(
                radius: 26,
                backgroundColor: Colors.white,
                backgroundImage: profilePhoto != null 
                    ? NetworkImage('${ApiConstants.storageUrl}$profilePhoto')
                    : null,
                child: profilePhoto == null 
                    ? const Icon(Icons.person, size: 35, color: Colors.grey)
                    : null,
              ),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Hello',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                Text(
                  userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(Icons.notifications_none, color: Colors.white, size: 30),
            if (notificationCount > 0)
              Positioned(
                right: -2,
                top: 2,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.lightGreen,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    notificationCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  /// Builds the search bar area that overlaps the red header and the beige body.
  /// Contains:
  /// - A text field for searching items
  /// - A filter button icon on the right side
  Widget _buildSearchBarArea() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                suffixIcon: Icon(Icons.search, color: Colors.grey),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.tune, color: Color(0xFF333333)),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const FilterBottomSheet(),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Builds a horizontally distributed list of categories.
  /// It highlights the currently selected category (e.g., 'All') with a solid
  /// red background and white SVG icon, while unselected ones have a red border and red SVG icon.
  Widget _buildCategories() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: categories.map((category) {
          final isSelected = category['isSelected'] as bool;
          return GestureDetector(
            onTap: () {
              setState(() {
                for (var cat in categories) {
                  cat['isSelected'] = (cat == category);
                }
              });
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 65,
                  height: 65,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? const Color(0xFF8C0404) : Colors.white,
                    border: Border.all(
                      color: const Color(0xFF8C0404),
                      width: 1.5,
                    ),
                  ),
                  child: SvgPicture.asset(
                    category['iconPath'] as String,
                    colorFilter: ColorFilter.mode(
                      isSelected ? Colors.white : const Color(0xFF8C0404),
                      BlendMode.srcIn,
                    ),
                    width: 28,
                    height: 28,
                    errorBuilder: (context, error, stackTrace) {
                      debugPrint('SVG Category Error (${category['name']}): $error');
                      return Icon(
                        Icons.broken_image,
                        color: isSelected ? Colors.white : const Color(0xFF8C0404),
                        size: 28,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  category['name'] as String,
                  style: TextStyle(
                    color: const Color(0xFF8C0404),
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Builds the vertical list of inventory items.
  /// This list is displayed inside a white container with rounded corners (if added)
  /// or simply occupies the remaining space. Each item shows a name and location.
  Widget _buildItemList() {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 10, bottom: 40),
      itemCount: items.length,
      separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFEEEEEE)),
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
          title: Text(
            item['name']!,
            style: const TextStyle(
              color: Color(0xFF8C0404),
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          subtitle: Row(
            children: [
              const Icon(Icons.location_on, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                item['location']!,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          trailing: const Icon(
            Icons.keyboard_double_arrow_right,
            color: Colors.grey,
            size: 22,
          ),
          onTap: () {
            _showItemDetailsModal(context);
          },
        );
      },
    );
  }

  /// Displays the full-screen modal showing details of the clicked item (Nintendo Switch).
  void _showItemDetailsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Modal Top Navigation Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black87),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'Nintendo Switch',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF8C0404),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // Balancing width for centered title
                  ],
                ),
              ),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),
              
              // Scrollable Body Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Upload Photo Box with Red Border
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: const Color(0xFF8C0404),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/images/upload-photo.svg',
                              height: 130,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                debugPrint('SVG Upload Photo Error: $error');
                                return const Icon(
                                  Icons.cloud_upload_outlined,
                                  size: 80,
                                  color: Color(0xFF8C0404),
                                );
                              },
                            ),
                            const SizedBox(height: 15),
                            const Text(
                              'Tap to upload photo',
                              style: TextStyle(
                                color: Color(0xFF8C0404),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.info_outline, size: 13, color: Colors.grey),
                                const SizedBox(width: 4),
                                const Text(
                                  'Supported files: .svg, .png, .jpeg',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // Divider Row with "or"
                            Row(
                              children: [
                                Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    'or',
                                    style: TextStyle(color: Colors.grey[400], fontSize: 14),
                                  ),
                                ),
                                Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
                              ],
                            ),
                            const SizedBox(height: 20),
                            // Open Camera Button
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF8C0404),
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Open camera',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      
                      // Metadata Table / Details List
                      _buildDetailRow('Location', 'Add Location', showEdit: true),
                      const Divider(height: 1, color: Color(0xFFEEEEEE)),
                      _buildDetailRow('Date', '10/09/2020'),
                      const Divider(height: 1, color: Color(0xFFEEEEEE)),
                      _buildDetailRow('Stock', '1'),
                      const Divider(height: 1, color: Color(0xFFEEEEEE)),
                      _buildDetailRow('Unit', '1'),
                      const Divider(height: 1, color: Color(0xFFEEEEEE)),
                      _buildDescriptionDetailRow(
                        'Description',
                        'Custom NVIDIA T239 chip featuring an 8-core ARM Cortex-A78C C... ',
                        'See more',
                      ),
                      const Divider(height: 1, color: Color(0xFFEEEEEE)),
                      _buildDetailRow('Quantity', '1'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Builds a standard row for key-value pair item details.
  Widget _buildDetailRow(String label, String value, {bool showEdit = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: showEdit ? Colors.grey[600] : Colors.black87,
                fontSize: 15,
                fontWeight: showEdit ? FontWeight.w500 : FontWeight.bold,
              ),
            ),
          ),
          if (showEdit)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F1F1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.edit_outlined,
                size: 20,
                color: Colors.black54,
              ),
            ),
        ],
      ),
    );
  }

  /// Builds a details row specifically styled for multi-line description.
  Widget _buildDescriptionDetailRow(String label, String text, String actionText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
                children: [
                  TextSpan(text: text),
                  TextSpan(
                    text: actionText,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the custom floating action button for the QR scanner.
  /// Positioned at the center-docked location of the BottomAppBar.
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
        onPressed: () {
          // [NAVIGATION] Open the QR Scanner page
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
                debugPrint('SVG QR FAB Error: $error');
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

  /// Builds the custom bottom navigation bar with a notch for the FAB.
  /// Contains navigation items like 'Inventory' and 'Profile'.
  Widget _buildBottomNav() {
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
            Expanded(
              child: InkWell(
                onTap: () {},
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
                        'assets/images/inventory.svg',
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF8C0404),
                          BlendMode.srcIn,
                        ),
                        width: 24,
                        height: 24,
                        errorBuilder: (context, error, stackTrace) {
                          debugPrint('SVG Inventory Nav Error: $error');
                          return const Icon(
                            Icons.inventory_2,
                            color: Color(0xFF8C0404),
                            size: 24,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Inventory',
                      style: TextStyle(color: Color(0xFF8C0404), fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 80),
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.profile);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/images/profile.svg',
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF8C0404),
                        BlendMode.srcIn,
                      ),
                      width: 24,
                      height: 24,
                      errorBuilder: (context, error, stackTrace) {
                        debugPrint('SVG Profile Nav Error: $error');
                        return const Icon(
                          Icons.person_outline,
                          color: Color(0xFF8C0404),
                          size: 24,
                        );
                      },
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Profile',
                      style: TextStyle(color: Color(0xFF8C0404), fontSize: 12),
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
