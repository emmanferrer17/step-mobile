import 'package:flutter/material.dart';
import '../../app/config/routes.dart';
import 'widgets/filter_bottom_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String userName = "Patrick Justin Ariado";
  final int notificationCount = 2;

  final List<Map<String, dynamic>> categories = [
    {'name': 'All', 'icon': Icons.inventory_2_outlined, 'isSelected': true},
    {'name': 'Equipment', 'icon': Icons.memory_outlined, 'isSelected': false},
    {'name': 'Appliances', 'icon': Icons.power_outlined, 'isSelected': false},
    {'name': 'Furnitures', 'icon': Icons.chair_outlined, 'isSelected': false},
    {'name': 'Materials', 'icon': Icons.handyman_outlined, 'isSelected': false},
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
                child: _buildHeaderContent(),
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
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
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
  Widget _buildHeaderContent() {
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
              child: const CircleAvatar(
                radius: 26,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 35, color: Colors.grey),
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
            icon: const Icon(Icons.tune, color: Colors.grey),
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

  /// Builds a horizontally scrollable list of categories.
  /// It highlights the currently selected category (e.g., 'All') with a solid
  /// red background and white icon, while unselected ones have a red border.
  Widget _buildCategories() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: categories.map((category) {
          final isSelected = category['isSelected'] as bool;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? const Color(0xFF8C0404) : Colors.white,
                    border: Border.all(
                      color: isSelected ? Colors.transparent : const Color(0xFF8C0404),
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    category['icon'] as IconData,
                    color: isSelected ? Colors.white : const Color(0xFF8C0404),
                    size: 28,
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
          onTap: () {},
        );
      },
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
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.inventory_2, color: Color(0xFF8C0404)),
                    SizedBox(height: 4),
                    Text(
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
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person_outline, color: Color(0xFF8C0404)),
                    SizedBox(height: 4),
                    Text(
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
