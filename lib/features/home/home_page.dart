import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../app/config/routes.dart';
import '../../app/config/constants.dart';
import '../../app/controllers/auth_controller.dart';
import '../../data/services/api_service.dart';
import 'widgets/filter_bottom_sheet.dart';
import 'widgets/item_details_modal.dart';
import '../shared/widgets/camera_permission_modal.dart';

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

  // State variables for dynamic items and loading
  List<dynamic> _assignedItems = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';
  String _selectedCategory = 'All';

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
          _errorMessage = 'Session expired. Please log in again.';
          _isLoading = false;
        });
        return;
      }

      final result = await ApiService().getMrItems(token);
      if (!mounted) return;

      if (result['status'] == 'success') {
        setState(() {
          _assignedItems = result['data']?['items'] ?? [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Failed to load items.';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'An error occurred: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  List<dynamic> get _filteredItems {
    List<dynamic> list = _assignedItems;
    if (_selectedCategory != 'All') {
      list = list.where((item) => item['category'] == _selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      list = list.where((item) {
        final name = (item['item_name'] ?? '').toString().toLowerCase();
        final location = (item['location'] ?? '').toString().toLowerCase();
        return name.contains(query) || location.contains(query);
      }).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final user = context.watch<AuthController>().loggedInUser;
    final displayName = user?.fullName ?? 'User';
    final profilePhoto = user?.profilePhoto;

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: SvgPicture.asset(
            'assets/images/archive.svg',
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
            width: 20,
            height: 20,
            errorBuilder: (context, error, stackTrace) {
              debugPrint('SVG Archive Header Error: $error');
              return const Icon(
                Icons.archive,
                color: Colors.white,
                size: 30,
              );
            },
          ),
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.archive);
          },
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
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim();
                });
              },
              decoration: const InputDecoration(
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
                _selectedCategory = category['name'] as String;
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
  Widget _buildItemList() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF8C0404)),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 40, color: Colors.red),
              const SizedBox(height: 10),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black87),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: _fetchItems,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8C0404),
                  foregroundColor: Colors.white,
                ),
                child: const Text('RETRY'),
              ),
            ],
          ),
        ),
      );
    }

    final filtered = _filteredItems;

    if (filtered.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.inventory_2_outlined, size: 50, color: Colors.grey),
              const SizedBox(height: 12),
              Text(
                _searchQuery.isNotEmpty 
                    ? 'No matching items found.' 
                    : 'No items assigned to your account.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54, fontSize: 15),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchItems,
      color: const Color(0xFF8C0404),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 10, bottom: 40),
        itemCount: filtered.length,
        separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFEEEEEE)),
        itemBuilder: (context, index) {
          final item = filtered[index];
          final name = item['item_name'] ?? 'Unknown Item';
          final location = item['location'] ?? 'Unknown Location';
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
            title: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
                Expanded(
                  child: Text(
                    location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
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
              _showItemDetailsModal(context, item);
            },
          );
        },
      ),
    );
  }

  /// Displays the floating pop-up dialog showing details of the clicked item.
  void _showItemDetailsModal(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: ItemDetailsModal(itemDetails: item),
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
        onPressed: () async {
          // [NAVIGATION] Open the QR Scanner page after permission verification
          await CameraPermissionModal.startScannerFlow(context);
          _fetchItems(); // Refresh items when returning from the scanner
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
