import 'package:flutter/material.dart';
import 'package:med_reminder/database/dao/medication_dao.dart';
import 'package:med_reminder/database/models/medication.dart';
import 'add_medication_screen.dart';

class SelectMedicationScreen extends StatefulWidget {
  const SelectMedicationScreen({super.key});

  @override
  State<SelectMedicationScreen> createState() =>
      _SelectMedicationScreenState();
}

class _SelectMedicationScreenState
    extends State<SelectMedicationScreen> {
  final MedicationDAO _dao = MedicationDAO();
  List<Medication> _medicamentos = [];
  bool _cargando = true;

  // Colores e iconos igual que en AddMedicationScreen
  final List<Color> _colores = [
    const Color(0xFF2563EB),
    const Color(0xFF16A34A),
    const Color(0xFFDC2626),
    const Color(0xFFEA580C),
    const Color(0xFF7C3AED),
    const Color(0xFF0891B2),
  ];

  final List<IconData> _iconos = [
    Icons.medication_rounded,
    Icons.vaccines_rounded,
    Icons.local_hospital_rounded,
    Icons.favorite_rounded,
    Icons.science_rounded,
    Icons.healing_rounded,
  ];

  @override
  void initState() {
    super.initState();
    _cargarMedicamentos();
  }

  Future<void> _cargarMedicamentos() async {
    final lista = await _dao.getActiveMedications();
    setState(() {
      _medicamentos = lista;
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: Color(0xFF1A2D4F)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Agregar recordatorio',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A2D4F),
          ),
        ),
      ),
      body: _cargando
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF2563EB),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Botón nuevo medicamento
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const AddMedicationScreen(),
                        ),
                      );
                      _cargarMedicamentos(); // refresca al volver
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.add_circle_outline_rounded,
                              color: Colors.white, size: 24),
                          SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nuevo medicamento',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  'Registrar medicamento y horario',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right_rounded,
                              color: Colors.white70),
                        ],
                      ),
                    ),
                  ),
                ),

                // Encabezado lista existente
                if (_medicamentos.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16, vertical: 4),
                    child: Text(
                      'MEDICAMENTOS GUARDADOS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF8A99B0),
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      itemCount: _medicamentos.length,
                      itemBuilder: (context, index) {
                        return _buildMedicamentoItem(
                            _medicamentos[index]);
                      },
                    ),
                  ),
                ],

                // Estado vacío
                if (_medicamentos.isEmpty)
                  Expanded(child: _buildEstadoVacio()),
              ],
            ),
    );
  }

  Widget _buildMedicamentoItem(Medication med) {
    // Parsea el índice de color e icono guardado en la BD
    final colorIndex = int.tryParse(med.color) ??
        _colores.indexWhere(
            (c) => c.value.toRadixString(16) == med.color) ;
    final iconIndex = int.tryParse(med.icono) ?? 0;

    final color = (colorIndex >= 0 && colorIndex < _colores.length)
        ? _colores[colorIndex]
        : _colores[0];

    final icono = (iconIndex >= 0 && iconIndex < _iconos.length)
        ? _iconos[iconIndex]
        : _iconos[0];

    return GestureDetector(
      onTap: () {
        // Devuelve el medicamento seleccionado a la pantalla anterior
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddMedicationScreen(
              medicamentosExistentes: med,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Ícono del medicamento
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icono, color: color, size: 24),
            ),
            const SizedBox(width: 14),

            // Nombre y dosis
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    med.nombre,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A2D4F),
                    ),
                  ),
                  const SizedBox(height: 3),
                ],
              ),
            ),

            // Flecha
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.10),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.chevron_right_rounded,
                color: color,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEstadoVacio() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F0FE),
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.medication_rounded,
              size: 40,
              color: Color(0xFF2563EB),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Sin medicamentos guardados',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A2D4F),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Agrega tu primer medicamento\ncon el botón de arriba',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF8A99B0),
            ),
          ),
        ],
      ),
    );
  }
}