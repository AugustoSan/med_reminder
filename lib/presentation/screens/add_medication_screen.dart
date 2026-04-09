import 'package:flutter/material.dart';
// import 'package:med_reminder/database/dao/daos.dart';
// import 'package:med_reminder/database/dao/schedule_dao.dart';
import 'package:med_reminder/data/models/models.dart';
import 'package:med_reminder/core/utils/medications_utils.dart';

import '../widgets/widgets.dart';

class AddMedicationScreen extends StatefulWidget {
  final MedicationModel? medicamentosExistentes;
  const AddMedicationScreen({super.key, this.medicamentosExistentes});

  @override
  State<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores
  final _nombreCtrl = TextEditingController();
  final _dosisCtrl = TextEditingController();
  final _instruccionesCtrl = TextEditingController();
  final _diasDuracionCtrl = TextEditingController();

  TimeOfDay _horaSeleccionada = TimeOfDay.now();
  String _frecuencia = Frecuencia.diaria.toString();
  int _colorSeleccionado = 0;
  int _iconoSeleccionado = 0;

  int _intervaloHoras = 8;

  final List<bool> _diasSemana = List.filled(7, false);
  final List<String> _nombresDias = [
    'L', 'M', 'X', 'J', 'V', 'S', 'D'
  ];

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

  // List<DoseHistory> _history = [];

  @override
void initState() {
  super.initState();

  // Si viene medicamento existente, precarga los campos
  final med = widget.medicamentosExistentes;
  if (med != null) {
    _nombreCtrl.text = med.nombre;
    _colorSeleccionado = int.tryParse(med.color) ?? 0;
    _iconoSeleccionado = int.tryParse(med.icono) ?? 0;
  }
}

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _dosisCtrl.dispose();
    _instruccionesCtrl.dispose();
    _diasDuracionCtrl.dispose();
    super.dispose();
  }

  Widget _buildSeccion(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        titulo,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Color(0xFF8A99B0),
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF2563EB), size: 20),
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
  }

  Widget _buildSelectorColor() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Color del medicamento',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF8A99B0),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_colores.length, (index) {
              final seleccionado = _colorSeleccionado == index;
              return GestureDetector(
                onTap: () => setState(
                    () => _colorSeleccionado = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: seleccionado ? 40 : 34,
                  height: seleccionado ? 40 : 34,
                  decoration: BoxDecoration(
                    color: _colores[index],
                    shape: BoxShape.circle,
                    border: seleccionado
                        ? Border.all(
                            color: _colores[index],
                            width: 3,
                          )
                        : null,
                    boxShadow: seleccionado
                        ? [
                            BoxShadow(
                              color: _colores[index]
                                  .withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            )
                          ]
                        : null,
                  ),
                  child: seleccionado
                      ? const Icon(Icons.check,
                          color: Colors.white, size: 18)
                      : null,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectorIcono() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ícono del medicamento',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF8A99B0),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_iconos.length, (index) {
              final seleccionado = _iconoSeleccionado == index;
              final color = _colores[_colorSeleccionado];
              return GestureDetector(
                onTap: () => setState(
                    () => _iconoSeleccionado = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: seleccionado
                        ? color.withOpacity(0.12)
                        : const Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.circular(12),
                    border: seleccionado
                        ? Border.all(color: color, width: 2)
                        : Border.all(
                            color: const Color(0xFFE2E8F0)),
                  ),
                  child: Icon(
                    _iconos[index],
                    color: seleccionado
                        ? color
                        : const Color(0xFF8A99B0),
                    size: 24,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectorHora() {
    return GestureDetector(
      onTap: _seleccionarHora,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.access_time_rounded,
                    color: Color(0xFF2563EB), size: 20),
                const SizedBox(width: 12),
                const Text(
                  'Hora de la dosis',
                  style: TextStyle(
                      fontSize: 14, color: Color(0xFF8A99B0)),
                ),
                const Spacer(),
                Text(
                  _horaSeleccionada.format(context),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A2D4F),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right_rounded,
                    color: Color(0xFF8A99B0)),
              ],
            ),
            
            if(_frecuencia == 'cada_x_horas') ...[
              const SizedBox(height: 14,),
              const Divider(height: 1, color: Color(0xFFE2E8F0),),
              const SizedBox(height: 14,),
              const Text(
              'Tomas del día',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF8A99B0),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: MedicationsUtils.calcularHorarios(_horaSeleccionada, _intervaloHoras).map((hora) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: const Color(0xFF2563EB).withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.circle,
                          size: 6, color: Color(0xFF2563EB)),
                      const SizedBox(width: 6),
                      Text(
                        hora,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildSelectorFrecuencia() {
    final opciones = [
      {'valor': 'diario', 'label': 'Diario', 'icon': Icons.today_rounded},
      {'valor': 'semanal', 'label': 'Semanal', 'icon': Icons.date_range_rounded},
      {'valor': 'cada_x_horas', 'label': 'Cada X horas', 'icon': Icons.timelapse_rounded},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Frecuencia',
            style: TextStyle(
                fontSize: 14, color: Color(0xFF8A99B0)),
          ),
          const SizedBox(height: 12),
          Row(
            children: opciones.map((op) {
              final seleccionado = _frecuencia == op['valor'];
              return Expanded(
                child: GestureDetector(
                  onTap: () =>
                      setState(() => _frecuencia = op['valor'] as String),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: seleccionado
                          ? const Color(0xFF2563EB)
                          : const Color(0xFFF5F7FA),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          op['icon'] as IconData,
                          color: seleccionado
                              ? Colors.white
                              : const Color(0xFF8A99B0),
                          size: 20,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          op['label'] as String,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: seleccionado
                                ? Colors.white
                                : const Color(0xFF8A99B0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectorDias() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Días de la semana',
            style: TextStyle(
                fontSize: 14, color: Color(0xFF8A99B0)),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (index) {
              final seleccionado = _diasSemana[index];
              return GestureDetector(
                onTap: () => setState(
                    () => _diasSemana[index] = !_diasSemana[index]),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: seleccionado
                        ? const Color(0xFF2563EB)
                        : const Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      _nombresDias[index],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: seleccionado
                            ? Colors.white
                            : const Color(0xFF8A99B0),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectorIntervaloHoras() {
    final opciones = [4, 6, 8, 12, 24];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cada cuántas horas',
            style: TextStyle(fontSize: 14, color: Color(0xFF8A99B0)),
          ),
          const SizedBox(height: 16),

          // Slider visual
          Row(
            children: [
              const Icon(Icons.timelapse_rounded,
                  color: Color(0xFF2563EB), size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: const Color(0xFF2563EB),
                    inactiveTrackColor: const Color(0xFFE2E8F0),
                    thumbColor: const Color(0xFF2563EB),
                    overlayColor:
                        const Color(0xFF2563EB).withOpacity(0.12),
                    trackHeight: 4,
                  ),
                  child: Slider(
                    value: _intervaloHoras.toDouble(),
                    label: _intervaloHoras.toString(),
                    min: 1,
                    max: 24,
                    divisions: 23,
                    onChanged: (valor) {
                      setState(() => _intervaloHoras = valor.round());
                    },
                  ),
                ),
              ),
              Container(
                width: 56,
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _intervaloHoras == 1
                      ? '1h'
                      : '${_intervaloHoras}h',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Chips de valores rápidos
          Wrap(
            spacing: 8,
            children: opciones.map((horas) {
              final seleccionado = _intervaloHoras == horas;
              return GestureDetector(
                onTap: () =>
                    setState(() => _intervaloHoras = horas),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: seleccionado
                        ? const Color(0xFF2563EB)
                        : const Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: seleccionado
                          ? const Color(0xFF2563EB)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Text(
                    horas == 1 ? '1 hora' : '$horas horas',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: seleccionado
                          ? Colors.white
                          : const Color(0xFF8A99B0),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // Resumen visual de las tomas del día
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded,
                    color: Color(0xFF2563EB), size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _resumenTomas(),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _resumenTomas() {
    final tomasAlDia = (24 / _intervaloHoras).floor();
    if (_intervaloHoras == 24) {
      return 'Una toma al día';
    }
    return '$tomasAlDia tomas al día · cada $_intervaloHoras ${_intervaloHoras == 1 ? 'hora' : 'horas'}';
  }

  Future<void> _seleccionarHora() async {
    final hora = await showTimePicker(
      context: context,
      initialTime: _horaSeleccionada,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2563EB),
            ),
          ),
          child: child!,
        );
      },
    );
    if (hora != null) {
      setState(() => _horaSeleccionada = hora);
    }
  }

  void _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    // final intervalo = _frecuencia == 'cada_x_horas'
    //   ? _intervaloHoras
    //   : null;
    // // Aquí conectas con AlarmService y la BD
    // // Por ahora muestra confirmación

    // final resMed = await MedicationDAO().insertMedication(Medication(nombre: _nombreCtrl.toString().trim()));

    // final res = await ScheduleDao().insertSchedule(
    //   MedicationSchedule(medicationId: resMed, hora: '${_horaSeleccionada.hour}:${_horaSeleccionada.minute}', dias: '[$]', frecuencia: frecuencia, dosis: dosis)
    // );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '${_nombreCtrl.text} guardado correctamente'),
        backgroundColor: const Color(0xFF16A34A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
      ),
    );

    Navigator.pop(context);
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
        title: Text(
          widget.medicamentosExistentes == null
            ? 'Nuevo medicamento'
            : 'Agregar horario',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A2D4F),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ── Nombre y dosis ──────────────────────────
            _buildSeccion('Medicamento'),
            // _buildInput(
            //   controller: _nombreCtrl,
            //   label: 'Nombre del medicamento',
            //   hint: 'Ej: Paracetamol',
            //   icon: Icons.medication_rounded,
            //   validator: (v) =>
            //       v!.isEmpty ? 'Ingresa el nombre' : null,
            // ),
            MedicamentoSearchField(
              label: 'Nombre del medicamento',
                // controller: _nombreCtrl,
                hint: 'Ej: Paracetamol',
                validator: (v) =>
                    v!.isEmpty ? 'Ingresa el nombre' : null,
              ),
            const SizedBox(height: 12),
            _buildInput(
              controller: _dosisCtrl,
              label: 'Dosis',
              hint: 'Ej: 500mg, 1 pastilla',
              icon: Icons.scale_rounded,
              validator: (v) =>
                  v!.isEmpty ? 'Ingresa la dosis' : null,
            ),
            const SizedBox(height: 12),
            _buildInput(
              controller: _instruccionesCtrl,
              label: 'Instrucciones (opcional)',
              hint: 'Ej: Tomar con alimentos',
              icon: Icons.notes_rounded,
              maxLines: 2,
            ),

            const SizedBox(height: 24),

            // ── Color e ícono ───────────────────────────
            _buildSeccion('Personalización'),
            _buildSelectorColor(),
            const SizedBox(height: 12),
            _buildSelectorIcono(),

            const SizedBox(height: 24),

            // ── Horario ─────────────────────────────────
            _buildSelectorFrecuencia(),
            if (_frecuencia == 'semanal') ...[
              const SizedBox(height: 12),
              _buildSelectorDias(),
            ],
            if (_frecuencia == 'cada_x_horas') ...[
              const SizedBox(height: 12),
              _buildSelectorIntervaloHoras(),
            ],
            const SizedBox(height: 24),

            _buildSeccion('Horario'),
            _buildSelectorHora(),
            const SizedBox(height: 12),

            // ── Duración del tratamiento ─────────────────
            _buildSeccion('Duración del tratamiento'),
            _buildInput(
              controller: _diasDuracionCtrl,
              label: '¿Por cuántos días?',
              hint: 'Ej: 7, 14, 30 (vacío = indefinido)',
              icon: Icons.calendar_today_rounded,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 32),

            // ── Botón guardar ────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _guardar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Guardar medicamento',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}