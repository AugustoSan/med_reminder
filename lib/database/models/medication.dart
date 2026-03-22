class Medication {
  final int? id;
  final String nombre;
  final String dosis;
  final String? instrucciones;
  final String color;
  final String icono;
  final int activo;

  Medication({
    this.id,
    required this.nombre,
    required this.dosis,
    this.instrucciones,
    this.color = '#4A90D9',
    this.icono = 'pill',
    this.activo = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'dosis': dosis,
      'instrucciones': instrucciones,
      'color': color,
      'icono': icono,
      'activo': activo,
    };
  }

  factory Medication.fromMap(Map<String, dynamic> map) {
    return Medication(
      id: map['id'],
      nombre: map['nombre'],
      dosis: map['dosis'],
      instrucciones: map['instrucciones'],
      color: map['color'] ?? '#4A90D9',
      icono: map['icono'] ?? 'pill',
      activo: map['activo'] ?? 1,
    );
  }
}