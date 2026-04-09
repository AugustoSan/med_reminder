import 'package:flutter/material.dart';
import 'package:med_reminder/core/theme/app_theme.dart';
import 'package:med_reminder/data/models/models.dart';
import 'package:med_reminder/presentation/providers/providers.dart';
import 'package:provider/provider.dart';

class MedicamentoSearchField extends StatelessWidget {
  final String label;
  final IconData? icon;
  final String? hint;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int? maxLines;
  const MedicamentoSearchField({
    super.key,
    required this.label,
    this.hint,
    this.validator,
    this.maxLines,
    this.icon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    //Cargar elementos al iniciar la pantalla, para que el usuario pueda buscar entre los medicamentos existentes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MedicationProvider>().cargarMedicamentos();
    });
    return Consumer<MedicationProvider>(
      builder: (context, provider, _ ) {
        return Autocomplete<MedicationModel>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<MedicationModel>.empty();
            }
            return provider.medicamentos.where((MedicationModel medicamento) {
              return medicamento.nombre.toLowerCase().contains(textEditingValue.text.toLowerCase());
            });
          },

          displayStringForOption: (med) => med.nombre,

          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                child: Container(
                  width: 300,
                  color: Colors.white,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options.elementAt(index);
                      return ListTile(
                        title: Text(option.nombre),
                        onTap: () => onSelected(option),
                      );
                    },
                  ),
                ),
              ),
            );
          },

          fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
            return TextFormField(
              maxLines: maxLines,
              keyboardType: keyboardType,
              validator: validator,
              decoration: InputDecoration(
                labelText: label,
                hintText: hint,
                prefixIcon: Icon(AppTheme.medicationIcon, color: const Color(0xFF2563EB), size: 20),
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
          },
        );
      },
    );
  }
}
