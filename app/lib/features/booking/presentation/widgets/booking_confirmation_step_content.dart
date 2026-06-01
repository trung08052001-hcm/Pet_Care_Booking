import 'package:app/app/navigation/booking_navigation.dart';
import 'package:app/app/theme/app_colors.dart';
import 'package:app/features/booking/domain/entities/booking_confirmation_request.dart';
import 'package:app/features/booking/domain/entities/booking_line_item.dart';
import 'package:app/features/booking/domain/entities/booking_step.dart';
import 'package:app/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:app/features/booking/presentation/bloc/booking_confirmation_bloc.dart';
import 'package:app/features/booking/presentation/bloc/booking_confirmation_event.dart';
import 'package:app/features/booking/presentation/bloc/booking_confirmation_state.dart';
import 'package:app/features/booking/presentation/bloc/booking_event.dart';
import 'package:app/features/booking/presentation/mappers/booking_service_ui_mapper.dart';
import 'package:app/features/booking/presentation/widgets/booking_progress_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingConfirmationStepContent extends StatelessWidget {
  const BookingConfirmationStepContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingConfirmationBloc, BookingConfirmationState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == BookingConfirmationStatus.completed,
      listener: (context, state) {
        final reference = state.bookingReference;
        if (reference == null) {
          return;
        }

        context.read<BookingBloc>().add(
              BookingFlowCompleted(bookingReference: reference),
            );

        openBookingDetail(context, bookingId: reference);
      },
      builder: (context, state) {
        if (state.status == BookingConfirmationStatus.failure) {
          return _ConfirmationShell(
            onBack: () => context
                .read<BookingBloc>()
                .add(const BookingConfirmationStepBackPressed()),
            child: Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.message ?? 'Không tải được xác nhận.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.mutedText),
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () {
                          final booking = context.read<BookingBloc>().state;
                          if (booking.selectedPetId == null ||
                              booking.selectedAppointmentDate == null ||
                              booking.selectedTimeSlotId == null ||
                              booking.selectedTimeSlotLabel == null) {
                            return;
                          }
                          context.read<BookingConfirmationBloc>().add(
                                BookingConfirmationStarted(
                                  BookingConfirmationRequest(
                                    petId: booking.selectedPetId!,
                                    serviceIds: booking.selectedServiceIds,
                                    appointmentDate:
                                        booking.selectedAppointmentDate!,
                                    timeSlotId: booking.selectedTimeSlotId!,
                                    timeSlotLabel:
                                        booking.selectedTimeSlotLabel!,
                                    totalVnd: booking.totalVnd,
                                  ),
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
          return _ConfirmationShell(
            onBack: () => context
                .read<BookingBloc>()
                .add(const BookingConfirmationStepBackPressed()),
            child: const Expanded(
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
          );
        }

        final content = state.content!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ConfirmationTopBar(
              title: content.title,
              onBack: () => context
                  .read<BookingBloc>()
                  .add(const BookingConfirmationStepBackPressed()),
            ),
            const BookingProgressStepper(currentStep: BookingStep.confirmation),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: [
                  _BookingDetailsCard(
                    petName: content.petName,
                    petSubtitle: content.petSubtitle,
                    petColor: Color(content.petImagePlaceholderColor),
                    serviceLabel: content.serviceLabel,
                    serviceValue: content.serviceValue,
                    timeLabel: content.timeLabel,
                    timeValue: content.timeValue,
                    locationLabel: content.locationLabel,
                    locationValue: content.locationValue,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    content.paymentSectionTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.brownText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _PaymentBreakdownCard(
                    lineItems: content.lineItems,
                    discountLabel: content.discountLabel,
                    discountVnd: content.discountVnd,
                    totalLabel: content.totalLabel,
                    totalVnd: content.totalVnd,
                  ),
                  const SizedBox(height: 16),
                  _PaymentMethodCard(
                    name: content.paymentMethod.name,
                    balanceLabel: content.paymentMethod.balanceLabel,
                    changeLabel: content.paymentMethod.changeLabel,
                    onChange: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Thay đổi phương thức — đang phát triển.'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    content.cancellationNote,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.brownText.withValues(alpha: 0.55),
                    ),
                  ),
                ],
              ),
            ),
            _ConfirmationBottomBar(
              label: content.completeButtonLabel,
              isLoading: state.isSubmitting,
              onPressed: () => context
                  .read<BookingConfirmationBloc>()
                  .add(const BookingConfirmationCompletePressed()),
            ),
          ],
        );
      },
    );
  }
}

class _ConfirmationShell extends StatelessWidget {
  const _ConfirmationShell({required this.onBack, required this.child});

  final VoidCallback onBack;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ConfirmationTopBar(title: 'Xác nhận', onBack: onBack),
        const BookingProgressStepper(currentStep: BookingStep.confirmation),
        child,
      ],
    );
  }
}

class _ConfirmationTopBar extends StatelessWidget {
  const _ConfirmationTopBar({required this.title, required this.onBack});

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

class _BookingDetailsCard extends StatelessWidget {
  const _BookingDetailsCard({
    required this.petName,
    required this.petSubtitle,
    required this.petColor,
    required this.serviceLabel,
    required this.serviceValue,
    required this.timeLabel,
    required this.timeValue,
    required this.locationLabel,
    required this.locationValue,
  });

  final String petName;
  final String petSubtitle;
  final Color petColor;
  final String serviceLabel;
  final String serviceValue;
  final String timeLabel;
  final String timeValue;
  final String locationLabel;
  final String locationValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: petColor,
                child: Text(
                  petName.isNotEmpty ? petName[0] : '?',
                  style: const TextStyle(
                    fontSize: 20,
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
                      petName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.brownText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      petSubtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.brownText.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),
          _DetailRow(label: serviceLabel, value: serviceValue),
          const SizedBox(height: 10),
          _DetailRow(label: timeLabel, value: timeValue),
          const SizedBox(height: 10),
          _DetailRow(label: locationLabel, value: locationValue),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 72,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.brownText.withValues(alpha: 0.5),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.brownText,
            ),
          ),
        ),
      ],
    );
  }
}

class _PaymentBreakdownCard extends StatelessWidget {
  const _PaymentBreakdownCard({
    required this.lineItems,
    required this.discountLabel,
    required this.discountVnd,
    required this.totalLabel,
    required this.totalVnd,
  });

  final List<BookingLineItem> lineItems;
  final String discountLabel;
  final int discountVnd;
  final String totalLabel;
  final int totalVnd;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ...lineItems.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.label,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.brownText,
                      ),
                    ),
                  ),
                  Text(
                    BookingServiceUiMapper.formatPrice(item.amountVnd),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.brownText,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  discountLabel,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.mutedText,
                  ),
                ),
              ),
              Text(
                '-${BookingServiceUiMapper.formatPrice(discountVnd)}',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.mutedText,
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  totalLabel,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.brownText,
                  ),
                ),
              ),
              Text(
                BookingServiceUiMapper.formatPrice(totalVnd),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
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

class _PaymentMethodCard extends StatelessWidget {
  const _PaymentMethodCard({
    required this.name,
    required this.balanceLabel,
    required this.changeLabel,
    required this.onChange,
  });

  final String name;
  final String balanceLabel;
  final String changeLabel;
  final VoidCallback onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              color: AppColors.primary,
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
                const SizedBox(height: 4),
                Text(
                  balanceLabel,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.brownText.withValues(alpha: 0.55),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onChange,
            child: Text(
              changeLabel,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfirmationBottomBar extends StatelessWidget {
  const _ConfirmationBottomBar({
    required this.label,
    required this.isLoading,
    required this.onPressed,
  });

  final String label;
  final bool isLoading;
  final VoidCallback onPressed;

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
        child: SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: isLoading ? null : onPressed,
            icon: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.check_rounded),
            label: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              elevation: 0,
            ),
          ),
        ),
      ),
    );
  }
}
