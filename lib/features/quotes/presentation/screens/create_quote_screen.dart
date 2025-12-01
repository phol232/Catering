import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/quote_request_entity.dart';
import '../bloc/quote_bloc.dart';
import '../bloc/quote_event.dart';
import '../bloc/quote_state.dart';

class CreateQuoteScreen extends StatefulWidget {
  const CreateQuoteScreen({super.key});

  @override
  State<CreateQuoteScreen> createState() => _CreateQuoteScreenState();
}

class _CreateQuoteScreenState extends State<CreateQuoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreEventoController = TextEditingController();
  final _numInvitadosController = TextEditingController();
  final _direccionController = TextEditingController();
  final _ciudadController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _presupuestoController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _emailController = TextEditingController();
  final _detallesRestriccionesController = TextEditingController();
  final _otrosServiciosController = TextEditingController();

  String _tipoEvento = 'Boda';
  DateTime? _fechaEvento;
  TimeOfDay? _horaInicio;
  TimeOfDay? _horaFin;
  bool _tieneRestricciones = false;
  bool _necesitaMeseros = false;
  bool _necesitaMontaje = false;
  bool _necesitaDecoracion = false;
  bool _necesitaSonido = false;

  final List<String> _tiposEvento = [
    'Boda',
    'XV Años',
    'Cumpleaños',
    'Corporativo',
    'Graduación',
    'Otro',
  ];

  @override
  void dispose() {
    _nombreEventoController.dispose();
    _numInvitadosController.dispose();
    _direccionController.dispose();
    _ciudadController.dispose();
    _descripcionController.dispose();
    _presupuestoController.dispose();
    _telefonoController.dispose();
    _emailController.dispose();
    _detallesRestriccionesController.dispose();
    _otrosServiciosController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Solicitar Cotización')),
      body: BlocListener<QuoteBloc, QuoteState>(
        listener: (context, state) {
          if (state is QuoteCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Cotización enviada exitosamente'),
                backgroundColor: Colors.green,
              ),
            );
            // Recargar las cotizaciones del cliente
            final authState = context.read<AuthBloc>().state;
            if (authState is AuthAuthenticated) {
              context.read<QuoteBloc>().add(
                LoadQuotesByClientEvent(authState.user.id),
              );
            }
            Navigator.pop(context, true); // Retornar true para indicar éxito
          } else if (state is QuoteError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<QuoteBloc, QuoteState>(
          builder: (context, state) {
            if (state is QuoteLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildSectionTitle('Información del Evento'),
                  _buildTextField(
                    controller: _nombreEventoController,
                    label: 'Nombre del Evento',
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildDropdown(),
                  const SizedBox(height: 16),
                  _buildDatePicker(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildTimePicker(true)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildTimePicker(false)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _numInvitadosController,
                    label: 'Número de Invitados',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.isEmpty ?? true) return 'Campo requerido';
                      if (int.tryParse(value!) == null) {
                        return 'Ingresa un número válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Ubicación'),
                  _buildTextField(
                    controller: _direccionController,
                    label: 'Dirección',
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _ciudadController,
                    label: 'Ciudad',
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Detalles del Servicio'),
                  _buildTextField(
                    controller: _descripcionController,
                    label: 'Descripción del Evento',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _presupuestoController,
                    label: 'Presupuesto Aproximado',
                    keyboardType: TextInputType.number,
                    prefix: '\$',
                    validator: (value) {
                      if (value != null &&
                          value.isNotEmpty &&
                          double.tryParse(value) == null) {
                        return 'Ingresa un número válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Restricciones Alimentarias'),
                  CheckboxListTile(
                    title: const Text('¿Hay restricciones alimentarias?'),
                    value: _tieneRestricciones,
                    onChanged: (value) {
                      setState(() => _tieneRestricciones = value ?? false);
                    },
                  ),
                  if (_tieneRestricciones)
                    _buildTextField(
                      controller: _detallesRestriccionesController,
                      label: 'Detalles de Restricciones',
                      maxLines: 2,
                    ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Servicios Adicionales'),
                  CheckboxListTile(
                    title: const Text('Meseros'),
                    value: _necesitaMeseros,
                    onChanged: (value) {
                      setState(() => _necesitaMeseros = value ?? false);
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Montaje'),
                    value: _necesitaMontaje,
                    onChanged: (value) {
                      setState(() => _necesitaMontaje = value ?? false);
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Decoración'),
                    value: _necesitaDecoracion,
                    onChanged: (value) {
                      setState(() => _necesitaDecoracion = value ?? false);
                    },
                  ),
                  CheckboxListTile(
                    title: const Text('Sonido'),
                    value: _necesitaSonido,
                    onChanged: (value) {
                      setState(() => _necesitaSonido = value ?? false);
                    },
                  ),
                  _buildTextField(
                    controller: _otrosServiciosController,
                    label: 'Otros Servicios',
                    maxLines: 2,
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Información de Contacto'),
                  _buildTextField(
                    controller: _telefonoController,
                    label: 'Teléfono',
                    keyboardType: TextInputType.phone,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Campo requerido' : null,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Enviar Solicitud'),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? prefix,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixText: prefix,
        border: const OutlineInputBorder(),
      ),
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _tipoEvento,
      decoration: const InputDecoration(
        labelText: 'Tipo de Evento',
        border: OutlineInputBorder(),
      ),
      items: _tiposEvento.map((tipo) {
        return DropdownMenuItem(value: tipo, child: Text(tipo));
      }).toList(),
      onChanged: (value) {
        setState(() => _tipoEvento = value!);
      },
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 730)),
        );
        if (date != null) {
          setState(() => _fechaEvento = date);
        }
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Fecha del Evento',
          border: OutlineInputBorder(),
        ),
        child: Text(
          _fechaEvento != null
              ? DateFormat('dd/MM/yyyy').format(_fechaEvento!)
              : 'Seleccionar fecha',
        ),
      ),
    );
  }

  Widget _buildTimePicker(bool isStart) {
    final time = isStart ? _horaInicio : _horaFin;
    return InkWell(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (picked != null) {
          setState(() {
            if (isStart) {
              _horaInicio = picked;
            } else {
              _horaFin = picked;
            }
          });
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: isStart ? 'Hora Inicio' : 'Hora Fin',
          border: const OutlineInputBorder(),
        ),
        child: Text(time != null ? time.format(context) : 'Seleccionar'),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_fechaEvento == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selecciona la fecha del evento')),
        );
        return;
      }

      final authState = context.read<AuthBloc>().state;
      if (authState is! AuthAuthenticated) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Debes iniciar sesión')));
        return;
      }

      final quote = QuoteRequestEntity(
        clienteId: authState.user.id,
        nombreEvento: _nombreEventoController.text,
        tipoEvento: _tipoEvento,
        fechaEvento: _fechaEvento!,
        horaInicio: _horaInicio?.format(context),
        horaFin: _horaFin?.format(context),
        numInvitados: int.tryParse(_numInvitadosController.text) ?? 0,
        direccion: _direccionController.text,
        ciudad: _ciudadController.text,
        descripcion: _descripcionController.text.isEmpty
            ? null
            : _descripcionController.text,
        presupuestoAproximado: _presupuestoController.text.isEmpty
            ? null
            : double.tryParse(_presupuestoController.text),
        tieneRestricciones: _tieneRestricciones,
        detallesRestricciones: _tieneRestricciones
            ? _detallesRestriccionesController.text
            : null,
        necesitaMeseros: _necesitaMeseros,
        necesitaMontaje: _necesitaMontaje,
        necesitaDecoracion: _necesitaDecoracion,
        necesitaSonido: _necesitaSonido,
        otrosServicios: _otrosServiciosController.text.isEmpty
            ? null
            : _otrosServiciosController.text,
        telefonoContacto: _telefonoController.text,
        emailContacto: _emailController.text,
      );

      context.read<QuoteBloc>().add(CreateQuoteRequestEvent(quote));
    }
  }
}
