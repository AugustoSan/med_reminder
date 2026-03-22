enum Frecuencia {
  diaria,
  semanal,
  mensual,
  cadaXdias,
  
}

class MedicationSchedule {
  final int? id;
  final int medicationId;
  final String hora; // Ejemplo: "08:00"
  final String dias; // Ejemplo: '[1,2,3,4,5]' (1=lun … 7=dom)
  final String frecuencia; // Ejemplo: "diaria", "semanal", "mensual", "cada X días"
  final int? intervaloHoras; // Solo para "cada X días"

  MedicationSchedule({
    this.id,
    required this.medicationId,
    required this.hora,
    required this.dias,
    required this.frecuencia,
    this.intervaloHoras,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'medicationId': medicationId,
      'hora': hora,
      'dias': dias,
      'frecuencia': frecuencia,
      'intervaloHoras': intervaloHoras,
    };
  }

  factory MedicationSchedule.fromMap(Map<String, dynamic> map) {
    return MedicationSchedule(
      id: map['id'],
      medicationId: map['medicationId'],
      hora: map['hora'],
      dias: map['dias'],
      frecuencia: map['frecuencia'],
      intervaloHoras: map['intervaloHoras'],
    );
  }
}