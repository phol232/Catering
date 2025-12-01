import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/repositories/event_repository.dart';
import '../bloc/event_bloc.dart';
import '../bloc/event_event.dart';
import '../bloc/event_state.dart';

/// Bottom sheet form for creating and editing events
class EventFormBottomSheet extends StatefulWidget {
  final EventEntity? event; // null for create mode, non-null for edit mode

  const EventFormBottomSheet({super.key, this.event});

  @override
  State<EventFormBottomSheet> createState() => _EventFormBottomSheetState();
}

class _EventFormBottomSheetState extends State<EventFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();

  // Form controllers
  late TextEditingController _nombreController;
  late TextEditingController _tipoController;
  late TextEditingController _invitadosController;
  late TextEditingController _direccionController;
  late TextEditingController _ciudadController;
  late TextEditingController _menuController;
  late TextEditingController _notaController;

  // Form state
  DateTime? _selectedDate;
  TimeOfDay? _horaInicio;
  TimeOfDay? _horaFin;
  File? _selectedImage;
  String? _existingImageUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with existing data if in edit mode
    _nombreController = TextEditingController(
      text: widget.event?.nombreEvento ?? '',
    );
    _tipoController = TextEditingController(
      text: widget.event?.tipoEvento ?? '',
    );
    _invitadosController = TextEditingController(
      text: widget.event?.numInvitados.toString() ?? '',
    );
    _direccionController = TextEditingController(
      text: widget.event?.direccion ?? '',
    );
    _ciudadController = TextEditingController(text: widget.event?.ciudad ?? '');
    _menuController = TextEditingController(
      text: widget.event?.menuId?.toString() ?? '',
    );
    _notaController = TextEditingController(
      text: widget.event?.notaCliente ?? '',
    );

    // Initialize date and time if in edit mode
    _selectedDate = widget.event?.fecha;
    _horaInicio = widget.event?.horaInicio;
    _horaFin = widget.event?.horaFin;
    _existingImageUrl = widget.event?.imageUrl;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _tipoController.dispose();
    _invitadosController.dispose();
    _direccionController.dispose();
    _ciudadController.dispose();
    _menuController.dispose();
    _notaController.dispose();
    super.dispose();
  }

  bool get _isEditMode => widget.event != null;

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventBloc, EventState>(
      listener: (context, state) {
        if (state is EventOperationSuccess) {
          setState(() => _isLoading = false);
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.success,
              duration: const Duration(seconds: 1),
            ),
          );
          // Close bottom sheet
          Navigator.of(context).pop();
          // Reload events
          context.read<EventBloc>().add(LoadAllEvents());
        } else if (state is EventError) {
          setState(() => _isLoading = false);
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              duration: const Duration(seconds: 1),
            ),
          );
        } else if (state is ImageUploaded) {
          // Image uploaded successfully, now create/update the event
          _submitForm(imageUrl: state.imageUrl);
        }
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: AppColors.grayDark,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grayLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _isEditMode ? 'Editar Evento' : 'Crear Evento',
                        style: const TextStyle(
                          color: AppColors.whiteAlmost,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.grayLight,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: AppColors.grayLight, height: 1),
                // Form content
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.all(16),
                      children: [
                        _buildImageSelector(),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _nombreController,
                          label: 'Nombre del Evento',
                          hint: 'Ej: Boda de María y Juan',
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'El nombre del evento es requerido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _tipoController,
                          label: 'Tipo de Evento',
                          hint: 'Ej: Boda, Cumpleaños, Corporativo',
                        ),
                        const SizedBox(height: 16),
                        _buildDatePicker(),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(child: _buildTimePicker(isStart: true)),
                            const SizedBox(width: 16),
                            Expanded(child: _buildTimePicker(isStart: false)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _invitadosController,
                          label: 'Número de Invitados',
                          hint: 'Ej: 100',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'El número de invitados es requerido';
                            }
                            final num = int.tryParse(value);
                            if (num == null || num < 1) {
                              return 'Debe haber al menos 1 invitado';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _direccionController,
                          label: 'Dirección',
                          hint: 'Ej: Calle Principal 123',
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _ciudadController,
                          label: 'Ciudad',
                          hint: 'Ej: Bogotá',
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _menuController,
                          label: 'ID del Menú (opcional)',
                          hint: 'Ej: 1',
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _notaController,
                          label: 'Nota del Cliente',
                          hint: 'Notas adicionales...',
                          maxLines: 3,
                        ),
                        const SizedBox(height: 24),
                        _buildSubmitButton(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Imagen del Evento',
          style: TextStyle(
            color: AppColors.whiteAlmost,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.grayLight, width: 1),
            ),
            child: _selectedImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(_selectedImage!, fit: BoxFit.cover),
                  )
                : _existingImageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      _existingImageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildImagePlaceholder();
                      },
                    ),
                  )
                : _buildImagePlaceholder(),
          ),
        ),
      ],
    );
  }

  Widget _buildImagePlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.add_photo_alternate, color: AppColors.grayLight, size: 48),
        SizedBox(height: 8),
        Text(
          'Toca para seleccionar imagen',
          style: TextStyle(color: AppColors.grayLight, fontSize: 14),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.whiteAlmost,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: const TextStyle(color: AppColors.whiteAlmost),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.grayLight),
            filled: true,
            fillColor: AppColors.black,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.grayLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.grayLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.yellowPastel),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.error),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fecha del Evento',
          style: TextStyle(
            color: AppColors.whiteAlmost,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: _selectedDate ?? DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
              builder: (context, child) {
                return Theme(
                  data: ThemeData.dark().copyWith(
                    colorScheme: const ColorScheme.dark(
                      primary: AppColors.yellowPastel,
                      onPrimary: AppColors.black,
                      surface: AppColors.grayDark,
                      onSurface: AppColors.whiteAlmost,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (date != null) {
              setState(() => _selectedDate = date);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _selectedDate == null
                    ? AppColors.error
                    : AppColors.grayLight,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDate != null
                      ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                      : 'Seleccionar fecha',
                  style: TextStyle(
                    color: _selectedDate != null
                        ? AppColors.whiteAlmost
                        : AppColors.grayLight,
                    fontSize: 16,
                  ),
                ),
                const Icon(Icons.calendar_today, color: AppColors.grayLight),
              ],
            ),
          ),
        ),
        if (_selectedDate == null)
          const Padding(
            padding: EdgeInsets.only(top: 8, left: 12),
            child: Text(
              'La fecha es requerida',
              style: TextStyle(color: AppColors.error, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildTimePicker({required bool isStart}) {
    final time = isStart ? _horaInicio : _horaFin;
    final label = isStart ? 'Hora Inicio' : 'Hora Fin';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.whiteAlmost,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final pickedTime = await showTimePicker(
              context: context,
              initialTime: time ?? TimeOfDay.now(),
              builder: (context, child) {
                return Theme(
                  data: ThemeData.dark().copyWith(
                    colorScheme: const ColorScheme.dark(
                      primary: AppColors.yellowPastel,
                      onPrimary: AppColors.black,
                      surface: AppColors.grayDark,
                      onSurface: AppColors.whiteAlmost,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (pickedTime != null) {
              setState(() {
                if (isStart) {
                  _horaInicio = pickedTime;
                } else {
                  _horaFin = pickedTime;
                }
              });
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.grayLight),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time != null
                      ? '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
                      : '--:--',
                  style: TextStyle(
                    color: time != null
                        ? AppColors.whiteAlmost
                        : AppColors.grayLight,
                    fontSize: 16,
                  ),
                ),
                const Icon(
                  Icons.access_time,
                  color: AppColors.grayLight,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    final hasRequiredFields =
        _nombreController.text.isNotEmpty &&
        _selectedDate != null &&
        _invitadosController.text.isNotEmpty;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: (hasRequiredFields && !_isLoading)
            ? () => _handleSubmit()
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.yellowPastel,
          foregroundColor: AppColors.black,
          disabledBackgroundColor: AppColors.grayLight,
          disabledForegroundColor: AppColors.grayDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.black),
                ),
              )
            : Text(
                _isEditMode ? 'Actualizar Evento' : 'Crear Evento',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor selecciona una fecha'),
            backgroundColor: AppColors.error,
            duration: Duration(seconds: 1),
          ),
        );
        return;
      }

      setState(() => _isLoading = true);

      // If a new image was selected, upload it first
      if (_selectedImage != null) {
        context.read<EventBloc>().add(UploadImageRequested(_selectedImage!));
      } else {
        // No new image, submit form with existing image URL
        _submitForm(imageUrl: _existingImageUrl);
      }
    }
  }

  void _submitForm({String? imageUrl}) {
    final invitados = int.parse(_invitadosController.text);
    final menuId = _menuController.text.isNotEmpty
        ? int.tryParse(_menuController.text)
        : null;

    // Format time as HH:mm string
    String? formatTime(TimeOfDay? time) {
      if (time == null) return null;
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }

    if (_isEditMode) {
      // Update existing event
      final params = UpdateEventParams(
        id: widget.event!.id,
        nombreEvento: _nombreController.text.trim(),
        tipoEvento: _tipoController.text.trim().isNotEmpty
            ? _tipoController.text.trim()
            : null,
        fecha: _selectedDate,
        horaInicio: formatTime(_horaInicio),
        horaFin: formatTime(_horaFin),
        numInvitados: invitados,
        direccion: _direccionController.text.trim().isNotEmpty
            ? _direccionController.text.trim()
            : null,
        ciudad: _ciudadController.text.trim().isNotEmpty
            ? _ciudadController.text.trim()
            : null,
        menuId: menuId,
        notaCliente: _notaController.text.trim().isNotEmpty
            ? _notaController.text.trim()
            : null,
        imageUrl: imageUrl,
      );
      context.read<EventBloc>().add(UpdateEventRequested(params));
    } else {
      // Create new event
      // TODO: Get actual clienteId from auth state
      final params = CreateEventParams(
        clienteId: 1, // Placeholder - should come from authenticated user
        nombreEvento: _nombreController.text.trim(),
        tipoEvento: _tipoController.text.trim().isNotEmpty
            ? _tipoController.text.trim()
            : null,
        fecha: _selectedDate!,
        horaInicio: formatTime(_horaInicio),
        horaFin: formatTime(_horaFin),
        numInvitados: invitados,
        direccion: _direccionController.text.trim().isNotEmpty
            ? _direccionController.text.trim()
            : null,
        ciudad: _ciudadController.text.trim().isNotEmpty
            ? _ciudadController.text.trim()
            : null,
        menuId: menuId,
        notaCliente: _notaController.text.trim().isNotEmpty
            ? _notaController.text.trim()
            : null,
        imageUrl: imageUrl,
      );
      context.read<EventBloc>().add(CreateEventRequested(params));
    }
  }
}
