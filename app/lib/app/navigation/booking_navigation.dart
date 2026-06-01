import 'package:app/features/booking/presentation/pages/booking_detail_page.dart';
import 'package:app/features/pets/domain/entities/booking_flow_args.dart';
import 'package:app/features/pets/presentation/pages/my_pets_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void openBookingPetSelection(
  BuildContext context, {
  String? serviceId,
}) {
  context.pushNamed(
    MyPetsPage.routeName,
    extra: serviceId == null ? null : BookingFlowArgs(serviceId: serviceId),
  );
}

void openBookingDetail(BuildContext context, {required String bookingId}) {
  context.goNamed(
    BookingDetailPage.routeName,
    pathParameters: {'bookingId': bookingId},
  );
}
