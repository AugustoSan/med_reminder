enum DoseEstado {
  pendiente,
  tomada,
  perdida;

  static DoseEstado fromIndex(int index) {
    if (index >= 0 && index < values.length) {
      return values[index];
    }
    return pendiente;
  }
}

class DoseHistoryModel{
  final int? id;
  final int scheduleId;
  final String fecha;
  final DoseEstado estado;

  DoseHistoryModel({
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
      'estado': estado.index,
    };
  }

  Map<String, dynamic> toInsertMap() {
    return {
      'scheduleId': scheduleId,
      'fecha': fecha,
      'estado': estado.index,
    };
  }

  factory DoseHistoryModel.fromMap(Map<String, dynamic> map) {
    return DoseHistoryModel(
      id: map['id'],
      scheduleId: map['scheduleId'],
      fecha: map['fecha'],
      estado: DoseEstado.fromIndex(map['estado']),
    );
  }
}