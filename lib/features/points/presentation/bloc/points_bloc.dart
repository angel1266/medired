import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medired/core/value_objects/medical_specialization.dart';
import 'package:medired/core/value_objects/service_type.dart';
import 'package:medired/features/appointments/domain/entities/medical_test.dart';
import 'package:medired/features/authentication/domain/entities/patient.dart';
import 'package:medired/features/points/domain/usecases/save_points.dart';
import 'package:medired/features/subscription/domain/usecases/get_active_subscriptions.dart';

part 'points_event.dart';
part 'points_state.dart';

class PointsBloc extends Bloc<PointsEvent, PointsState> {
  final GetActiveSubscriptionsUseCase _getActiveSubscriptionsUseCase;
  final SavePointsUseCase _savePointsUseCase;

  PointsBloc(
    this._getActiveSubscriptionsUseCase,
    this._savePointsUseCase,
  ) : super(PointsInitial()) {
    on<GetActiveSubscriptions>(_getActiveSubscriptions);
    on<SelectPatient>(_selectPatient);
    on<SelectTest>(_selectTest);
    on<SelectSpecialization>(_selectSpecialization);
    on<SelectServiceType>(_selectServiceType);
    on<SavePoints>(_savePoints);
  }

  void _getActiveSubscriptions(
      GetActiveSubscriptions event, Emitter<PointsState> emit) async {
    emit(LoadingGetActiveSubscriptions());
    final result = await _getActiveSubscriptionsUseCase.call();
    result.fold(
      (l) => emit(ErrorGetActiveSubscriptions(l)),
      (r) => emit(SuccessGetActiveSubscriptions(patients: r)),
    );
  }

  void _selectPatient(SelectPatient event, Emitter<PointsState> emit) {
    emit(SuccessSelectedPatient(
        patient: event.patient, patients: event.patients));
  }

  void _selectTest(SelectTest event, Emitter<PointsState> emit) {
    emit(SuccessSelectedTest(test: event.test, patients: event.patients));
  }

  void _selectSpecialization(
      SelectSpecialization event, Emitter<PointsState> emit) {
    emit(SuccessSelectedSpecialization(
        specialization: event.specialization, patients: event.patients));
  }

  void _selectServiceType(SelectServiceType event, Emitter<PointsState> emit) {
    emit(SuccessSelectedServiceType(
        serviceType: event.serviceType, patients: event.patients));
  }

  Future<void> _savePoints(SavePoints event, Emitter<PointsState> emit) async {
    emit(LoadingSavePoints());
    var result = await _savePointsUseCase.execute(event.uid, event.amount);
    result.fold(
      (l) => emit(ErrorSavePoints(l)),
      (r) => emit(const SuccessSavePoints()),
    );
  }
}
