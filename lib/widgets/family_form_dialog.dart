import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../core/utils/image_picker_helper.dart';
import '../models/family_member.dart';
import '../services/api_service.dart';
import '../services/family_service.dart';

class FamilyFormDialog extends StatefulWidget {
  final FamilyMember? member;

  const FamilyFormDialog({super.key, this.member});

  @override
  State<FamilyFormDialog> createState() => _FamilyFormDialogState();
}

class _FamilyFormDialogState extends State<FamilyFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nomController;
  late final TextEditingController _postnomController;
  late final TextEditingController _prenomController;
  late final TextEditingController _lieuController;
  late final TextEditingController _dateController;
  late final TextEditingController _parenteController;

  PickedFileData? _pickedFile;
  bool _isLoading = false;
  String? _errorMessage;

  bool get _isEditing => widget.member != null;

  static const List<String> _parenteSuggestions = [
    'Père',
    'Mère',
    'Frère',
    'Sœur',
    'Fils',
    'Fille',
    'Oncle',
    'Tante',
    'Cousin',
    'Cousine',
    'Grand-père',
    'Grand-mère',
  ];

  @override
  void initState() {
    super.initState();
    final m = widget.member;
    _nomController = TextEditingController(text: m?.nom ?? '');
    _postnomController = TextEditingController(text: m?.postnom ?? '');
    _prenomController = TextEditingController(text: m?.prenom ?? '');
    _lieuController = TextEditingController(text: m?.lieuNaissance ?? '');
    _dateController = TextEditingController(text: m?.dateNaissance ?? '');
    _parenteController = TextEditingController(text: m?.parente ?? '');
  }

  @override
  void dispose() {
    _nomController.dispose();
    _postnomController.dispose();
    _prenomController.dispose();
    _lieuController.dispose();
    _dateController.dispose();
    _parenteController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final file = await pickImageFile();
      if (file != null) {
        // Vérification taille (max 2 Mo = 2 * 1024 * 1024 octets)
        if (file.bytes.length > 2 * 1024 * 1024) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('L’image ne doit pas dépasser 2 Mo.'),
              backgroundColor: AppTheme.burntOrange,
            ),
          );
          return;
        }

        setState(() {
          _pickedFile = file;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Impossible de sélectionner l’image : $e'),
          backgroundColor: AppTheme.burntOrange,
        ),
      );
    }
  }

  Future<void> _selectDate() async {
    DateTime initialDate = DateTime.now().subtract(const Duration(days: 365 * 20));
    if (_dateController.text.isNotEmpty) {
      try {
        final parsed = DateTime.parse(_dateController.text);
        if (parsed.isBefore(DateTime.now())) {
          initialDate = parsed;
        }
      } catch (_) {}
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.copper,
              onPrimary: AppTheme.obsidian,
              surface: Color(0xFF222222),
              onSurface: AppTheme.sand,
            ),
            dialogBackgroundColor: const Color(0xFF1E1E1E),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formatted =
          '${picked.year.toString().padLeft(4, '0')}-'
          '${picked.month.toString().padLeft(2, '0')}-'
          '${picked.day.toString().padLeft(2, '0')}';
      setState(() {
        _dateController.text = formatted;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (_isEditing) {
        await FamilyService.updateMember(
          id: widget.member!.id,
          nom: _nomController.text,
          postnom: _postnomController.text,
          prenom: _prenomController.text,
          lieuNaissance: _lieuController.text,
          dateNaissance: _dateController.text,
          parente: _parenteController.text,
          newImageBytes: _pickedFile?.bytes,
          newImageName: _pickedFile?.name,
        );
      } else {
        await FamilyService.createMember(
          nom: _nomController.text,
          postnom: _postnomController.text,
          prenom: _prenomController.text,
          lieuNaissance: _lieuController.text,
          dateNaissance: _dateController.text,
          parente: _parenteController.text,
          imageBytes: _pickedFile?.bytes,
          imageName: _pickedFile?.name,
        );
      }

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Erreur inattendue : $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1F1F1F),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFF38312B)),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 720),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isEditing ? 'Modifier le membre' : 'Ajouter un membre',
                    style: const TextStyle(
                      color: AppTheme.sand,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppTheme.warmGrey),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.burntOrange.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppTheme.burntOrange.withOpacity(0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline,
                          color: AppTheme.burntOrange, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: AppTheme.sand,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Formulaire scrollable
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Zone d'aperçu & sélection image
                        Center(
                          child: Column(
                            children: [
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  CircleAvatar(
                                    radius: 46,
                                    backgroundColor: const Color(0xFF2C2A28),
                                    backgroundImage: _pickedFile != null
                                        ? MemoryImage(
                                            Uint8List.fromList(_pickedFile!.bytes),
                                          )
                                        : (widget.member?.imageUrl != null
                                            ? NetworkImage(
                                                widget.member!.imageUrl!,
                                              ) as ImageProvider
                                            : null),
                                    child: (_pickedFile == null &&
                                            widget.member?.imageUrl == null)
                                        ? const Icon(
                                            Icons.person,
                                            size: 46,
                                            color: AppTheme.copper,
                                          )
                                        : null,
                                  ),
                                  InkWell(
                                    onTap: _pickImage,
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: const BoxDecoration(
                                        color: AppTheme.copper,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt,
                                        size: 16,
                                        color: AppTheme.obsidian,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              TextButton.icon(
                                onPressed: _pickImage,
                                icon: const Icon(
                                  Icons.image,
                                  size: 18,
                                  color: AppTheme.copper,
                                ),
                                label: Text(
                                  _pickedFile != null
                                      ? 'Photo : ${_pickedFile!.name}'
                                      : (_isEditing && widget.member?.imageUrl != null
                                          ? 'Changer la photo'
                                          : 'Ajouter une photo (optionnel)'),
                                  style: const TextStyle(
                                    color: AppTheme.copper,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Nom
                        _buildLabel('Nom *'),
                        TextFormField(
                          controller: _nomController,
                          maxLength: 50,
                          decoration: const InputDecoration(
                            hintText: 'Ex: Baraka',
                            counterText: '',
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Le nom est obligatoire'
                              : null,
                        ),
                        const SizedBox(height: 14),

                        // Postnom
                        _buildLabel('Postnom *'),
                        TextFormField(
                          controller: _postnomController,
                          maxLength: 50,
                          decoration: const InputDecoration(
                            hintText: 'Ex: Bigega',
                            counterText: '',
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Le postnom est obligatoire'
                              : null,
                        ),
                        const SizedBox(height: 14),

                        // Prénom
                        _buildLabel('Prénom *'),
                        TextFormField(
                          controller: _prenomController,
                          maxLength: 50,
                          decoration: const InputDecoration(
                            hintText: 'Ex: Papa',
                            counterText: '',
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Le prénom est obligatoire'
                              : null,
                        ),
                        const SizedBox(height: 14),

                        // Parenté
                        _buildLabel('Lien de parenté *'),
                        Autocomplete<String>(
                          initialValue:
                              TextEditingValue(text: _parenteController.text),
                          optionsBuilder: (textEditingValue) {
                            if (textEditingValue.text.isEmpty) {
                              return _parenteSuggestions;
                            }
                            return _parenteSuggestions.where((option) {
                              return option.toLowerCase().contains(
                                    textEditingValue.text.toLowerCase(),
                                  );
                            });
                          },
                          onSelected: (selection) {
                            _parenteController.text = selection;
                          },
                          fieldViewBuilder:
                              (context, textController, focusNode, onFieldSubmitted) {
                            // Synchronise avec notre contrôleur principal
                            textController.addListener(() {
                              _parenteController.text = textController.text;
                            });
                            return TextFormField(
                              controller: textController,
                              focusNode: focusNode,
                              maxLength: 50,
                              decoration: const InputDecoration(
                                hintText: 'Ex: Père, Mère, Frère...',
                                counterText: '',
                                suffixIcon: Icon(Icons.arrow_drop_down),
                              ),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'La parenté est obligatoire'
                                  : null,
                            );
                          },
                        ),
                        const SizedBox(height: 14),

                        // Lieu de naissance
                        _buildLabel('Lieu de naissance *'),
                        TextFormField(
                          controller: _lieuController,
                          maxLength: 100,
                          decoration: const InputDecoration(
                            hintText: 'Ex: Goma',
                            counterText: '',
                            prefixIcon: Icon(Icons.location_on_outlined),
                          ),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Le lieu de naissance est obligatoire'
                              : null,
                        ),
                        const SizedBox(height: 14),

                        // Date de naissance
                        _buildLabel('Date de naissance (AAAA-MM-JJ) *'),
                        TextFormField(
                          controller: _dateController,
                          readOnly: true,
                          onTap: _selectDate,
                          decoration: InputDecoration(
                            hintText: 'Sélectionner la date',
                            prefixIcon: const Icon(Icons.calendar_today_outlined),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.event),
                              onPressed: _selectDate,
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'La date de naissance est obligatoire';
                            }
                            final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                            if (!regex.hasMatch(v.trim())) {
                              return 'Format invalide (ex: 1995-08-24)';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Boutons d'action
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isLoading ? null : () => Navigator.of(context).pop(false),
                    child: const Text(
                      'Annuler',
                      style: TextStyle(color: AppTheme.warmGrey),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppTheme.obsidian,
                            ),
                          )
                        : Text(_isEditing ? 'Enregistrer' : 'Créer le membre'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          color: AppTheme.sand,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
