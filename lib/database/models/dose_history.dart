enum DoseEstado {
  tomada,
  saltada,
  perdida,
}

class DoseHistory{
  final int? id;
  final int scheduleId;
  final String fecha;
  final String estado;

  DoseHistory({
    required this.id,
    required this.scheduleId,
    required this.fecha,
    required this.estado,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'scheduleId': scheduleId,
      'fecha': fecha,
      'estado': estado,
    };
  }

  factory DoseHistory.fromMap(Map<String, dynamic> map) {
    return DoseHistory(
      id: map['id'],
      scheduleId: map['scheduleId'],
      fecha: map['fecha'],
      estado: map['estado'],
    );
  }
}