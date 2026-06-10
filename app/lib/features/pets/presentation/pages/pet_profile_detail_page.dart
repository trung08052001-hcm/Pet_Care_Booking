import 'package:app/app/theme/app_colors.dart';
import 'package:app/features/pets/domain/entities/pet.dart';
import 'package:app/features/pets/domain/entities/pet_gender.dart';
import 'package:app/features/pets/presentation/bloc/pets_bloc.dart';
import 'package:app/features/pets/presentation/bloc/pets_state.dart';
import 'package:app/features/pets/presentation/widgets/pet_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PetProfileDetailPage extends StatelessWidget {
  const PetProfileDetailPage({
    required this.petId,
    this.initialPet,
    super.key,
  });

  static const routeName = 'profile-pet-detail';
  static const routePath = '/profile/pets/:petId';

  final String petId;
  final Pet? initialPet;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PetsBloc, PetsState>(
      builder: (context, state) {
        Pet? loadedPet;
        for (final pet in state.content?.pets ?? const <Pet>[]) {
          if (pet.id == petId) {
            loadedPet = pet;
            break;
          }
        }
        final pet = loadedPet ?? initialPet;

        return Scaffold(
          backgroundColor: const Color(0xFFFAFAFA),
          body: SafeArea(
            child: pet == null
                ? _MissingPetView(
                    isLoading: state.isLoading,
                    onBack: () => context.pop(),
                  )
                : _PetDetailContent(
                    pet: pet,
                    isLoading: state.isLoading,
                    onBack: () => context.pop(),
                  ),
          ),
        );
      },
    );
  }
}

class _PetDetailContent extends StatelessWidget {
  const _PetDetailContent({
    required this.pet,
    required this.isLoading,
    required this.onBack,
  });

  final Pet pet;
  final bool isLoading;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 14, 22, 18),
            child: Column(
              children: [
                _DetailTopBar(onBack: onBack),
                const SizedBox(height: 22),
                _HeroCard(pet: pet),
                if (isLoading) ...[
                  const SizedBox(height: 14),
                  const LinearProgressIndicator(
                    color: AppColors.primary,
                    backgroundColor: Color(0xFFFFE8DA),
                  ),
                ],
                const SizedBox(height: 22),
                _InfoCard(pet: pet),
                const SizedBox(height: 18),
                _IntroCard(pet: pet),
                const SizedBox(height: 18),
                _NoteCard(pet: pet),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 62,
                  child: FilledButton(
                    onPressed: () {},
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
                    child: const Text('Chỉnh sửa thông tin'),
                  ),
                ),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailTopBar extends StatelessWidget {
  const _DetailTopBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CircleButton(
          icon: Icons.chevron_left_rounded,
          onTap: onBack,
        ),
        const Expanded(
          child: Text(
            'Thú cưng của tôi',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.brown,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        _CircleButton(
          icon: Icons.more_horiz_rounded,
          onTap: () {},
        ),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.pet});

  final Pet pet;

  @override
  Widget build(BuildContext context) {
    final genderColor = pet.gender == PetGender.male
        ? const Color(0xFF4A9AE9)
        : const Color(0xFFFF6380);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEFE6),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              PetImage(
                pet: pet,
                size: 132,
                borderRadius: BorderRadius.circular(18),
              ),
              Positioned(
                right: 8,
                bottom: 8,
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: AppColors.brown,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.photo_camera_outlined,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 22),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        pet.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.brownText,
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      pet.gender == PetGender.male
                          ? Icons.male_rounded
                          : Icons.female_rounded,
                      color: genderColor,
                      size: 30,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  pet.breed,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.mutedText,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _MetricChip(
                      icon: Icons.pets_rounded,
                      label: pet.ageLabel,
                    ),
                    _MetricChip(
                      icon: Icons.medical_services_outlined,
                      label: pet.weightLabel,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.pet});

  final Pet pet;

  @override
  Widget build(BuildContext context) {
    final rows = [
      _InfoRowData(Icons.pets_rounded, 'Giống', pet.breed),
      _InfoRowData(Icons.calendar_month_outlined, 'Tuổi', pet.ageLabel),
      _InfoRowData(
        pet.gender == PetGender.male ? Icons.male_rounded : Icons.female_rounded,
        'Giới tính',
        pet.gender == PetGender.male ? 'Đực' : 'Cái',
      ),
      _InfoRowData(Icons.medical_services_outlined, 'Cân nặng', pet.weightLabel),
      _InfoRowData(Icons.vaccines_outlined, 'Mũi chích', pet.reminderLabel),
      _InfoRowData(Icons.star_border_rounded, 'Đặc điểm', _traits(pet)),
    ];

    return _SectionCard(
      title: 'Thông tin cơ bản',
      child: Column(
        children: rows
            .map(
              (row) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _InfoRow(data: row),
              ),
            )
            .toList(),
      ),
    );
  }

  String _traits(Pet pet) {
    return switch (pet.petType) {
      'cat' => 'Dịu dàng, sạch sẽ',
      'rabbit' => 'Hiền lành, đáng yêu',
      'bird' => 'Nhanh nhẹn, vui vẻ',
      _ => 'Thân thiện, năng động',
    };
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard({required this.pet});

  final Pet pet;

  @override
  Widget build(BuildContext context) {
    final species = switch (pet.petType) {
      'cat' => 'mèo',
      'rabbit' => 'thỏ',
      'bird' => 'chim',
      _ => 'chó',
    };

    return _SectionCard(
      title: 'Giới thiệu',
      child: Text(
        '${pet.name} là một bé $species rất thân thiện và đáng yêu. Hồ sơ này giúp bạn theo dõi thông tin chăm sóc của ${pet.name} dễ dàng hơn.',
        style: const TextStyle(
          color: Color(0xFF5F5A5A),
          fontSize: 18,
          height: 1.45,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.pet});

  final Pet pet;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Ghi chú',
      trailing: TextButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.add_rounded, size: 20),
        label: const Text('Thêm ghi chú'),
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          backgroundColor: const Color(0xFFFFE8DA),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      child: Text(
        pet.vaccinationStatus == null
            ? 'Chưa có ghi chú nào'
            : 'Tình trạng mũi chích: ${pet.reminderLabel}',
        style: const TextStyle(
          color: Color(0xFF5F5A5A),
          fontSize: 17,
          height: 1.4,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
    this.trailing,
  });

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.045),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.brownText,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              ?trailing,
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

class _InfoRowData {
  const _InfoRowData(this.icon, this.label, this.value);

  final IconData icon;
  final String label;
  final String value;
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.data});

  final _InfoRowData data;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFFFFE8DA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(data.icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            data.label,
            style: const TextStyle(
              color: Color(0xFF5F5A5A),
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            data.value,
            textAlign: TextAlign.left,
            style: const TextStyle(
              color: Color(0xFF4F4B4B),
              fontSize: 17,
              height: 1.35,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.brownText,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          color: Color(0xFFFFF0E8),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.brown, size: 28),
      ),
    );
  }
}

class _MissingPetView extends StatelessWidget {
  const _MissingPetView({
    required this.isLoading,
    required this.onBack,
  });

  final bool isLoading;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const CircularProgressIndicator(color: AppColors.primary)
            else ...[
              const Icon(
                Icons.pets_rounded,
                color: AppColors.primary,
                size: 48,
              ),
              const SizedBox(height: 12),
              const Text(
                'Không tìm thấy thú cưng',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.brown,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
            const SizedBox(height: 18),
            FilledButton(
              onPressed: onBack,
              child: const Text('Quay lại'),
            ),
          ],
        ),
      ),
    );
  }
}
