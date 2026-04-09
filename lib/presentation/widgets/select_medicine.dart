import 'package:flutter/material.dart';

class SelectMedicine extends StatefulWidget {
  final String label;
  final IconData? icon;
  final String? hint;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int? maxLines;
  const SelectMedicine({super.key, required this.label, this.hint, this.validator, this.maxLines, this.icon, this.keyboardType});

  @override
  State<SelectMedicine> createState() => _SelectMedicineState();
}

class _SelectMedicineState extends State<SelectMedicine> {
  
  final controller = new TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: widget.maxLines,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        prefixIcon: Icon(widget.icon, color: const Color(0xFF2563EB), size: 20),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
              color: Color(0xFF2563EB), width: 2),
        ),
        labelStyle: const TextStyle(color: Color(0xFF8A99B0)),
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 14),
      ),
    );
  }
}