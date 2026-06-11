import 'dart:convert';
import 'dart:typed_data';

import 'package:app/app/theme/app_colors.dart';
import 'package:app/features/pets/presentation/bloc/pets_bloc.dart';
import 'package:app/features/pets/presentation/bloc/pets_event.dart';
import 'package:app/features/pets/presentation/bloc/pets_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

Future<void> showAddPetSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => BlocProvider.value(
      value: context.read<PetsBloc>(),
      child: const AddPetSheet(),
    ),
  );
}

class AddPetSheet extends StatefulWidget {
  const AddPetSheet({super.key});

  @override
  State<AddPetSheet> createState() => _AddPetSheetState();
}

class _AddPetSheetState extends State<AddPetSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _picker = ImagePicker();

  String _petType = 'dog';
  String _vaccinationStatus = 'unknown';
  String? _imageDataUrl;
  Uint8List? _previewBytes;

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final file = await _picker.pickImage(
      source: source,
      imageQuality: 72,
      maxWidth: 1200,
    );

    if (file == null) {
      return;
    }

    final bytes = await file.readAsBytes();
    final mime = _mimeTypeFromPath(file.name);

    setState(() {
      _previewBytes = bytes;
      _imageDataUrl = 'data:$mime;base64,${base64Encode(bytes)}';
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<PetsBloc>().add(
          PetCreateSubmitted(
            name: _nameController.text.trim(),
            ageYears: int.parse(_ageController.text.trim()),
            weightKg: double.parse(
              _weightController.text.trim().replaceAll(',', '.'),
            ),
            petType: _petType,
            vaccinationStatus: _vaccinationStatus,
            imageDataUrl: _imageDataUrl,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return BlocConsumer<PetsBloc, PetsState>(
      listenWhen: (previous, current) =>
          previous.interaction != current.interaction ||
          previous.message != current.message,
      listener: (context, state) {
        if (state.interaction == PetsInteraction.petCreated) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message ?? 'Đã thêm thú cưng.')),
          );
          context.read<PetsBloc>().add(const PetsInteractionConsumed());
          return;
        }

        if (!state.isCreatingPet &&
            state.message != null &&
            state.interaction != PetsInteraction.petCreated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message!)),
          );
        }
      },
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.only(bottom: bottomInset),
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 22),
          decoration: const BoxDecoration(
            color: Color(0xFFFFF8EF),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD6DEE2),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _PetImagePicker(
                    previewBytes: _previewBytes,
                    onCameraPressed: () => _pickImage(ImageSource.camera),
                    onGalleryPressed: () => _pickImage(ImageSource.gallery),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Chọn loại thú cưng',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF5F3318),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _PetTypeSelector(
                    selectedType: _petType,
                    onChanged: (type) {
                      setState(() {
                        _petType = type;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  _PetTextField(
                    controller: _nameController,
                    label: 'Tên thú cưng',
                    hint: 'Nhập tên bé...',
                    suffixIcon: Icons.badge_outlined,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nhập tên thú cưng.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _PetTextField(
                          controller: _ageController,
                          label: 'Tuổi',
                          hint: 'Ví dụ: 2',
                          suffixText: 'năm',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            final age = int.tryParse(value?.trim() ?? '');
                            if (age == null || age < 0) {
                              return 'Tuổi không hợp lệ.';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _PetTextField(
                          controller: _weightController,
                          label: 'Cân nặng',
                          hint: 'Ví dụ: 5.5',
                          suffixText: 'kg',
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: (value) {
                            final weight = double.tryParse(
                              (value ?? '').trim().replaceAll(',', '.'),
                            );
                            if (weight == null || weight <= 0) {
                              return 'Kg không hợp lệ.';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _vaccinationStatus,
                    decoration: _inputDecoration(label: 'Số mũi vaccine'),
                    items: const [
                      DropdownMenuItem(
                        value: 'vaccinated',
                        child: Text('Đã tiêm đủ'),
                      ),
                      DropdownMenuItem(
                        value: 'not_vaccinated',
                        child: Text('Chưa tiêm'),
                      ),
                      DropdownMenuItem(
                        value: 'needs_booster',
                        child: Text('Cần tiêm nhắc'),
                      ),
                      DropdownMenuItem(
                        value: 'unknown',
                        child: Text('Chưa rõ'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _vaccinationStatus = value ?? 'unknown';
                      });
                    },
                  ),
                  const SizedBox(height: 18),
                  FilledButton(
                    onPressed: state.isCreatingPet ? null : _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFAD5400),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 17),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 5,
                      shadowColor:
                          const Color(0xFFAD5400).withValues(alpha: 0.28),
                    ),
                    child: state.isCreatingPet
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Xác nhận',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                  ),
                  const SizedBox(height: 14),
                  TextButton(
                    onPressed: state.isCreatingPet
                        ? null
                        : () => Navigator.of(context).pop(),
                    child: const Text(
                      'Hủy bỏ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF7A5A42),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PetImagePicker extends StatelessWidget {
  const _PetImagePicker({
    required this.previewBytes,
    required this.onCameraPressed,
    required this.onGalleryPressed,
  });

  final Uint8List? previewBytes;
  final VoidCallback onCameraPressed;
  final VoidCallback onGalleryPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 92,
              height: 92,
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: previewBytes == null
                    ? Container(
                        color: const Color(0xFFFFD9B7),
                        child: Icon(
                          Icons.pets_rounded,
                          size: 40,
                          color: AppColors.brownText.withValues(alpha: 0.5),
                        ),
                      )
                    : Image.memory(previewBytes!, fit: BoxFit.cover),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 4,
              child: Material(
                color: const Color(0xFFAD5400),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onGalleryPressed,
                  child: const SizedBox(
                    width: 28,
                    height: 28,
                    child: Icon(
                      Icons.edit_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _PetPhotoButton(
              label: 'Tải ảnh lên',
              isFilled: true,
              onPressed: onGalleryPressed,
            ),
            const SizedBox(width: 10),
            _PetPhotoButton(
              label: 'Chụp ảnh',
              isFilled: false,
              onPressed: onCameraPressed,
            ),
          ],
        ),
      ],
    );
  }
}

class _PetPhotoButton extends StatelessWidget {
  const _PetPhotoButton({
    required this.label,
    required this.isFilled,
    required this.onPressed,
  });

  final String label;
  final bool isFilled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: isFilled ? const Color(0xFFFF8D43) : Colors.white,
          foregroundColor: isFilled ? Colors.white : const Color(0xFFAD5400),
          side: const BorderSide(color: Color(0xFFFF8D43)),
          padding: const EdgeInsets.symmetric(horizontal: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _PetTypeSelector extends StatelessWidget {
  const _PetTypeSelector({
    required this.selectedType,
    required this.onChanged,
  });

  final String selectedType;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const items = [
      _PetTypeOption(type: 'dog', label: 'Chó', icon: Icons.pets_rounded),
      _PetTypeOption(type: 'cat', label: 'Mèo', icon: Icons.cruelty_free_rounded),
      _PetTypeOption(
        type: 'rabbit',
        label: 'Thỏ',
        icon: Icons.emoji_nature_rounded,
      ),
      _PetTypeOption(type: 'bird', label: 'Chim', icon: Icons.air_rounded),
    ];

    return Row(
      children: items
          .map(
            (item) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: item == items.last ? 0 : 10),
                child: _PetTypeTile(
                  option: item,
                  selected: selectedType == item.type,
                  onTap: () => onChanged(item.type),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _PetTypeOption {
  const _PetTypeOption({
    required this.type,
    required this.label,
    required this.icon,
  });

  final String type;
  final String label;
  final IconData icon;
}

class _PetTypeTile extends StatelessWidget {
  const _PetTypeTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final _PetTypeOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xFFAD5400) : const Color(0xFF6C4A31);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color:
                    selected ? const Color(0xFFAD5400) : const Color(0xFFEED8C4),
                width: selected ? 2 : 1,
              ),
            ),
            child: Icon(option.icon, color: color, size: 24),
          ),
          const SizedBox(height: 7),
          Text(
            option.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: selected ? const Color(0xFFAD5400) : const Color(0xFF6C4A31),
            ),
          ),
        ],
      ),
    );
  }
}

class _PetTextField extends StatelessWidget {
  const _PetTextField({
    required this.controller,
    required this.label,
    this.hint,
    this.suffixText,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? suffixText;
  final IconData? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: _inputDecoration(
        label: label,
        hint: hint,
        suffixText: suffixText,
        suffixIcon: suffixIcon,
      ),
    );
  }
}

InputDecoration _inputDecoration({
  required String label,
  String? hint,
  String? suffixText,
  IconData? suffixIcon,
}) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    suffixText: suffixText,
    suffixIcon: suffixIcon == null ? null : Icon(suffixIcon, size: 18),
    floatingLabelBehavior: FloatingLabelBehavior.always,
    filled: true,
    fillColor: Colors.white,
    labelStyle: const TextStyle(
      color: Color(0xFF5F3318),
      fontSize: 11,
      fontWeight: FontWeight.w700,
    ),
    hintStyle: const TextStyle(
      color: Color(0xFFB8A99B),
      fontSize: 13,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFFEED8C4)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFFEED8C4)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFFAD5400), width: 1.4),
    ),
  );
}

String _mimeTypeFromPath(String path) {
  final lower = path.toLowerCase();
  if (lower.endsWith('.png')) {
    return 'image/png';
  }
  if (lower.endsWith('.webp')) {
    return 'image/webp';
  }
  return 'image/jpeg';
}
