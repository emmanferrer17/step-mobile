import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../app/config/constants.dart';
import '../../app/config/app_colors.dart';
import '../../app/config/ui_constants.dart';
import '../../app/controllers/auth_controller.dart';
import '../../app/controllers/home_controller.dart';
import '../../data/models/user_model.dart';
import '../../data/services/api_service.dart';
import 'widgets/item_details_modal.dart';
import 'widgets/filter_bottom_sheet.dart';
import '../shared/widgets/main_scaffold.dart';

class HomePage extends StatefulWidget {
  final ScrollController? scrollController;
  const HomePage({super.key, this.scrollController});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> categories = [
    {'name': 'All', 'iconPath': 'assets/images/all.svg', 'isSelected': true},
    {'name': 'Equipment', 'iconPath': 'assets/images/equipment.svg', 'isSelected': false},
    {'name': 'Semi-Expendable', 'iconPath': 'assets/images/semi-expendable.svg', 'isSelected': false},
    {'name': 'Supplies & Materials', 'iconPath': 'assets/images/supplies.svg', 'isSelected': false},
  ];

  // State variables for dynamic items and loading
  List<dynamic> _assignedItems = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';
  String _selectedCategory = 'All';
  Map<String, dynamic> _appliedFilters = {};

  @override
  void initState() {
    super.initState();
    fetchItems();
  }

  Future<void> fetchItems() async {
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

  void _clearFilters() {
    setState(() {
      _appliedFilters = {};
    });
  }

  List<dynamic> get _filteredItems {
    List<dynamic> list = List.from(_assignedItems);

    // 1. Category filter (synced between top bar and filter sheet)
    if (_selectedCategory != 'All') {
      list = list.where((item) => item['category'] == _selectedCategory).toList();
    }

    // 2. Advanced filters from bottom sheet
    if (_appliedFilters.isNotEmpty) {
      // Location
      final locations = _appliedFilters['locations'] as List<String>?;
      if (locations != null && locations.isNotEmpty) {
        list = list.where((item) {
          final loc = (item['location'] ?? '').toString();
          return locations.any((l) => loc.startsWith(l));
        }).toList();
      }

      // Date
      final date = _appliedFilters['date'] as DateTime?;
      if (date != null) {
        list = list.where((item) {
          final scannedAt = item['date_scanned'];
          if (scannedAt == null) return false;
          final d = DateTime.tryParse(scannedAt.toString());
          if (d == null) return false;
          return d.year == date.year && d.month == date.month && d.day == date.day;
        }).toList();
      }

      // Sort
      final sort = _appliedFilters['sort'] as String?;
      if (sort == 'A-Z') {
        list.sort((a, b) => (a['item_name'] ?? '').toString().compareTo((b['item_name'] ?? '').toString()));
      } else if (sort == 'Z-A') {
        list.sort((a, b) => (b['item_name'] ?? '').toString().compareTo((a['item_name'] ?? '').toString()));
      }
    }

    // 3. Search query (always live)
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

    return Container(
      color: const Color(0xFFF5EFE6), // Light beige background
      child: Column(
        children: [
          // Overlapping Header Section
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Red Background
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: statusBarHeight + 20.s,
                  left: 20.s,
                  right: 20.s,
                  bottom: 40.s,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFFBA1A1A),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: _buildHeaderContent(user, displayName, profilePhoto),
              ),
              // Search Bar & Filter
              Positioned(
                bottom: -25.s,
                left: 20.s,
                right: 20.s,
                child: _buildSearchBarArea(),
              ),
            ],
          ),
          SizedBox(height: 40.s),

          // Categories
          _buildCategories(),
          SizedBox(height: 10.s),

          // Item List Box
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 20.s, right: 20.s, top: 8.s, bottom: 30.s), // Increased top margin, added bottom margin
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.s),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  _buildStickyCategoryHeader(),
                  Expanded(child: _buildItemList()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStickyCategoryHeader() {
    // Only show "Remove filters" if there are applied filters (independent of category)
    final bool hasActiveFilters = _appliedFilters.isNotEmpty;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 15.s, vertical: 12.s),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                _selectedCategory,
                style: TextStyle(
                  color: const Color(0xFFBA1A1A),
                  fontSize: 14.s,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.s),
                child: Text(
                  '${_filteredItems.length} items',
                  style: TextStyle(
                    fontSize: 13.s,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
          if (hasActiveFilters)
            GestureDetector(
              onTap: _clearFilters,
              child: Text(
                'Remove filters',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 12.s,
                  color: AppColors.primaryRed,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeaderContent(UserModel? user, String userName, String? profilePhoto) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  final mainScaffold = context.findAncestorStateOfType<State<MainScaffold>>();
                  if (mainScaffold != null) {
                    try {
                      (mainScaffold as dynamic).onItemTapped(1);
                    } catch (_) {}
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blueAccent, width: 2.s),
                  ),
                  child: CircleAvatar(
                    radius: 26.s,
                    backgroundColor: Colors.white,
                    backgroundImage: profilePhoto != null 
                        ? NetworkImage('${ApiConstants.storageUrl}$profilePhoto')
                        : null,
                    child: profilePhoto == null 
                        ? Icon(Icons.person, size: 35.s, color: Colors.grey)
                        : null,
                  ),
                ),
              ),
              SizedBox(width: 15.s),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 22.s,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          userName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.s,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      user?.roleName ?? user?.userType ?? '',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 12.s,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 10.s),
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: SvgPicture.asset(
            'assets/images/archive.svg',
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
            width: 20.s,
            height: 20.s,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/archive');
          },
        ),
      ],
    );
  }

  Widget _buildSearchBarArea() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50.s,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.s),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 5.s,
                  offset: Offset(0, 3.s),
                )
              ],
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 15.s),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 15.s, vertical: 15.s),
                suffixIcon: const Icon(Icons.search, color: Colors.grey),
              ),
            ),
          ),
        ),
        SizedBox(width: 10.s),
        Container(
          height: 50.s,
          width: 50.s,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.s),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 5.s,
                offset: Offset(0, 3.s),
              )
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.tune, color: Color(0xFF333333)),
            onPressed: () async {
              final result = await showModalBottomSheet<Map<String, dynamic>>(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => FilterBottomSheet(
                  items: _assignedItems,
                  initialFilters: _appliedFilters,
                ),
              );

              if (result != null) {
                setState(() {
                  _appliedFilters = result;
                  // Sync top category if it changed in the filter sheet
                  final sheetCat = result['category'] as String?;
                  if (sheetCat != null) {
                    _selectedCategory = sheetCat;
                    for (var cat in categories) {
                      cat['isSelected'] = (cat['name'] == sheetCat);
                    }
                  }
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategories() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 15.s),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: categories.map((category) {
          final isSelected = category['isSelected'] as bool;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.s),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  for (var cat in categories) {
                    cat['isSelected'] = (cat == category);
                  }
                  _selectedCategory = category['name'] as String;
                });
              },
              child: Container(
                width: 65.s,
                height: 65.s,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.primaryRed : Colors.white,
                  border: isSelected
                      ? null
                      : Border.all(
                          color: AppColors.categoryCircleUnselected,
                          width: 1.5.s,
                        ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x1A000000), // Reduced opacity (from 2B to 1A)
                      blurRadius: 6.s, // Reduced blur (from 10 to 6)
                      offset: Offset(0, 2.s), // Adjusted offset
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  category['iconPath'] as String,
                  colorFilter: ColorFilter.mode(
                    isSelected ? Colors.white : AppColors.categoryCircleUnselected,
                    BlendMode.srcIn,
                  ),
                  width: 28.s,
                  height: 28.s,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildItemList() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFBA1A1A)),
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
                onPressed: fetchItems,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFBA1A1A),
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
      onRefresh: fetchItems,
      color: const Color(0xFFBA1A1A),
      child: ListView.separated(
        controller: widget.scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: 10.s, bottom: 40.s),
        itemCount: filtered.length,
        separatorBuilder: (context, index) => Divider(height: 1, color: const Color(0xFFEEEEEE)),
        itemBuilder: (context, index) {
          final item = filtered[index];
          final name = item['item_name'] ?? 'Unknown Item';
          final location = item['location'] ?? 'Unknown Location';
          return ListTile(
            dense: true,
            visualDensity: const VisualDensity(vertical: -1),
            contentPadding: EdgeInsets.symmetric(horizontal: 15.s, vertical: 0),
            minVerticalPadding: 0,
            title: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: const Color(0xFFBA1A1A),
                fontWeight: FontWeight.w600,
                fontSize: 16.s,
              ),
            ),
            subtitle: Row(
              children: [
                Icon(Icons.location_on, size: 14.s, color: AppColors.itemLocationColor),
                SizedBox(width: 4.s),
                Expanded(
                  child: Text(
                    location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.itemLocationColor,
                      fontSize: 13.s,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            trailing: Icon(
              Icons.keyboard_double_arrow_right,
              color: Colors.grey,
              size: 22.s,
            ),
            onTap: () {
              _showItemDetailsModal(context, item);
            },
          );
        },
      ),
    );
  }

  void _showItemDetailsModal(BuildContext context, Map<String, dynamic> item) async {
    final homeController = context.read<HomeController>();
    
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: ChangeNotifierProvider.value(
          value: homeController,
          child: ItemDetailsModal(itemDetails: item),
        ),
      ),
    );

    if (result == true) {
      fetchItems();
    }
  }
}
