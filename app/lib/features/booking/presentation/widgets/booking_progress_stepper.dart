import 'package:app/app/theme/app_colors.dart';
import 'package:app/features/booking/domain/entities/booking_step.dart';
import 'package:flutter/material.dart';

class BookingProgressStepper extends StatelessWidget {
  const BookingProgressStepper({super.key, required this.currentStep});

  final BookingStep currentStep;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Row(
        children: [
          for (var i = 0; i < BookingStep.flow.length; i++) ...[
            if (i > 0)
              Expanded(
                child: _ConnectorLine(
                  isActive:
                      BookingStep.flow[i - 1].stepIndex < currentStep.stepIndex,
                ),
              ),
            _StepNode(
              step: BookingStep.flow[i],
              isCompleted:
                  BookingStep.flow[i].stepIndex < currentStep.stepIndex,
              isActive: BookingStep.flow[i] == currentStep,
            ),
          ],
        ],
      ),
    );
  }
}

class _StepNode extends StatelessWidget {
  const _StepNode({
    required this.step,
    required this.isCompleted,
    required this.isActive,
  });

  final BookingStep step;
  final bool isCompleted;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final circleColor = isCompleted
        ? AppColors.brown
        : isActive
            ? AppColors.primary
            : const Color(0xFFE8ECEF);
    final labelColor = isCompleted || isActive
        ? AppColors.brownText
        : const Color(0xFF9AA3A8);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: circleColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check_rounded, size: 18, color: Colors.white)
                : Text(
                    '${step.stepIndex}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isActive ? Colors.white : const Color(0xFF9AA3A8),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          step.label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isCompleted || isActive
                ? FontWeight.w700
                : FontWeight.w500,
            color: labelColor,
          ),
        ),
      ],
    );
  }
}

class _ConnectorLine extends StatelessWidget {
  const _ConnectorLine({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      margin: const EdgeInsets.only(bottom: 22),
      color: isActive
          ? AppColors.brown.withValues(alpha: 0.35)
          : const Color(0xFFE0E4E8),
    );
  }
}
