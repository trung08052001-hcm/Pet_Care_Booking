import 'package:equatable/equatable.dart';

class HomeWelcome extends Equatable {
  const HomeWelcome({
    required this.greeting,
    required this.title,
    required this.bookCtaLabel,
    this.petName,
  });

  final String greeting;
  final String title;
  final String bookCtaLabel;
  final String? petName;

  @override
  List<Object?> get props => [greeting, title, bookCtaLabel, petName];
}
