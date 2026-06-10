import 'package:app/app/theme/app_colors.dart';
import 'package:app/features/profile/presentation/bloc/profile_address_bloc.dart';
import 'package:app/features/profile/presentation/bloc/profile_address_event.dart';
import 'package:app/features/profile/presentation/bloc/profile_address_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileAddressPage extends StatefulWidget {
  const ProfileAddressPage({super.key});

  static const String routeName = 'profile-address';
  static const String routePath = '/profile/address';

  @override
  State<ProfileAddressPage> createState() => _ProfileAddressPageState();
}

class _ProfileAddressPageState extends State<ProfileAddressPage> {
  late final TextEditingController _detailController;
  late final TextEditingController _labelController;

  @override
  void initState() {
    super.initState();
    _detailController = TextEditingController();
    _labelController = TextEditingController();
  }

  @override
  void dispose() {
    _detailController.dispose();
    _labelController.dispose();
    super.dispose();
  }

  void _syncControllers(ProfileAddressState state) {
    if (_detailController.text != state.detail) {
      _detailController.value = TextEditingValue(
        text: state.detail,
        selection: TextSelection.collapsed(offset: state.detail.length),
      );
    }
    if (_labelController.text != state.label) {
      _labelController.value = TextEditingValue(
        text: state.label,
        selection: TextSelection.collapsed(offset: state.label.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileAddressBloc, ProfileAddressState>(
      listenWhen: (previous, current) =>
          previous.message != current.message && current.message != null,
      listener: (context, state) {
        final message = state.message;
        if (message == null) {
          return;
        }
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(message),
              behavior: SnackBarBehavior.floating,
            ),
          );
        context
            .read<ProfileAddressBloc>()
            .add(const ProfileAddressMessageConsumed());
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
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                        child: Column(
                          children: [
                            _AddressHeader(onBack: () => Navigator.pop(context)),
                            const SizedBox(height: 28),
                            const Text(
                              'Địa chỉ của tôi',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 34,
                                height: 1.05,
                                fontWeight: FontWeight.w800,
                                color: AppColors.brownText,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Nhập địa chỉ của bạn hoặc lấy vị trí hiện tại',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 17,
                                color: AppColors.brownText
                                    .withValues(alpha: 0.58),
                              ),
                            ),
                          ],
                        ),
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
                    else
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 112),
                        sliver: SliverList.list(
                          children: [
                            _AddressInputCard(
                              detailController: _detailController,
                              labelController: _labelController,
                              onDetailChanged: (value) => context
                                  .read<ProfileAddressBloc>()
                                  .add(ProfileAddressDetailChanged(value)),
                              onLabelChanged: (value) => context
                                  .read<ProfileAddressBloc>()
                                  .add(ProfileAddressLabelChanged(value)),
                            ),
                            const SizedBox(height: 24),
                            _LocateCard(
                              isLoading: state.isLocating,
                              onTap: state.isLocating
                                  ? null
                                  : () => context
                                      .read<ProfileAddressBloc>()
                                      .add(const ProfileAddressLocatePressed()),
                            ),
                            const SizedBox(height: 24),
                            _SelectedAddressCard(state: state),
                          ],
                        ),
                      ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _SaveAddressBar(
                    canSave: state.canSave,
                    isSaving: state.isSaving,
                    onSave: () => context
                        .read<ProfileAddressBloc>()
                        .add(const ProfileAddressSavePressed()),
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

class _AddressHeader extends StatelessWidget {
  const _AddressHeader({required this.onBack});

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
        const Spacer(),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.14),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.pets_rounded,
            color: AppColors.primary,
            size: 18,
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          'PawSitive Care',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: AppColors.brownText,
          ),
        ),
        const Spacer(),
        const SizedBox(width: 48),
      ],
    );
  }
}

class _AddressInputCard extends StatelessWidget {
  const _AddressInputCard({
    required this.detailController,
    required this.labelController,
    required this.onDetailChanged,
    required this.onLabelChanged,
  });

  final TextEditingController detailController;
  final TextEditingController labelController;
  final ValueChanged<String> onDetailChanged;
  final ValueChanged<String> onLabelChanged;

  @override
  Widget build(BuildContext context) {
    return _SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.home_outlined,
            label: 'Địa chỉ',
          ),
          const SizedBox(height: 18),
          _AddressTextField(
            controller: detailController,
            hintText: 'Nhập địa chỉ của bạn',
            maxLength: 300,
            minLines: 4,
            maxLines: 5,
            onChanged: onDetailChanged,
          ),
          const SizedBox(height: 18),
          _AddressTextField(
            controller: labelController,
            hintText: 'Tên địa chỉ (tùy chọn)',
            maxLength: 50,
            minLines: 1,
            maxLines: 1,
            onChanged: onLabelChanged,
          ),
        ],
      ),
    );
  }
}

class _LocateCard extends StatelessWidget {
  const _LocateCard({
    required this.isLoading,
    required this.onTap,
  });

  final bool isLoading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: _SoftCard(
          child: Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          color: AppColors.primary,
                        ),
                      )
                    : const Icon(
                        Icons.location_on_outlined,
                        color: AppColors.primary,
                        size: 34,
                      ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isLoading ? 'Đang lấy vị trí...' : 'Lấy vị trí hiện tại',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.brownText,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Ứng dụng sẽ tự động phát hiện vị trí hiện tại của bạn.',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.35,
                        color: AppColors.mutedText.withValues(alpha: 0.95),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.mutedText,
                size: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectedAddressCard extends StatelessWidget {
  const _SelectedAddressCard({required this.state});

  final ProfileAddressState state;

  @override
  Widget build(BuildContext context) {
    final updatedAt = state.address?.updatedAt;
    final updatedText = updatedAt == null
        ? null
        : 'Cập nhật: ${_twoDigits(updatedAt.hour)}:${_twoDigits(updatedAt.minute)}, '
            '${_twoDigits(updatedAt.day)}/${_twoDigits(updatedAt.month)}/${updatedAt.year}';

    return _SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.check_circle_outline_rounded,
            label: 'Vị trí đã chọn',
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.heroBg.withValues(alpha: 0.24),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.28),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.detail.trim().isEmpty
                      ? 'Chưa chọn địa chỉ'
                      : state.detail.trim(),
                  style: const TextStyle(
                    fontSize: 17,
                    height: 1.35,
                    color: AppColors.brownText,
                  ),
                ),
                if (updatedText != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    updatedText,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.mutedText,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: AppColors.mutedText,
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Ứng dụng sẽ dùng định vị để điền địa chỉ hiện tại của bạn.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.35,
                    color: AppColors.mutedText.withValues(alpha: 0.9),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _twoDigits(int value) => value.toString().padLeft(2, '0');
}

class _SaveAddressBar extends StatelessWidget {
  const _SaveAddressBar({
    required this.canSave,
    required this.isSaving,
    required this.onSave,
  });

  final bool canSave;
  final bool isSaving;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
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
          onPressed: canSave ? onSave : null,
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
                  'Lưu địa chỉ',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
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
        Icon(icon, color: AppColors.primary, size: 25),
        const SizedBox(width: 14),
        Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.brownText,
          ),
        ),
      ],
    );
  }
}

class _AddressTextField extends StatelessWidget {
  const _AddressTextField({
    required this.controller,
    required this.hintText,
    required this.maxLength,
    required this.minLines,
    required this.maxLines,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final int maxLength;
  final int minLines;
  final int maxLines;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      maxLength: maxLength,
      onChanged: onChanged,
      style: const TextStyle(
        fontSize: 17,
        height: 1.35,
        color: AppColors.brownText,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: AppColors.mutedText.withValues(alpha: 0.7),
        ),
        counterStyle: const TextStyle(color: AppColors.mutedText),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColors.brownText.withValues(alpha: 0.22),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.4,
          ),
        ),
      ),
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
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.055),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}
