import './../../utils/medications_utils.dart';

class Medication {
  final int? id;
  final String nombre;
  final String? descripcion;
  final String color;
  final String icono;

  Medication({
    this.id,
    required this.nombre,
    this.descripcion,
    this.color = '#4A90D9',
    this.icono = 'pill',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'color': MedicationsUtils.normalizeColor(color),
      'icono': icono,
    };
  }

  // Método específico para inserción (sin ID)
  Map<String, dynamic> toInsertMap() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'color': MedicationsUtils.normalizeColor(color),
      'icono': icono,
    };
  }

  factory Medication.fromMap(Map<String, dynamic> map) {
    return Medication(
      id: map['id'],
      nombre: map['nombre'],
      descripcion: map['descripcion'],
      color: MedicationsUtils.validateColor(map['color'] ?? '#4A90D9'),
      icono: map['icono'] ?? 'pill',
    );
  }

}