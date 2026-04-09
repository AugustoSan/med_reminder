import 'package:flutter/material.dart';
import 'package:med_reminder/data/models/models.dart';
import 'package:med_reminder/data/services/services.dart';

class MedicationProvider extends ChangeNotifier {
  final MedicationService _medicationService = MedicationService();

  List<MedicationModel> _medicamentos = [];

  List<MedicationModel> get medicamentos => _medicamentos;

  Future<void> cargarMedicamentosActivos() async {
    _medicamentos = await _medicationService.getActiveMedications();
    notifyListeners();
  }

  Future<void> cargarMedicamentos() async {
    _medicamentos = await _medicationService.getAllMedications();
    notifyListeners();
  }

  Future<void> agregarMedicamento(MedicationModel medicamento) async {
    await _medicationService.insertMedication(medicamento);
    await cargarMedicamentos(); // Recarga la lista después de agregar
   }

  Future<void> actualizarMedicamento(MedicationModel medicamento) async {
    if (medicamento.id != null) {
      await _medicationService.updateMedication(medicamento);
      await cargarMedicamentos(); // Recarga la lista después de actualizar
    }
   }

  Future<void> archivarMedicamento(int id) async {
    await _medicationService.archiveMedication(id);
    await cargarMedicamentos(); // Recarga la lista después de archivar
   }

}