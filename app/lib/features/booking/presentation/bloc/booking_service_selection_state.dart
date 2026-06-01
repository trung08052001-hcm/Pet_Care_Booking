import 'package:app/features/booking/domain/entities/bookable_service.dart';
import 'package:app/features/booking/domain/entities/booking_service_page_content.dart';
import 'package:equatable/equatable.dart';

enum BookingServiceSelectionStatus {
  initial,
  loading,
  success,
  failure,
}

class BookingServiceSelectionState extends Equatable {
  const BookingServiceSelectionState({
    this.status = BookingServiceSelectionStatus.initial,
    this.content,
    this.petId,
    this.selectedServiceIds = const {},
    this.totalVnd = 0,
    this.message,
  });

  final BookingServiceSelectionStatus status;
  final BookingServicePageContent? content;
  final String? petId;
  final Set<String> selectedServiceIds;
  final int totalVnd;
  final String? message;

  bool get isLoading =>
      status == BookingServiceSelectionStatus.loading ||
      status == BookingServiceSelectionStatus.initial;

  bool get canContinue => selectedServiceIds.isNotEmpty;

  List<BookableService> get selectedServices {
    final content = this.content;
    if (content == null) {
      return const [];
    }
    return content.services
        .where((service) => selectedServiceIds.contains(service.id))
        .toList(growable: false);
  }

  BookingServiceSelectionState copyWith({
    BookingServiceSelectionStatus? status,
    BookingServicePageContent? content,
    String? petId,
    Set<String>? selectedServiceIds,
    int? totalVnd,
    String? message,
    bool clearMessage = false,
  }) {
    return BookingServiceSelectionState(
      status: status ?? this.status,
      content: content ?? this.content,
      petId: petId ?? this.petId,
      selectedServiceIds: selectedServiceIds ?? this.selectedServiceIds,
      totalVnd: totalVnd ?? this.totalVnd,
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  @override
  List<Object?> get props => [
        status,
        content,
        petId,
        selectedServiceIds,
        totalVnd,
        message,
      ];
}
