// Datos de prueba para insertar en la base de datos
class TestData {
  // Lista de medicamentos de prueba
  static final List<Map<String, dynamic>> testMedications = [
    {
      'nombre': 'Paracetamol',
      'descripcion': 'Analgésico y antipirético',
      'color': '#4A90D9',
      'icono': 'pill',
    },
    {
      'nombre': 'Ibuprofeno',
      'descripcion': 'Antiinflamatorio no esteroideo',
      'color': '#E74C3C',
      'icono': 'tablet',
    },
    {
      'nombre': 'Omeprazol',
      'descripcion': 'Protector gástrico',
      'color': '#2ECC71',
      'icono': 'capsule',
    },
    {
      'nombre': 'Losartán',
      'descripcion': 'Antihipertensivo',
      'color': '#9B59B6',
      'icono': 'pill',
    },
    {
      'nombre': 'Metformina',
      'descripcion': 'Antidiabético',
      'color': '#F39C12',
      'icono': 'tablet',
    },
    {
      'nombre': 'Vitamina C',
      'descripcion': 'Suplemento vitamínico',
      'color': '#1ABC9C',
      'icono': 'pill',
    },
  ];

  // Horarios de prueba (asumiendo que los medicamentos tienen IDs del 1 al 6)
  static final List<Map<String, dynamic>> testSchedules = [
    {
      'medicationId': 1, // Paracetamol
      'hora': '08:00',
      'dias': 'Lunes,Martes,Miércoles,Jueves,Viernes',
      'frecuencia': 1,
      'dosis': '500 mg',
      'intervaloHoras': null,
      'instrucciones': 'Tomar después del desayuno',
    },
    {
      'medicationId': 1, // Paracetamol
      'hora': '20:00',
      'dias': 'Lunes,Martes,Miércoles,Jueves,Viernes',
      'frecuencia': 2,
      'dosis': '500 mg',
      'intervaloHoras': null,
      'instrucciones': 'Tomar después de la cena',
    },
    {
      'medicationId': 2, // Ibuprofeno
      'hora': '12:00',
      'dias': 'Lunes,Martes,Miércoles,Jueves,Viernes,Sábado,Domingo',
      'frecuencia': 1,
      'dosis': '400 mg',
      'intervaloHoras': null,
      'instrucciones': 'Tomar con alimentos',
    },
    {
      'medicationId': 3, // Omeprazol
      'hora': '07:00',
      'dias': 'Lunes,Martes,Miércoles,Jueves,Viernes,Sábado,Domingo',
      'frecuencia': 1,
      'dosis': '20 mg',
      'intervaloHoras': null,
      'instrucciones': 'Tomar en ayunas, 30 minutos antes del desayuno',
    },
    {
      'medicationId': 4, // Losartán
      'hora': '08:30',
      'dias': 'Lunes,Martes,Miércoles,Jueves,Viernes,Sábado,Domingo',
      'frecuencia': 1,
      'dosis': '50 mg',
      'intervaloHoras': null,
      'instrucciones': 'Tomar a la misma hora todos los días',
    },
    {
      'medicationId': 5, // Metformina
      'hora': '08:00',
      'dias': 'Lunes,Martes,Miércoles,Jueves,Viernes,Sábado,Domingo',
      'frecuencia': 2,
      'dosis': '850 mg',
      'intervaloHoras': 12,
      'instrucciones': 'Tomar con las comidas principales',
    },
    {
      'medicationId': 5, // Metformina
      'hora': '20:00',
      'dias': 'Lunes,Martes,Miércoles,Jueves,Viernes,Sábado,Domingo',
      'frecuencia': 2,
      'dosis': '850 mg',
      'intervaloHoras': 12,
      'instrucciones': 'Tomar con las comidas principales',
    },
    {
      'medicationId': 6, // Vitamina C
      'hora': '10:00',
      'dias': 'Lunes,Miércoles,Viernes',
      'frecuencia': 1,
      'dosis': '1000 mg',
      'intervaloHoras': null,
      'instrucciones': 'Tomar con el estómago lleno',
    },
    {
      'medicationId': 6, // Vitamina C
      'hora': '16:00',
      'dias': 'Martes,Jueves,Sábado',
      'frecuencia': 1,
      'dosis': '1000 mg',
      'intervaloHoras': null,
      'instrucciones': 'Tomar con el estómago lleno',
    },
  ];

  // Historial de dosis de prueba (para hoy)
  static List<Map<String, dynamic>> getTestDoseHistory(String today) {
    return [
      {
        'scheduleId': 1,
        'fecha': today,
        'estado': 1, // 1 = tomado
      },
      {
        'scheduleId': 3,
        'fecha': today,
        'estado': 0, // 0 = pendiente
      },
    ];
  }
}