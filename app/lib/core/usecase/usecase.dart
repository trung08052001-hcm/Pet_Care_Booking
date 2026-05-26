import 'package:app/core/common/typedefs.dart';
import 'package:equatable/equatable.dart';

abstract interface class UseCase<Output, Params> {
  ResultFuture<Output> call(Params params);
}

class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => const [];
}
