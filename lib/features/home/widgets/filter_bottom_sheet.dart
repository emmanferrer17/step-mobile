import 'package:flutter/material.dart';

class FilterBottomSheet extends StatefulWidget {
  final List<dynamic> items;
  final Map<String, dynamic>? initialFilters;

  const FilterBottomSheet({
    super.key,
    required this.items,
    this.initialFilters,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late String _selectedCategory;
  late String? _selectedSort;
  late List<String> _selectedLocations;
  DateTime? _selectedDate;

  List<String> _availableLocations = [];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.initialFilters?['category'] ?? 'All';
    _selectedSort = widget.initialFilters?['sort'];
    _selectedLocations = List<String>.from(widget.initialFilters?['locations'] ?? []);
    _selectedDate = widget.initialFilters?['date'];

    _extractLocations();
  }

  void _extractLocations() {
    final Set<String> locations = {};
    for (var item in widget.items) {
      final loc = item['location'];
      if (loc != null && loc.toString().isNotEmpty) {
        // Assume location might be "Building - Room" or just "Building"
        // If it's more complex, we might need a better split, but let's take the whole string if it's short
        // or try to find a building name.
        // For now, let's take the distinct values as they are, but maybe strip room numbers if they follow a pattern.
        // Usually, building name is the first part.
        final parts = loc.toString().split(' - ');
        locations.add(parts[0].trim());
      }
    }
    _availableLocations = locations.toList()..sort();
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.85,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              // Handle indicator
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Title
              const Center(
                child: Text(
                  'Filter',
                  style: TextStyle(
                    color: Color(0xFFBA1A1A),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),
              
              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Categories'),
                      _buildRadioList(['All', 'Equipment', 'Semi-Expendable', 'Supplies & Materials'], _selectedCategory, (val) {
                        setState(() => _selectedCategory = val!);
                      }),
                      const Divider(height: 30, color: Color(0xFFEEEEEE)),
                      
                      _buildSectionTitle('Sort by Item Name'),
                      _buildRadioList(['A-Z', 'Z-A'], _selectedSort, (val) {
                        setState(() => _selectedSort = val);
                      }, allowNone: true),
                      const Divider(height: 30, color: Color(0xFFEEEEEE)),
                      
                      if (_availableLocations.isNotEmpty) ...[
                        _buildSectionTitle('Location'),
                        _buildCheckboxList(_availableLocations, _selectedLocations, (val, checked) {
                          setState(() {
                            if (checked) {
                              _selectedLocations.add(val);
                            } else {
                              _selectedLocations.remove(val);
                            }
                          });
                        }),
                        const Divider(height: 30, color: Color(0xFFEEEEEE)),
                      ],
                      
                      _buildSectionTitle('Date Scanned'),
                      const SizedBox(height: 10),
                      _buildDatePicker(),
                    ],
                  ),
                ),
              ),
              
              const Divider(height: 1, color: Color(0xFFEEEEEE)),
              // Bottom Action Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, {
                            'category': _selectedCategory,
                            'sort': _selectedSort,
                            'locations': _selectedLocations,
                            'date': _selectedDate,
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFBA1A1A),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text('Apply Filter', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey,
                          side: const BorderSide(color: Color(0xFFCCCCCC)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text('Cancel', style: TextStyle(fontSize: 14)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black54,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildRadioList(List<String> options, String? selectedValue, ValueChanged<String?> onChanged, {bool allowNone = false}) {
    return Column(
      children: options.map((option) {
        return InkWell(
          onTap: () => onChanged(option == selectedValue && allowNone ? null : option),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(option, style: const TextStyle(color: Colors.black87, fontSize: 14)),
                Radio<String>(
                  value: option,
                  groupValue: selectedValue,
                  onChanged: (val) => onChanged(val == selectedValue && allowNone ? null : val),
                  activeColor: const Color(0xFFBA1A1A),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCheckboxList(List<String> options, List<String> selectedValues, Function(String, bool) onChanged) {
    return Column(
      children: options.map((option) {
        final isSelected = selectedValues.contains(option);
        return InkWell(
          onTap: () => onChanged(option, !isSelected),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(option, style: const TextStyle(color: Colors.black87, fontSize: 14))),
                Checkbox(
                  value: isSelected,
                  onChanged: (val) => onChanged(option, val ?? false),
                  activeColor: const Color(0xFFBA1A1A),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Color(0xFFBA1A1A),
                  onPrimary: Colors.white,
                  onSurface: Colors.black,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          setState(() {
            _selectedDate = picked;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedDate != null
                  ? "${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.year}"
                  : 'mm/dd/yyyy',
              style: TextStyle(
                color: _selectedDate != null ? Colors.black87 : Colors.grey[600],
                fontSize: 14,
              ),
            ),
            Icon(Icons.calendar_today_outlined, color: Colors.grey[600], size: 20),
          ],
        ),
      ),
    );
  }
}
