import 'package:flutter/material.dart';

class CustomToggle extends StatefulWidget {
  final List<String>
      options; // Options like ["Light", "Dark"] or ["English", "Thai"]
  final int selectedIndex; // Currently selected index
  final Function(int) onChanged; // Callback when selection changes
  final Color selectedColor;
  final Color unselectedColor;

  const CustomToggle({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onChanged,
    this.selectedColor = const Color.fromARGB(255, 231, 199, 14),
    this.unselectedColor = Colors.black,
  });

  @override
  State<CustomToggle> createState() => _CustomToggleState();
}

class _CustomToggleState extends State<CustomToggle> {
  late List<bool> isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = List.generate(
        widget.options.length, (index) => index == widget.selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      borderRadius: BorderRadius.circular(16),
      selectedBorderColor: widget.selectedColor,
      selectedColor: Colors.white,
      fillColor: widget.selectedColor,
      color: widget.unselectedColor,
      constraints: const BoxConstraints(minHeight: 80, minWidth: 160),
      isSelected: isSelected,
      onPressed: (int index) {
        setState(() {
          isSelected = List.generate(widget.options.length, (i) => i == index);
        });
        widget.onChanged(index);
      },
      children: widget.options
          .map((option) => Text(
                option,
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold), // Set text size
              ))
          .toList(),
    );
  }
}
