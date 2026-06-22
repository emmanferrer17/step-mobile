import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app/config/size_config.dart';
import '../../app/config/ui_constants.dart';
import '../../app/controllers/auth_controller.dart';
import '../../data/services/api_service.dart';
import '../home/widgets/item_details_modal.dart';

/// A modern, fullscreen screen displaying the inventory Archive log fetching real data from the API.
class ArchivePage extends StatefulWidget {
  const ArchivePage({super.key});

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  List<dynamic> _assignedItems = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchArchiveItems();
  }

  Future<void> _fetchArchiveItems() async {
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
          _assignedItems = result['data']?['items'] ?? result['items'] ?? [];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Failed to load archived items.';
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

  /// Format date helper without dependency on intl package
  String _formatDateLabel(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Date Received: Today';
    }

    final List<String> months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    final String monthName = months[date.month - 1];
    return 'Date Received: $monthName ${date.day}, ${date.year}';
  }

  /// Groups items by the date they were scanned, sorting descending
  Map<String, List<dynamic>> _groupItemsByDate(List<dynamic> items) {
    final Map<String, List<dynamic>> groups = {};

    // Sort items descending by date_scanned first
    final sortedItems = List<dynamic>.from(items);
    sortedItems.sort((a, b) {
      final dateA = DateTime.tryParse(a['date_scanned'] ?? '') ?? DateTime(1970);
      final dateB = DateTime.tryParse(b['date_scanned'] ?? '') ?? DateTime(1970);
      return dateB.compareTo(dateA); // Descending (newest first)
    });

    for (final item in sortedItems) {
      final dateStr = item['date_scanned'];
      if (dateStr == null) continue;
      final parsedDate = DateTime.tryParse(dateStr);
      if (parsedDate == null) continue;

      final label = _formatDateLabel(parsedDate.toLocal());
      if (!groups.containsKey(label)) {
        groups[label] = [];
      }
      groups[label]!.add(item);
    }

    return groups;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF5EFE6), // Matching home screen light beige background
      appBar: AppBar(
        backgroundColor: const Color(0xFFBA1A1A), // Dark red university brand color
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 60.s,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 26.s),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Archive',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.s,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFFBA1A1A),
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Color(0xFFBA1A1A), size: 48),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchArchiveItems,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFBA1A1A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_assignedItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, color: Colors.grey.shade400, size: 64.s),
            SizedBox(height: 16.s),
            Text(
              'Your archive is empty',
              style: TextStyle(
                fontSize: 18.s,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.s),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.s),
              child: Text(
                'Items you scan or receive will appear here as part of your inventory history.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.s,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final grouped = _groupItemsByDate(_assignedItems);
    final dateKeys = grouped.keys.toList();

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: dateKeys.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final dateLabel = dateKeys[index];
        final items = grouped[dateLabel]!;
        return _buildDateGroupCard(
          context,
          dateLabel: dateLabel,
          items: items,
        );
      },
    );
  }

  Widget _buildDateGroupCard(
    BuildContext context, {
    required String dateLabel,
    required List<dynamic> items,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.s),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.s),
        border: Border.all(color: Colors.grey.shade300, width: 1.0.s),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4.s,
            offset: Offset(0, 2.s),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header Bar displaying Date Received
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.s, vertical: 12.s),
            child: Text(
              dateLabel,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 13.s,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),

          // Item listings inside the group
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFEEEEEE)),
            itemBuilder: (context, index) {
              final item = items[index];
              final String name = item['item_name'] ?? 'Unknown Item';
              final qty = item['quantity'] ?? 1;
              final unit = item['unit'] ?? 'pcs';

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.s, vertical: 14.s),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Item details text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              color: const Color(0xFFBA1A1A),
                              fontSize: 16.s,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.s),
                          Text(
                            'Quantity: $qty $unit',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12.s,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12.s),

                    // view details -> action button
                    GestureDetector(
                      onTap: () => _showItemDetailsModal(context, item),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.s, vertical: 8.s),
                        decoration: BoxDecoration(
                          color: const Color(0xFFBA1A1A),
                          borderRadius: BorderRadius.circular(8.s),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'details',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13.s,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 4.s),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 14.s,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Helper: displays the floating popup dialog showing item details when view details is tapped.
  void _showItemDetailsModal(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: ItemDetailsModal(
          itemDetails: item,
        ),
      ),
    );
  }
}
