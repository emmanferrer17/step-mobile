import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../app/config/app_colors.dart';
import '../../../app/config/size_config.dart';
import '../../../app/config/ui_constants.dart';
import '../../home/home_page.dart';
import '../../profile/profile_page.dart';
import 'camera_permission_modal.dart';

class MainScaffold extends StatefulWidget {
  final int initialIndex;
  const MainScaffold({super.key, this.initialIndex = 0});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  AnimationController? _hideController;
  ScrollController? _scrollController;
  bool _isVisible = true;

  // Keys to access state for refreshing if needed
  final GlobalKey<HomePageState> _homeKey = GlobalKey<HomePageState>();

  // Size parameters for bottom navigation bar and QR button
  static const double _qrButtonSize = 82.0;
  double get _qrButtonSizeScaled => _qrButtonSize.s;
  double get _notchRadius => (_qrButtonSize / 2 + 6.0).s;
  double get _navBarHeight => (_qrButtonSize - 14.0).s;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    _hideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _hideController?.forward();
    _scrollController = ScrollController();
    _scrollController?.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    _hideController?.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController == null || !_scrollController!.hasClients) return;
    if (_scrollController!.position.userScrollDirection == ScrollDirection.reverse) {
      if (_isVisible) {
        setState(() {
          _isVisible = false;
          _hideController?.reverse();
        });
      }
    } else if (_scrollController!.position.userScrollDirection == ScrollDirection.forward) {
      if (!_isVisible) {
        setState(() {
          _isVisible = true;
          _hideController?.forward();
        });
      }
    }
  }

  void onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (notification is ScrollEndNotification) {
            if (!_isVisible) {
              Future.delayed(const Duration(milliseconds: 1500), () {
                if (mounted && !_isVisible && _scrollController != null && _scrollController!.hasClients && _scrollController!.position.userScrollDirection == ScrollDirection.idle) {
                  setState(() {
                    _isVisible = true;
                    _hideController?.forward();
                  });
                }
              });
            }
          }
          return false;
        },
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            HomePage(key: _homeKey, scrollController: _scrollController),
            const ProfilePage(),
          ],
        ),
      ),
      bottomNavigationBar: _hideController != null 
        ? SizeTransition(
            sizeFactor: _hideController!,
            alignment: Alignment.topCenter,
            child: _buildBottomNav(),
          )
        : _buildBottomNav(),
      floatingActionButton: _hideController != null
        ? ScaleTransition(
            scale: _hideController!,
            child: _buildQRButton(),
          )
        : _buildQRButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildBottomNav() {
    return BottomAppBar(
      color: Colors.transparent,
      elevation: 0,
      padding: EdgeInsets.zero,
      clipBehavior: Clip.none,
      child: Padding(
        padding: EdgeInsets.only(left: 16.s, right: 16.s, bottom: 16.s),
        child: CustomPaint(
          painter: FloatingNavbarPainter(
            cornerRadius: 24.s,
            notchRadius: _notchRadius,
          ),
          child: SizedBox(
            height: _navBarHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Inventory tab (renamed to Items)
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => onItemTapped(0),
                      borderRadius: BorderRadius.circular(50.s),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: _selectedIndex == 0 
                                ? EdgeInsets.symmetric(horizontal: 20.s, vertical: 6.s)
                                : EdgeInsets.zero,
                            decoration: _selectedIndex == 0
                                ? BoxDecoration(
                                    color: AppColors.navBarSelectedHighlight,
                                    borderRadius: BorderRadius.circular(20.s),
                                  )
                                : null,
                            child: SvgPicture.asset(
                              'assets/images/inventory.svg',
                              colorFilter: ColorFilter.mode(
                                _selectedIndex == 0 ? AppColors.primaryRed : AppColors.navBarUnselected,
                                BlendMode.srcIn,
                              ),
                              width: 20.s,
                              height: 20.s,
                            ),
                          ),
                          SizedBox(height: 4.s),
                          Text(
                            'Items',
                            style: TextStyle(
                              color: _selectedIndex == 0 ? AppColors.primaryRed : AppColors.navBarUnselected,
                              fontSize: 10.fs, 
                              fontWeight: _selectedIndex == 0 ? FontWeight.bold : FontWeight.normal
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 80.s), // Maintain gap for the notch
                // Profile tab
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => onItemTapped(1),
                      borderRadius: BorderRadius.circular(25.s),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: _selectedIndex == 1 
                                ? EdgeInsets.symmetric(horizontal: 20.s, vertical: 6.s)
                                : EdgeInsets.zero,
                            decoration: _selectedIndex == 1
                                ? BoxDecoration(
                                    color: AppColors.navBarSelectedHighlight,
                                    borderRadius: BorderRadius.circular(20.s),
                                  )
                                : null,
                            child: SvgPicture.asset(
                              'assets/images/profile.svg',
                              colorFilter: ColorFilter.mode(
                                _selectedIndex == 1 ? AppColors.primaryRed : AppColors.navBarUnselected,
                                BlendMode.srcIn,
                              ),
                              width: 20.s,
                              height: 20.s,
                            ),
                          ),
                          SizedBox(height: 4.s),
                          Text(
                            'Profile',
                            style: TextStyle(
                              color: _selectedIndex == 1 ? AppColors.primaryRed : AppColors.navBarUnselected,
                              fontSize: 10.fs,
                              fontWeight: _selectedIndex == 1 ? FontWeight.bold : FontWeight.normal
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQRButton() {
    return Container(
      width: _qrButtonSizeScaled,
      height: _qrButtonSizeScaled,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4.s,
            offset: Offset(0, 2.s),
          ),
        ],
      ),
      padding: EdgeInsets.all(2.s), // Outer white ring gap
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primaryRed,
            width: 2.s,
          ),
          color: Colors.white, // Inner white ring
        ),
        padding: EdgeInsets.all(2.s), // Thickness of the inner white ring
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryRed,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () async {
                await CameraPermissionModal.startScannerFlow(context);
                _homeKey.currentState?.fetchItems();
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/qr.svg',
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                    width: 28.s,
                    height: 28.s,
                  ),
                  // SizedBox(height: 2.s),
                  // Text(
                  //   'QR',
                  //   style: TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 10.fs,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FloatingNavbarPainter extends CustomPainter {
  final double cornerRadius;
  final double notchRadius;

  FloatingNavbarPainter({
    required this.cornerRadius,
    required this.notchRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final double cx = width / 2;
    final double r = notchRadius;

    final Path path = Path();
    
    // Draw the rounded rectangle with the notch
    path.moveTo(cornerRadius, 0);
    path.lineTo(cx - r, 0);
    
    // Sharp semi-circle notch dipping downwards
    path.arcToPoint(
      Offset(cx + r, 0),
      radius: Radius.circular(r),
      clockwise: false,
    );
    
    path.lineTo(width - cornerRadius, 0);
    path.arcToPoint(
      Offset(width, cornerRadius),
      radius: Radius.circular(cornerRadius),
    );
    
    path.lineTo(width, height - cornerRadius);
    path.arcToPoint(
      Offset(width - cornerRadius, height),
      radius: Radius.circular(cornerRadius),
    );
    
    path.lineTo(cornerRadius, height);
    path.arcToPoint(
      Offset(0, height - cornerRadius),
      radius: Radius.circular(cornerRadius),
    );
    
    path.lineTo(0, cornerRadius);
    path.arcToPoint(
      Offset(cornerRadius, 0),
      radius: Radius.circular(cornerRadius),
    );
    
    path.close();

    // 1. Fill the background
    final Paint fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // 2. Draw the outline (same style as category circles but lighter)
    final Paint strokePaint = Paint()
      ..color = AppColors.navBarOutlineLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5.s;
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant FloatingNavbarPainter oldDelegate) {
    return oldDelegate.cornerRadius != cornerRadius ||
        oldDelegate.notchRadius != notchRadius;
  }
}
