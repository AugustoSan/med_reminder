import 'dart:ui';

import 'package:flutter/material.dart';

class MedicationsUtils {
  // Helper para normalizar el formato del color
  static String normalizeColor(String color) {
    if (color.startsWith('#')) {
      return color.toUpperCase();
    }
    return '#$color'.toUpperCase();
  }
  
  // Helper para validar que el color tenga formato válido
  static String validateColor(String color) {
    final hexRegex = RegExp(r'^#[0-9A-Fa-f]{6}$');
    if (hexRegex.hasMatch(color)) {
      return color.toUpperCase();
    }
    return '#4A90D9'; // Color por defecto si el formato es inválido
  }

  static Color hexToColor(String hexString) {
    // Eliminar el '#' si existe
    final buffer = StringBuffer();
    if (hexString.length == 7 || hexString.length == 9) {
      buffer.write(hexString.replaceFirst('#', ''));
    } else {
      buffer.write(hexString);
    }
    
    // Si tiene 6 dígitos, agregar opacidad FF (100% opaco)
    if (buffer.length == 6) {
      buffer.write('FF');
    }
    
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static String formatearHora(int hora, int minuto) {
    final periodo = hora < 12 ? 'AM' : 'PM';
    final hora12 = hora == 0 ? 12 : (hora > 12 ? hora - 12 : hora);
    final minStr = minuto.toString().padLeft(2, '0');
    return '${hora12.toString().padLeft(2, '0')}:$minStr $periodo';
  }

  static List<String> calcularHorarios(TimeOfDay hora, int intervalo) {
    final List<String> horarios = [];
    int horaActual = hora.hour;
    int minutoActual = hora.minute;

    while (true) {
      final h = horaActual % 24;
      final m = minutoActual;
      horarios.add(
        formatearHora(h, m),
      );

      horaActual += intervalo;

      // Para cuando se completa el ciclo de 24 horas
      if (horaActual >= hora.hour + 24) break;
      // Evita bucles infinitos
      if (horarios.length >= 24) break;
    }

    return horarios;
  }
}