import 'package:app/app/theme/app_colors.dart';
import 'package:app/features/booking/domain/entities/appointment_day_option.dart';
import 'package:app/features/booking/domain/entities/appointment_time_period.dart';
import 'package:app/features/booking/domain/entities/appointment_time_slot.dart';
import 'package:app/features/booking/domain/entities/booking_step.dart';
import 'package:app/features/booking/presentation/bloc/booking_appointment_bloc.dart';
import 'package:app/features/booking/presentation/bloc/booking_appointment_event.dart';
import 'package:app/features/booking/presentation/bloc/booking_appointment_state.dart';
import 'package:app/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:app/features/booking/presentation/bloc/booking_event.dart';
import 'package:app/features/booking/presentation/mappers/booking_service_ui_mapper.dart';
import 'package:app/features/booking/presentation/widgets/booking_progress_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingAppointmentStepContent extends StatelessWidget {
  const BookingAppointmentStepContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingAppointmentBloc, BookingAppointmentState>(
      builder: (context, state) {
        if (state.status == BookingAppointmentStatus.failure) {
          return _AppointmentScaffold(
            onBack: () => context
                .read<BookingBloc>()
                .add(const BookingAppointmentStepBackPressed()),
            child: Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.message ?? 'Không tải được lịch hẹn.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.mutedText),
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () {
                          final booking = context.read<BookingBloc>().state;
                          context.read<BookingAppointmentBloc>().add(
                                BookingAppointmentStarted(
                                  petId: booking.selectedPetId!,
                                  serviceIds: booking.selectedServiceIds,
                                  totalVnd: booking.totalVnd,
                                ),
                              );
                        },
                        child: const Text('Thử lại'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        if (state.isLoading || state.content == null) {
          return _AppointmentScaffold(
            onBack: () => context
                .read<BookingBloc>()
                .add(const BookingAppointmentStepBackPressed()),
            child: const Expanded(
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
          );
        }

        final content = state.content!;
        final morningSlots = state.slotsForSelectedDate
            .where((s) => s.period == AppointmentTimePeriod.morning)
            .toList();
        final afternoonSlots = state.slotsForSelectedDate
            .where((s) => s.period == AppointmentTimePeriod.afternoon)
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _AppointmentTopBar(
              title: content.title,
              onBack: () => context
                  .read<BookingBloc>()
                  .add(const BookingAppointmentStepBackPressed()),
            ),
            const BookingProgressStepper(currentStep: BookingStep.appointment),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: [
                  _PetSummaryCard(
                    name: content.petSummary.name,
                    tags: content.petSummary.serviceTags,
                    color: Color(content.petSummary.imagePlaceholderColor),
                    onEdit: () => context.read<BookingBloc>().add(
                          const BookingAppointmentStepBackPressed(),
                        ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    content.dateSectionTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.brownText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content.monthLabel,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.brownText.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 72,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: content.days.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final day = content.days[index];
                        final isSelected = state.selectedDate != null &&
                            _isSameDay(state.selectedDate!, day.date);
                        return _DateChip(
                          day: day,
                          isSelected: isSelected,
                          onTap: () => context
                              .read<BookingAppointmentBloc>()
                              .add(BookingAppointmentDateSelected(day.date)),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    content.timeSectionTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.brownText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    content.morningSectionTitle,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.brownText.withValues(alpha: 0.55),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _TimeSlotGrid(
                    slots: morningSlots,
                    selectedSlotId: state.selectedTimeSlotId,
                    onSlotTap: (id) => context
                        .read<BookingAppointmentBloc>()
                        .add(BookingAppointmentTimeSlotSelected(id)),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    content.afternoonSectionTitle,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.brownText.withValues(alpha: 0.55),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _TimeSlotGrid(
                    slots: afternoonSlots,
                    selectedSlotId: state.selectedTimeSlotId,
                    onSlotTap: (id) => context
                        .read<BookingAppointmentBloc>()
                        .add(BookingAppointmentTimeSlotSelected(id)),
                  ),
                  const SizedBox(height: 20),
                  _CommitmentBanner(
                    title: content.commitmentTitle,
                    body: content.commitmentBody,
                  ),
                ],
              ),
            ),
            _AppointmentBottomBar(
              totalLabel: content.totalLabel,
              totalVnd: state.totalVnd,
              summaryLabel: state.appointmentSummaryLabel,
              confirmLabel: '${content.confirmButtonLabel} >',
              canConfirm: state.canConfirm,
              onConfirm: () {
                final slot = state.selectedSlot!;
                context.read<BookingBloc>().add(
                      BookingAppointmentConfirmed(
                        appointmentDate: state.selectedDate!,
                        timeSlotId: slot.id,
                        timeSlotLabel: slot.label,
                      ),
                    );
              },
            ),
          ],
        );
      },
    );
  }

  static bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _AppointmentScaffold extends StatelessWidget {
  const _AppointmentScaffold({required this.onBack, required this.child});

  final VoidCallback onBack;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _AppointmentTopBar(title: 'Lịch hẹn', onBack: onBack),
        const BookingProgressStepper(currentStep: BookingStep.appointment),
        child,
      ],
    );
  }
}

class _AppointmentTopBar extends StatelessWidget {
  const _AppointmentTopBar({required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 16, 4),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.brown),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.brown,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _PetSummaryCard extends StatelessWidget {
  const _PetSummaryCard({
    required this.name,
    required this.tags,
    required this.color,
    required this.onEdit,
  });

  final String name;
  final List<String> tags;
  final Color color;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: color,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.brownText,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.brownText,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: tags
                      .map(
                        (tag) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.heroBg,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: Icon(
              Icons.edit_outlined,
              size: 20,
              color: AppColors.brownText.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  const _DateChip({
    required this.day,
    required this.isSelected,
    required this.onTap,
  });

  final AppointmentDayOption day;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 64,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.12) : AppColors.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider.withValues(alpha: 0.5),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day.weekdayLabel,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppColors.primary : AppColors.mutedText,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              day.dayNumberLabel,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: isSelected ? AppColors.primary : AppColors.brownText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeSlotGrid extends StatelessWidget {
  const _TimeSlotGrid({
    required this.slots,
    required this.selectedSlotId,
    required this.onSlotTap,
  });

  final List<AppointmentTimeSlot> slots;
  final String? selectedSlotId;
  final ValueChanged<String> onSlotTap;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: slots.map((slot) {
        final isSelected = selectedSlotId == slot.id;
        final isFull = slot.availability == AppointmentSlotAvailability.full;
        return _TimeSlotChip(
          slot: slot,
          isSelected: isSelected,
          onTap: isFull ? null : () => onSlotTap(slot.id),
        );
      }).toList(),
    );
  }
}

class _TimeSlotChip extends StatelessWidget {
  const _TimeSlotChip({
    required this.slot,
    required this.isSelected,
    required this.onTap,
  });

  final AppointmentTimeSlot slot;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isFull = slot.availability == AppointmentSlotAvailability.full;

    Color bg;
    Color border;
    Color timeColor;
    String statusLabel;

    if (isFull) {
      bg = const Color(0xFFF0F2F4);
      border = Colors.transparent;
      timeColor = AppColors.mutedText;
      statusLabel = 'Hết chỗ';
    } else if (isSelected) {
      bg = AppColors.primary;
      border = AppColors.primary;
      timeColor = Colors.white;
      statusLabel = 'Đã chọn';
    } else {
      bg = AppColors.cardBg;
      border = AppColors.divider.withValues(alpha: 0.6);
      timeColor = AppColors.brownText;
      statusLabel = 'Còn chỗ';
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: (MediaQuery.sizeOf(context).width - 32 - 20) / 3,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border),
        ),
        child: Column(
          children: [
            Text(
              slot.label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: timeColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              statusLabel,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.9)
                    : AppColors.mutedText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommitmentBanner extends StatelessWidget {
  const _CommitmentBanner({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F8),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.shield_outlined,
            color: AppColors.primary.withValues(alpha: 0.85),
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.brownText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: AppColors.brownText.withValues(alpha: 0.65),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AppointmentBottomBar extends StatelessWidget {
  const _AppointmentBottomBar({
    required this.totalLabel,
    required this.totalVnd,
    required this.summaryLabel,
    required this.confirmLabel,
    required this.canConfirm,
    required this.onConfirm,
  });

  final String totalLabel;
  final int totalVnd;
  final String? summaryLabel;
  final String confirmLabel;
  final bool canConfirm;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        totalLabel,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.mutedText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        BookingServiceUiMapper.formatPrice(totalVnd),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.brownText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (summaryLabel != null) ...[
              const SizedBox(height: 8),
              Text(
                summaryLabel!,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.brownText.withValues(alpha: 0.7),
                ),
              ),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: canConfirm ? onConfirm : null,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: const Color(0xFFD0D5D9),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  confirmLabel,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
