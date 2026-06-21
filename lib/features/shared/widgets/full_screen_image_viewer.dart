import 'dart:io';
import 'package:flutter/material.dart';

class FullScreenImageViewer extends StatefulWidget {
  final List<String>? imageUrls;
  final List<File>? imageFiles;
  final int initialIndex;

  const FullScreenImageViewer({
    super.key,
    this.imageUrls,
    this.imageFiles,
    this.initialIndex = 0,
  }) : assert(imageUrls != null || imageFiles != null, 'Either imageUrls or imageFiles must be provided');

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();

  static void show(BuildContext context, {List<String>? imageUrls, List<File>? imageFiles, int initialIndex = 0}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => FullScreenImageViewer(
          imageUrls: imageUrls,
          imageFiles: imageFiles,
          initialIndex: initialIndex,
        ),
      ),
    );
  }
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int get _totalItems => (widget.imageUrls?.length ?? 0) + (widget.imageFiles?.length ?? 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Image Area
          Center(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _totalItems,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final int networkCount = widget.imageUrls?.length ?? 0;
                
                Widget imageWidget;
                if (index < networkCount) {
                  imageWidget = Image.network(
                    widget.imageUrls![index],
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(Icons.broken_image, color: Colors.white, size: 50),
                    ),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    },
                  );
                } else {
                  final fileIndex = index - networkCount;
                  imageWidget = Image.file(
                    widget.imageFiles![fileIndex],
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                  );
                }

                return InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Hero(
                    tag: 'item_image_hero_$index',
                    child: imageWidget,
                  ),
                );
              },
            ),
          ),
          
          // Close Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),

          // Index Indicator
          if (_totalItems > 1)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 20,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_currentIndex + 1} / $_totalItems',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
