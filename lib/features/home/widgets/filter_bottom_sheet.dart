import 'package:flutter/material.dart';
import '../../../app/config/app_colors.dart';

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
    _selectedCategory = widget.initialFilters?['category'] ?? 'All Items';
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
        decoration: BoxDecoration(
          color: AppColors.modalBackground,
          borderRadius: const BorderRadius.only(
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
                    color: AppColors.borderLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Title
              Center(
                child: Text(
                  'Filter',
                  style: TextStyle(
                    color: AppColors.primaryRed,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Divider(height: 1, color: AppColors.divider),
              
              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Categories'),
                      _buildRadioList(['All Items', 'Equipment', 'Semi-Expendable'], _selectedCategory, (val) {
                        setState(() => _selectedCategory = val!);
                      }),
                      Divider(height: 30, color: AppColors.divider),
                      
                      _buildSectionTitle('Sort by Item Name'),
                      _buildRadioList(['A-Z', 'Z-A'], _selectedSort, (val) {
                        setState(() => _selectedSort = val);
                      }, allowNone: true),
                      Divider(height: 30, color: AppColors.divider),
                      
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
                        Divider(height: 30, color: AppColors.divider),
                      ],
                      
                      _buildSectionTitle('Date Scanned'),
                      const SizedBox(height: 10),
                      _buildDatePicker(),
                    ],
                  ),
                ),
              ),
              
              Divider(height: 1, color: AppColors.divider),
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
                          backgroundColor: AppColors.primaryRed,
                          foregroundColor: AppColors.buttonPrimaryForeground,
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
                          foregroundColor: AppColors.textMuted,
                          side: BorderSide(color: AppColors.borderLight),
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
        style: TextStyle(
          color: AppColors.textMuted,
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
                Text(option, style: TextStyle(color: AppColors.textDark, fontSize: 14)),
                Radio<String>(
                  value: option,
                  groupValue: selectedValue,
                  onChanged: (val) => onChanged(val == selectedValue && allowNone ? null : val),
                  activeColor: AppColors.primaryRed,
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
                Expanded(child: Text(option, style: TextStyle(color: AppColors.textDark, fontSize: 14))),
                Checkbox(
                  value: isSelected,
                  onChanged: (val) => onChanged(option, val ?? false),
                  activeColor: AppColors.primaryRed,
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
                colorScheme: AppColors.isDarkMode
                    ? ColorScheme.dark(
                        primary: AppColors.primaryRed,
                        onPrimary: AppColors.buttonPrimaryForeground,
                        onSurface: AppColors.textDark,
                        surface: AppColors.modalBackground,
                      )
                    : ColorScheme.light(
                        primary: AppColors.primaryRed,
                        onPrimary: AppColors.buttonPrimaryForeground,
                        onSurface: AppColors.textDark,
                        surface: AppColors.modalBackground,
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
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedDate != null
                  ? "${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.year}"
                  : 'mm/dd/yyyy',
              style: TextStyle(
                color: _selectedDate != null ? AppColors.textDark : AppColors.textMuted,
                fontSize: 14,
              ),
            ),
            Icon(Icons.calendar_today_outlined, color: AppColors.textMuted, size: 20),
          ],
        ),
      ),
    );
  }
}
