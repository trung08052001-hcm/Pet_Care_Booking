import 'dart:convert';
import 'dart:typed_data';

import 'package:app/app/theme/app_colors.dart';
import 'package:app/features/profile/presentation/bloc/profile_edit_bloc.dart';
import 'package:app/features/profile/presentation/bloc/profile_edit_event.dart';
import 'package:app/features/profile/presentation/bloc/profile_edit_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  static const String routeName = 'profile-edit';
  static const String routePath = '/profile/edit';

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _currentPasswordController;
  late final TextEditingController _newPasswordController;
  late final TextEditingController _confirmPasswordController;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _syncControllers(ProfileEditState state) {
    final fullName = state.user?.fullName ?? '';
    if (_nameController.text != fullName) {
      _nameController.value = TextEditingValue(
        text: fullName,
        selection: TextSelection.collapsed(offset: fullName.length),
      );
    }
  }

  void _clearPasswordControllers() {
    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
  }

  Future<void> _pickImage(ImageSource source) async {
    final file = await _picker.pickImage(
      source: source,
      imageQuality: 72,
      maxWidth: 1200,
    );

    if (file == null || !mounted) {
      return;
    }

    final bytes = await file.readAsBytes();
    final mime = _mimeTypeFromPath(file.name);
    final dataUrl = 'data:$mime;base64,${base64Encode(bytes)}';

    if (!mounted) {
      return;
    }
    context.read<ProfileEditBloc>().add(ProfileEditAvatarChanged(dataUrl));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileEditBloc, ProfileEditState>(
      listenWhen: (previous, current) =>
          previous.message != current.message && current.message != null,
      listener: (context, state) {
        final message = state.message;
        if (message == null) {
          return;
        }
        if (state.interaction == ProfileEditInteraction.saved) {
          _clearPasswordControllers();
        }
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(message),
              behavior: SnackBarBehavior.floating,
            ),
          );
        context.read<ProfileEditBloc>().add(const ProfileEditMessageConsumed());
      },
      builder: (context, state) {
        _syncControllers(state);

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Stack(
              children: [
                CustomScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
                        child: _EditHeader(onBack: () => Navigator.pop(context)),
                      ),
                    ),
                    if (state.isLoading)
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      )
                    else if (state.status == ProfileEditStatus.failure)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: _ErrorPanel(
                          onRetry: () => context
                              .read<ProfileEditBloc>()
                              .add(const ProfileEditStarted()),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 114),
                        sliver: SliverList.list(
                          children: [
                            _AvatarPicker(
                              avatarDataUrl: state.avatarDataUrl,
                              onCameraPressed: () => _pickImage(ImageSource.camera),
                              onGalleryPressed: () =>
                                  _pickImage(ImageSource.gallery),
                            ),
                            const SizedBox(height: 26),
                            _ProfileInfoCard(nameController: _nameController),
                            const SizedBox(height: 18),
                            _PasswordCard(
                              currentController: _currentPasswordController,
                              newController: _newPasswordController,
                              confirmController: _confirmPasswordController,
                              onCurrentChanged: (value) => context
                                  .read<ProfileEditBloc>()
                                  .add(ProfileEditCurrentPasswordChanged(value)),
                              onNewChanged: (value) => context
                                  .read<ProfileEditBloc>()
                                  .add(ProfileEditNewPasswordChanged(value)),
                              onConfirmChanged: (value) => context
                                  .read<ProfileEditBloc>()
                                  .add(ProfileEditConfirmPasswordChanged(value)),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _CompleteButtonBar(
                    canSubmit: state.canSubmit,
                    isSaving: state.isSaving,
                    onSubmit: () => context
                        .read<ProfileEditBloc>()
                        .add(const ProfileEditSubmitted()),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EditHeader extends StatelessWidget {
  const _EditHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back_rounded),
          color: AppColors.brown,
          style: IconButton.styleFrom(
            backgroundColor: AppColors.heroBg.withValues(alpha: 0.7),
          ),
        ),
        const Expanded(
          child: Text(
            'Chỉnh sửa hồ sơ',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppColors.brownText,
            ),
          ),
        ),
        const SizedBox(width: 48),
      ],
    );
  }
}

class _AvatarPicker extends StatelessWidget {
  const _AvatarPicker({
    required this.avatarDataUrl,
    required this.onCameraPressed,
    required this.onGalleryPressed,
  });

  final String? avatarDataUrl;
  final VoidCallback onCameraPressed;
  final VoidCallback onGalleryPressed;

  @override
  Widget build(BuildContext context) {
    final bytes = _bytesFromDataUrl(avatarDataUrl);

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 112,
              height: 112,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: AppColors.heroBg.withValues(alpha: 0.8),
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: bytes == null
                    ? Container(
                        color: Colors.white,
                        child: const Icon(
                          Icons.person_rounded,
                          color: AppColors.primary,
                          size: 58,
                        ),
                      )
                    : Image.memory(bytes, fit: BoxFit.cover),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 8,
              child: Material(
                color: AppColors.brown,
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: onGalleryPressed,
                  customBorder: const CircleBorder(),
                  child: const SizedBox(
                    width: 34,
                    height: 34,
                    child: Icon(
                      Icons.photo_camera_rounded,
                      color: Colors.white,
                      size: 18,
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
            _PhotoButton(
              label: 'Tải ảnh lên',
              icon: Icons.photo_library_outlined,
              filled: true,
              onPressed: onGalleryPressed,
            ),
            const SizedBox(width: 10),
            _PhotoButton(
              label: 'Chụp ảnh',
              icon: Icons.photo_camera_outlined,
              filled: false,
              onPressed: onCameraPressed,
            ),
          ],
        ),
      ],
    );
  }
}

class _PhotoButton extends StatelessWidget {
  const _PhotoButton({
    required this.label,
    required this.icon,
    required this.filled,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool filled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          backgroundColor: filled ? AppColors.primary : Colors.white,
          foregroundColor: filled ? Colors.white : AppColors.primaryDark,
          side: const BorderSide(color: AppColors.primary),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _ProfileInfoCard extends StatelessWidget {
  const _ProfileInfoCard({required this.nameController});

  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.badge_outlined,
            label: 'Thông tin tài khoản',
          ),
          const SizedBox(height: 18),
          TextField(
            controller: nameController,
            readOnly: true,
            decoration: _inputDecoration(
              label: 'Tên người dùng',
              hint: 'Tên từ tài khoản đăng ký',
              suffixIcon: Icons.lock_outline_rounded,
            ),
          ),
        ],
      ),
    );
  }
}

class _PasswordCard extends StatelessWidget {
  const _PasswordCard({
    required this.currentController,
    required this.newController,
    required this.confirmController,
    required this.onCurrentChanged,
    required this.onNewChanged,
    required this.onConfirmChanged,
  });

  final TextEditingController currentController;
  final TextEditingController newController;
  final TextEditingController confirmController;
  final ValueChanged<String> onCurrentChanged;
  final ValueChanged<String> onNewChanged;
  final ValueChanged<String> onConfirmChanged;

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.lock_outline_rounded,
            label: 'Thay đổi mật khẩu',
          ),
          const SizedBox(height: 8),
          Text(
            'Bỏ trống nếu bạn chỉ muốn cập nhật ảnh hồ sơ.',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.brownText.withValues(alpha: 0.56),
            ),
          ),
          const SizedBox(height: 18),
          _PasswordField(
            controller: currentController,
            label: 'Mật khẩu hiện tại',
            onChanged: onCurrentChanged,
          ),
          const SizedBox(height: 14),
          _PasswordField(
            controller: newController,
            label: 'Mật khẩu mới',
            onChanged: onNewChanged,
          ),
          const SizedBox(height: 14),
          _PasswordField(
            controller: confirmController,
            label: 'Xác nhận mật khẩu mới',
            onChanged: onConfirmChanged,
          ),
        ],
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.label,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: true,
      onChanged: onChanged,
      decoration: _inputDecoration(
        label: label,
        suffixIcon: Icons.visibility_off_outlined,
      ),
    );
  }
}

class _CompleteButtonBar extends StatelessWidget {
  const _CompleteButtonBar({
    required this.canSubmit,
    required this.isSaving,
    required this.onSubmit,
  });

  final bool canSubmit;
  final bool isSaving;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 58,
        child: FilledButton(
          onPressed: canSubmit ? onSubmit : null,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.brown,
            disabledBackgroundColor: AppColors.brown.withValues(alpha: 0.35),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 0,
          ),
          child: isSaving
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: Colors.white,
                  ),
                )
              : const Text(
                  'Hoàn tất',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
        ),
      ),
    );
  }
}

class _ErrorPanel extends StatelessWidget {
  const _ErrorPanel({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Không tải được hồ sơ.',
              style: TextStyle(
                color: AppColors.mutedText,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w900,
            color: AppColors.brownText,
          ),
        ),
      ],
    );
  }
}

class _SoftCard extends StatelessWidget {
  const _SoftCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.055),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

InputDecoration _inputDecoration({
  required String label,
  String? hint,
  IconData? suffixIcon,
}) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    suffixIcon: suffixIcon == null ? null : Icon(suffixIcon, size: 18),
    floatingLabelBehavior: FloatingLabelBehavior.always,
    filled: true,
    fillColor: const Color(0xFFFFFBF7),
    labelStyle: const TextStyle(
      color: AppColors.brownText,
      fontSize: 12,
      fontWeight: FontWeight.w800,
    ),
    hintStyle: TextStyle(
      color: AppColors.mutedText.withValues(alpha: 0.75),
      fontSize: 13,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        color: AppColors.brownText.withValues(alpha: 0.18),
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        color: AppColors.brownText.withValues(alpha: 0.18),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
    ),
  );
}

Uint8List? _bytesFromDataUrl(String? dataUrl) {
  if (dataUrl == null || !dataUrl.startsWith('data:image/')) {
    return null;
  }
  final commaIndex = dataUrl.indexOf(',');
  if (commaIndex == -1) {
    return null;
  }
  try {
    return base64Decode(dataUrl.substring(commaIndex + 1));
  } on FormatException {
    return null;
  }
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
