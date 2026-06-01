import 'package:app/app/theme/app_colors.dart';
import 'package:app/core/di/injection.dart';
import 'package:app/features/booking/domain/entities/booking_step.dart';
import 'package:app/features/booking/domain/entities/booking_confirmation_request.dart';
import 'package:app/features/booking/presentation/bloc/booking_appointment_bloc.dart';
import 'package:app/features/booking/presentation/bloc/booking_appointment_event.dart';
import 'package:app/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:app/features/booking/presentation/bloc/booking_confirmation_bloc.dart';
import 'package:app/features/booking/presentation/bloc/booking_confirmation_event.dart';
import 'package:app/features/booking/presentation/bloc/booking_event.dart';
import 'package:app/features/booking/presentation/bloc/booking_service_selection_bloc.dart';
import 'package:app/features/booking/presentation/bloc/booking_service_selection_event.dart';
import 'package:app/features/booking/presentation/bloc/booking_state.dart';
import 'package:app/features/booking/presentation/widgets/booking_appointment_step_content.dart';
import 'package:app/features/booking/presentation/widgets/booking_confirmation_step_content.dart';
import 'package:app/features/booking/presentation/widgets/booking_progress_stepper.dart';
import 'package:app/features/booking/presentation/widgets/booking_service_step_content.dart';
import 'package:app/features/pets/domain/entities/booking_flow_args.dart';
import 'package:app/features/pets/domain/entities/my_pets_page_content.dart';
import 'package:app/features/pets/domain/entities/pet.dart';
import 'package:app/features/pets/domain/entities/pet_health_status.dart';
import 'package:app/features/pets/presentation/bloc/pets_bloc.dart';
import 'package:app/features/pets/presentation/bloc/pets_event.dart';
import 'package:app/features/pets/presentation/bloc/pets_state.dart';
import 'package:app/features/pets/presentation/mappers/pets_ui_mapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MyPetsPage extends StatelessWidget {
  const MyPetsPage({super.key, this.serviceId});

  final String? serviceId;

  static const routeName = 'booking-my-pets';

  static const routePath = '/booking/my-pets';

  static BookingFlowArgs? argsFrom(Object? extra) {
    if (extra is BookingFlowArgs) {
      return extra;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<BookingBloc, BookingState>(
          listenWhen: (previous, current) =>
              previous.interaction != current.interaction,

          listener: (context, state) {
            switch (state.interaction) {
              case BookingInteraction.advanceToService:
                break;

              case BookingInteraction.addPet:
              case BookingInteraction.quickAddPet:
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Thêm thú cưng — đang phát triển.'),
                  ),
                );

              case BookingInteraction.petMoreOptions:
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tùy chọn thú cưng — đang phát triển.'),
                  ),
                );

              case BookingInteraction.none:
                break;
            }

            context.read<BookingBloc>().add(const BookingInteractionConsumed());
          },
        ),
      ],

      child: BlocBuilder<PetsBloc, PetsState>(
        builder: (context, petsState) {
          if (petsState.status == PetsStatus.failure) {
            return _PetsScaffold(
              child: _PetsErrorView(
                message:
                    petsState.message ?? 'Không tải được danh sách thú cưng.',

                onRetry: () =>
                    context.read<PetsBloc>().add(const PetsRefreshRequested()),
              ),
            );
          }

          if (petsState.isLoading || petsState.content == null) {
            return const _PetsScaffold(
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            );
          }

          return BlocBuilder<BookingBloc, BookingState>(
            builder: (context, bookingState) {
              if (bookingState.currentStep == BookingStep.service) {
                return _PetsScaffold(
                  child: BlocProvider(
                    create: (_) => getIt<BookingServiceSelectionBloc>()
                      ..add(
                        BookingServiceSelectionStarted(
                          petId: bookingState.selectedPetId,
                          preselectedServiceId: bookingState.serviceId,
                        ),
                      ),
                    child: const BookingServiceStepContent(),
                  ),
                );
              }

              if (bookingState.currentStep == BookingStep.appointment) {
                final petId = bookingState.selectedPetId;
                if (petId == null) {
                  return _PetsScaffold(
                    child: _BookingStepPlaceholder(step: bookingState.currentStep),
                  );
                }

                return _PetsScaffold(
                  child: BlocProvider(
                    create: (_) => getIt<BookingAppointmentBloc>()
                      ..add(
                        BookingAppointmentStarted(
                          petId: petId,
                          serviceIds: bookingState.selectedServiceIds,
                          totalVnd: bookingState.totalVnd,
                          initialDate: bookingState.selectedAppointmentDate,
                          initialTimeSlotId: bookingState.selectedTimeSlotId,
                        ),
                      ),
                    child: const BookingAppointmentStepContent(),
                  ),
                );
              }

              if (bookingState.currentStep == BookingStep.confirmation) {
                final petId = bookingState.selectedPetId;
                final date = bookingState.selectedAppointmentDate;
                final slotId = bookingState.selectedTimeSlotId;
                final slotLabel = bookingState.selectedTimeSlotLabel;

                if (petId == null ||
                    date == null ||
                    slotId == null ||
                    slotLabel == null) {
                  return _PetsScaffold(
                    child: _BookingStepPlaceholder(step: bookingState.currentStep),
                  );
                }

                return _PetsScaffold(
                  child: BlocProvider(
                    create: (_) => getIt<BookingConfirmationBloc>()
                      ..add(
                        BookingConfirmationStarted(
                          BookingConfirmationRequest(
                            petId: petId,
                            serviceIds: bookingState.selectedServiceIds,
                            appointmentDate: date,
                            timeSlotId: slotId,
                            timeSlotLabel: slotLabel,
                            totalVnd: bookingState.totalVnd,
                          ),
                        ),
                      ),
                    child: const BookingConfirmationStepContent(),
                  ),
                );
              }

              return _PetsScaffold(
                child: _BookingPetStepContent(content: petsState.content!),
              );
            },
          );
        },
      ),
    );
  }
}

class _PetsScaffold extends StatelessWidget {
  const _PetsScaffold({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3FAFC),

      body: SafeArea(child: child),
    );
  }
}

class _PetsErrorView extends StatelessWidget {
  const _PetsErrorView({required this.message, required this.onRetry});

  final String message;

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Text(
              message,

              textAlign: TextAlign.center,

              style: const TextStyle(color: AppColors.mutedText),
            ),

            const SizedBox(height: 16),

            FilledButton(onPressed: onRetry, child: const Text('Thử lại')),
          ],
        ),
      ),
    );
  }
}

class _BookingStepPlaceholder extends StatelessWidget {
  const _BookingStepPlaceholder({required this.step});

  final BookingStep step;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _BookingTopBar(onBack: () => context.pop()),

        BookingProgressStepper(currentStep: step),

        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),

              child: Text(
                'Bước ${step.stepIndex}: ${step.label} — đang phát triển.',

                textAlign: TextAlign.center,

                style: const TextStyle(
                  fontSize: 16,

                  color: AppColors.mutedText,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BookingPetStepContent extends StatelessWidget {
  const _BookingPetStepContent({required this.content});

  final MyPetsPageContent content;

  @override
  Widget build(BuildContext context) {
    final bookingBloc = context.read<BookingBloc>();

    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, bookingState) {
        final pets = bookingState.filteredPets(content.pets);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [
            _BookingTopBar(onBack: () => context.pop()),

            BookingProgressStepper(currentStep: bookingState.currentStep),

            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary,

                onRefresh: () async {
                  context.read<PetsBloc>().add(const PetsRefreshRequested());

                  await context.read<PetsBloc>().stream.firstWhere(
                    (state) =>
                        state.status == PetsStatus.success ||
                        state.status == PetsStatus.failure,
                  );
                },

                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),

                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            content.title,

                            style: const TextStyle(
                              fontSize: 22,

                              fontWeight: FontWeight.w800,

                              color: AppColors.brownText,
                            ),
                          ),
                        ),

                        TextButton.icon(
                          onPressed: () =>
                              bookingBloc.add(const BookingQuickAddPressed()),

                          icon: const Icon(
                            Icons.add_rounded,

                            size: 20,

                            color: AppColors.brown,
                          ),

                          label: const Text(
                            'Thêm mới',

                            style: TextStyle(
                              fontSize: 14,

                              fontWeight: FontWeight.w600,

                              color: AppColors.brown,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    _PetSearchField(
                      initialValue: bookingState.searchQuery,

                      onChanged: (query) =>
                          bookingBloc.add(BookingSearchQueryChanged(query)),
                    ),

                    const SizedBox(height: 16),

                    if (pets.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),

                        child: Text(
                          'Không tìm thấy thú cưng phù hợp.',

                          textAlign: TextAlign.center,

                          style: TextStyle(color: AppColors.mutedText),
                        ),
                      )
                    else
                      ...pets.map(
                        (pet) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),

                          child: _BookingPetCard(pet: pet),
                        ),
                      ),

                    _AddPetDashedCard(
                      title: content.addPetLabel,

                      onTap: () =>
                          bookingBloc.add(const BookingAddPetPressed()),

                      onFabTap: () =>
                          bookingBloc.add(const BookingQuickAddPressed()),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _BookingTopBar extends StatelessWidget {
  const _BookingTopBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 8, 0),

      child: Row(
        children: [
          IconButton(
            onPressed: onBack,

            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.brown,
            ),
          ),

          const Expanded(
            child: Text(
              'Đặt lịch hẹn',

              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 17,

                fontWeight: FontWeight.w700,

                color: AppColors.brownText,
              ),
            ),
          ),

          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _PetSearchField extends StatefulWidget {
  const _PetSearchField({required this.initialValue, required this.onChanged});

  final String initialValue;

  final ValueChanged<String> onChanged;

  @override
  State<_PetSearchField> createState() => _PetSearchFieldState();
}

class _PetSearchFieldState extends State<_PetSearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant _PetSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialValue != widget.initialValue &&
        _controller.text != widget.initialValue) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,

      onChanged: widget.onChanged,

      decoration: InputDecoration(
        hintText: 'Tìm kiếm thú cưng...',

        hintStyle: TextStyle(
          color: AppColors.mutedText.withValues(alpha: 0.85),

          fontSize: 14,
        ),

        prefixIcon: Icon(
          Icons.search_rounded,

          color: AppColors.mutedText.withValues(alpha: 0.85),
        ),

        filled: true,

        fillColor: const Color(0xFFF0F4F6),

        contentPadding: const EdgeInsets.symmetric(vertical: 14),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),

          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _BookingPetCard extends StatelessWidget {
  const _BookingPetCard({required this.pet});

  final Pet pet;

  @override
  Widget build(BuildContext context) {
    final bookingBloc = context.read<BookingBloc>();

    return Container(
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: AppColors.cardBg,

        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),

            blurRadius: 12,

            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Container(
                width: 72,

                height: 72,

                decoration: BoxDecoration(
                  color: PetsUiMapper.placeholderColor(
                    pet.imagePlaceholderColor,
                  ),

                  borderRadius: BorderRadius.circular(14),
                ),

                child: Icon(
                  Icons.pets_rounded,

                  size: 32,

                  color: AppColors.brownText.withValues(alpha: 0.35),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Align(
                      alignment: Alignment.centerRight,

                      child: _HealthStatusBadge(status: pet.healthStatus),
                    ),

                    Text(
                      pet.name,

                      style: const TextStyle(
                        fontSize: 17,

                        fontWeight: FontWeight.w800,

                        color: AppColors.brownText,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      pet.detailsLine,

                      style: const TextStyle(
                        fontSize: 13,

                        color: AppColors.mutedText,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        Icon(
                          Icons.event_outlined,

                          size: 14,

                          color: AppColors.mutedText.withValues(alpha: 0.9),
                        ),

                        const SizedBox(width: 6),

                        Expanded(
                          child: Text(
                            pet.reminderLabel,

                            style: const TextStyle(
                              fontSize: 12,

                              color: AppColors.mutedText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () =>
                      bookingBloc.add(BookingPetBookPressed(pet.id)),

                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,

                    foregroundColor: Colors.white,

                    padding: const EdgeInsets.symmetric(vertical: 14),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),

                    elevation: 0,
                  ),

                  child: const Text(
                    'Đặt lịch hẹn',

                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Material(
                color: const Color(0xFFF0F4F6),

                shape: const CircleBorder(),

                child: IconButton(
                  onPressed: () =>
                      bookingBloc.add(BookingPetMoreOptionsPressed(pet.id)),

                  icon: const Icon(Icons.more_horiz_rounded),

                  color: AppColors.brownText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HealthStatusBadge extends StatelessWidget {
  const _HealthStatusBadge({required this.status});

  final PetHealthStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (status) {
      PetHealthStatus.good => (
        'Sức khỏe tốt',

        const Color(0xFFE8F5E9),

        const Color(0xFF2E7D32),
      ),

      PetHealthStatus.needsRevisit => (
        'Cần tái khám',

        const Color(0xFFFFF3E0),

        const Color(0xFFE65100),
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),

      decoration: BoxDecoration(
        color: bg,

        borderRadius: BorderRadius.circular(20),
      ),

      child: Text(
        label,

        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }
}

class _AddPetDashedCard extends StatelessWidget {
  const _AddPetDashedCard({
    required this.title,

    required this.onTap,

    required this.onFabTap,
  });

  final String title;

  final VoidCallback onTap;

  final VoidCallback onFabTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,

      children: [
        GestureDetector(
          onTap: onTap,

          child: CustomPaint(
            painter: _DashedBorderPainter(
              color: AppColors.primary.withValues(alpha: 0.45),

              radius: 18,
            ),

            child: Container(
              width: double.infinity,

              padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),

              child: Column(
                children: [
                  Icon(
                    Icons.pets_rounded,

                    size: 36,

                    color: AppColors.brown.withValues(alpha: 0.55),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    title,

                    style: const TextStyle(
                      fontSize: 15,

                      fontWeight: FontWeight.w700,

                      color: AppColors.brownText,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Lưu giữ hồ sơ y tế cho tất cả thú cưng của bạn',

                    textAlign: TextAlign.center,

                    style: TextStyle(
                      fontSize: 12,

                      height: 1.4,

                      color: AppColors.brownText.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        Positioned(
          right: 12,

          bottom: -20,

          child: FloatingActionButton.small(
            onPressed: onFabTap,

            backgroundColor: AppColors.brown,

            elevation: 2,

            child: const Icon(Icons.add_rounded, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color, required this.radius});

  final Color color;

  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)),
      );

    const dashWidth = 6.0;

    const dashSpace = 4.0;

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;

      while (distance < metric.length) {
        final next = distance + dashWidth;

        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),

          paint,
        );

        distance = next + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
