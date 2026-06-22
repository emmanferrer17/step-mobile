import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  late int _selectedIndex;
  AnimationController? _hideController;
  ScrollController? _scrollController;
  bool _isVisible = true;

  // Keys to access state for refreshing if needed
  final GlobalKey<HomePageState> _homeKey = GlobalKey<HomePageState>();

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
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
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
      color: const Color(0xFFBA1A1A),
      shape: const CircularNotchedRectangle(),
      notchMargin: 10.0.s,
      padding: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 50.s,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Inventory tab
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
                          color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.4),
                                borderRadius: BorderRadius.circular(20.s),
                              )
                            : null,
                        child: SvgPicture.asset(
                          'assets/images/inventory.svg',
                          colorFilter: ColorFilter.mode(
                            const Color.fromARGB(255, 255, 255, 255),
                            _selectedIndex == 0 ? BlendMode.srcIn : BlendMode.srcIn,
                          ),
                          width: 24.s,
                          height: 24.s,
                        ),
                      ),
                      SizedBox(height: 4.s),
                      Text(
                        'Inventory',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontSize: 12.fs, 
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
                                color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.4),
                                borderRadius: BorderRadius.circular(20.s),
                              )
                            : null,
                        child: SvgPicture.asset(
                          'assets/images/profile.svg',
                          colorFilter: const ColorFilter.mode(
                            Color.fromARGB(255, 255, 255, 255),
                            BlendMode.srcIn,
                          ),
                          width: 24.s,
                          height: 24.s,
                        ),
                      ),
                      SizedBox(height: 4.s),
                      Text(
                        'Profile',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontSize: 12.fs,
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
    );
  }

  Widget _buildQRButton() {
    return Transform.translate(
      offset: Offset(0, 4.s), // Lower the button deeper into the notch
      child: SizedBox(
        width: UIConstants.qrButtonSize.s,
        height: UIConstants.qrButtonSize.s,
        child: FloatingActionButton(
          backgroundColor: const Color(0xFFBA1A1A),
          shape: const CircleBorder(),
          onPressed: () async {
            await CameraPermissionModal.startScannerFlow(context);
            _homeKey.currentState?.fetchItems();
          },
          child: SvgPicture.asset(
            'assets/images/qr.svg',
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
            width: UIConstants.qrIconSize.s,
            height: UIConstants.qrIconSize.s,
          ),
        ),
      ),
    );
  }
}
