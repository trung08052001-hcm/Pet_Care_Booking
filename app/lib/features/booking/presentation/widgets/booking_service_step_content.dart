import 'package:app/app/theme/app_colors.dart';
import 'package:app/features/booking/domain/entities/bookable_service.dart';
import 'package:app/features/booking/domain/entities/booking_step.dart';
import 'package:app/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:app/features/booking/presentation/bloc/booking_event.dart';
import 'package:app/features/booking/presentation/bloc/booking_service_selection_bloc.dart';
import 'package:app/features/booking/presentation/bloc/booking_service_selection_event.dart';
import 'package:app/features/booking/presentation/bloc/booking_service_selection_state.dart';
import 'package:app/features/booking/presentation/mappers/booking_service_ui_mapper.dart';
import 'package:app/features/booking/presentation/widgets/booking_progress_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class BookingServiceStepContent extends StatelessWidget {
  const BookingServiceStepContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingServiceSelectionBloc, BookingServiceSelectionState>(
      builder: (context, state) {
        if (state.status == BookingServiceSelectionStatus.failure) {
          return Column(
            children: [
              _BookingServiceTopBar(
                onBack: () => context
                    .read<BookingBloc>()
                    .add(const BookingServiceStepBackPressed()),
              ),
              const BookingProgressStepper(currentStep: BookingStep.service),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.message ?? 'Không tải được dịch vụ.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.mutedText),
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () {
                            final booking = context.read<BookingBloc>().state;
                            context.read<BookingServiceSelectionBloc>().add(
                                  BookingServiceSelectionStarted(
                                    petId: booking.selectedPetId,
                                    preselectedServiceId: booking.serviceId,
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
            ],
          );
        }

        if (state.isLoading || state.content == null) {
          return Column(
            children: [
              _BookingServiceTopBar(
                onBack: () => context
                    .read<BookingBloc>()
                    .add(const BookingServiceStepBackPressed()),
              ),
              const BookingProgressStepper(currentStep: BookingStep.service),
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),
            ],
          );
        }

        final content = state.content!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _BookingServiceTopBar(
              onBack: () => context
                  .read<BookingBloc>()
                  .add(const BookingServiceStepBackPressed()),
            ),
            const BookingProgressStepper(currentStep: BookingStep.service),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: [
                  Text(
                    content.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.brownText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content.subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.45,
                      color: AppColors.brownText.withValues(alpha: 0.65),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...content.services.map(
                    (service) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _BookableServiceCard(
                        service: service,
                        isSelected:
                            state.selectedServiceIds.contains(service.id),
                        onTap: () => context
                            .read<BookingServiceSelectionBloc>()
                            .add(BookingServiceTogglePressed(service.id)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _TipCard(
                    title: content.tipTitle,
                    body: content.tipBody,
                  ),
                ],
              ),
            ),
            _BookingServiceBottomBar(
              totalLabel: content.totalLabel,
              continueLabel: content.continueLabel,
              totalVnd: state.totalVnd,
              canContinue: state.canContinue,
              onContinue: () {
                context.read<BookingBloc>().add(
                      BookingServicesConfirmed(
                        serviceIds: state.selectedServiceIds.toList(),
                        totalVnd: state.totalVnd,
                      ),
                    );
              },
            ),
          ],
        );
      },
    );
  }
}

class _BookingServiceTopBar extends StatelessWidget {
  const _BookingServiceTopBar({required this.onBack});

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
          const Expanded(
            child: Text(
              'PawSitive Care',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.brown,
              ),
            ),
          ),
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.heroBg,
            child: Text(
              'NM',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.brownText.withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BookableServiceCard extends StatelessWidget {
  const _BookableServiceCard({
    required this.service,
    required this.isSelected,
    required this.onTap,
  });

  final BookableService service;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: BookingServiceUiMapper.cardColor(
                  service.iconBackgroundColor,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                BookingServiceUiMapper.serviceIcon(service.icon),
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          service.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.brownText,
                          ),
                        ),
                      ),
                      Text(
                        BookingServiceUiMapper.formatPrice(
                          service.priceVnd,
                          unitSuffix: service.priceUnitSuffix,
                        ),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.brownText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    service.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: AppColors.brownText.withValues(alpha: 0.6),
                    ),
                  ),
                  if (service.tagLabel != null) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F4F6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            BookingServiceUiMapper.tagIconFor(service),
                            size: 14,
                            color: AppColors.mutedText,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            service.tagLabel!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.mutedText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.primary,
                size: 22,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  const _TipCard({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.heroBg.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.6)),
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
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    color: AppColors.brownText.withValues(alpha: 0.75),
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

class _BookingServiceBottomBar extends StatelessWidget {
  const _BookingServiceBottomBar({
    required this.totalLabel,
    required this.continueLabel,
    required this.totalVnd,
    required this.canContinue,
    required this.onContinue,
  });

  final String totalLabel;
  final String continueLabel;
  final int totalVnd;
  final bool canContinue;
  final VoidCallback onContinue;

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
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
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
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: FilledButton(
                onPressed: canContinue ? onContinue : null,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: const Color(0xFFD0D5D9),
                  foregroundColor: Colors.white,
                  disabledForegroundColor: Colors.white70,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  continueLabel,
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
