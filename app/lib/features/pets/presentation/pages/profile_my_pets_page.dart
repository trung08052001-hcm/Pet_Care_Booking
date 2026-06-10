import 'package:app/app/theme/app_colors.dart';
import 'package:app/features/pets/domain/entities/pet.dart';
import 'package:app/features/pets/domain/entities/pet_gender.dart';
import 'package:app/features/pets/presentation/bloc/pets_bloc.dart';
import 'package:app/features/pets/presentation/bloc/pets_event.dart';
import 'package:app/features/pets/presentation/bloc/pets_state.dart';
import 'package:app/features/pets/presentation/pages/pet_profile_detail_page.dart';
import 'package:app/features/pets/presentation/widgets/pet_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProfileMyPetsPage extends StatelessWidget {
  const ProfileMyPetsPage({super.key});

  static const routeName = 'profile-my-pets';
  static const routePath = '/profile/pets';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PetsBloc, PetsState>(
      listenWhen: (previous, current) =>
          previous.message != current.message && current.message != null,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message!)),
        );
        context.read<PetsBloc>().add(const PetsInteractionConsumed());
      },
      builder: (context, state) {
        final content = state.content;

        return Scaffold(
          backgroundColor: const Color(0xFFFAFAFA),
          body: SafeArea(
            child: RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async {
                context.read<PetsBloc>().add(const PetsRefreshRequested());
                await context.read<PetsBloc>().stream.firstWhere(
                      (next) =>
                          next.status == PetsStatus.success ||
                          next.status == PetsStatus.failure,
                    );
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: _Header(
                      isLoading: state.isLoading,
                      onBack: () => context.pop(),
                    ),
                  ),
                  if (state.status == PetsStatus.failure)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _ErrorState(
                        message:
                            state.message ?? 'Không tải được thú cưng của bạn.',
                        onRetry: () => context
                            .read<PetsBloc>()
                            .add(const PetsRefreshRequested()),
                      ),
                    )
                  else if (state.isLoading || content == null)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  else if (content.pets.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _EmptyState(
                        onAdd: () =>
                            context.read<PetsBloc>().add(const PetAddPressed()),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 120),
                      sliver: SliverList.separated(
                        itemBuilder: (context, index) {
                          if (index == content.pets.length) {
                            return _AddPetButton(
                              onPressed: () => context
                                  .read<PetsBloc>()
                                  .add(const PetAddPressed()),
                            );
                          }

                          final pet = content.pets[index];
                          return _ProfilePetCard(
                            pet: pet,
                            onDetails: () => context.pushNamed(
                              PetProfileDetailPage.routeName,
                              pathParameters: {'petId': pet.id},
                              extra: pet,
                            ),
                          );
                        },
                        separatorBuilder: (_, index) =>
                            const SizedBox(height: 18),
                        itemCount: content.pets.length + 1,
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

class _Header extends StatelessWidget {
  const _Header({
    required this.isLoading,
    required this.onBack,
  });

  final bool isLoading;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_rounded),
                color: AppColors.brown,
              ),
              const SizedBox(width: 10),
              Container(
                width: 46,
                height: 46,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFE8DA),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.pets_rounded,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  'PawSitive Care',
                  style: TextStyle(
                    color: AppColors.brown,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none_rounded),
                color: AppColors.brown,
              ),
            ],
          ),
          const SizedBox(height: 28),
          const Text(
            'Thú cưng của tôi',
            style: TextStyle(
              color: AppColors.brown,
              fontSize: 34,
              fontWeight: FontWeight.w900,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Quản lý thông tin thú cưng của bạn',
                  style: TextStyle(
                    color: AppColors.mutedText,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (isLoading)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfilePetCard extends StatelessWidget {
  const _ProfilePetCard({
    required this.pet,
    required this.onDetails,
  });

  final Pet pet;
  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    final genderColor = pet.gender == PetGender.male
        ? const Color(0xFF4A9AE9)
        : const Color(0xFFFF6380);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          PetImage(pet: pet, size: 124),
          const SizedBox(width: 22),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  runSpacing: 6,
                  children: [
                    Text(
                      pet.name,
                      style: const TextStyle(
                        color: AppColors.brown,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: genderColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            pet.gender == PetGender.male
                                ? Icons.male_rounded
                                : Icons.female_rounded,
                            size: 18,
                            color: genderColor,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            pet.gender == PetGender.male ? 'Đực' : 'Cái',
                            style: TextStyle(
                              color: genderColor,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  _typeBreedLabel(pet),
                  style: const TextStyle(
                    color: AppColors.mutedText,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    _SmallMeta(icon: Icons.calendar_month_outlined, text: pet.ageLabel),
                    Container(
                      width: 1,
                      height: 24,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      color: AppColors.divider,
                    ),
                    _SmallMeta(
                      icon: Icons.medical_services_outlined,
                      text: pet.weightLabel,
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Divider(height: 1, color: AppColors.divider),
                InkWell(
                  onTap: onDetails,
                  borderRadius: BorderRadius.circular(18),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: Row(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFE8DA),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.pets_rounded,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Text(
                            'Xem chi tiết',
                            style: TextStyle(
                              color: AppColors.brown,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: AppColors.mutedText,
                          size: 30,
                        ),
                      ],
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

  String _typeBreedLabel(Pet pet) {
    final type = switch (pet.petType) {
      'cat' => 'Mèo',
      'rabbit' => 'Thỏ',
      'bird' => 'Chim',
      _ => 'Chó',
    };
    return '$type ${pet.breed}';
  }
}

class _SmallMeta extends StatelessWidget {
  const _SmallMeta({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: AppColors.mutedText),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.mutedText,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddPetButton extends StatelessWidget {
  const _AddPetButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 68,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.add_rounded, size: 30),
        label: const Text('Thêm thú cưng'),
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.brown,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.pets_rounded, size: 54, color: AppColors.primary),
          const SizedBox(height: 12),
          const Text(
            'Bạn chưa có thú cưng nào',
            style: TextStyle(
              color: AppColors.brown,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Thêm thú cưng để quản lý hồ sơ và đặt lịch dễ hơn.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.mutedText),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Thêm thú cưng'),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off_rounded, size: 48, color: AppColors.primary),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.mutedText),
          ),
          const SizedBox(height: 18),
          FilledButton(
            onPressed: onRetry,
            child: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }
}
