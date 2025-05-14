import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medired/features/appointments/domain/entities/medical_test.dart';
import 'package:medired/features/appointments/domain/usecases/get_remote_medical_tests.dart';

part 'medical_tests_event.dart';
part 'medical_tests_state.dart';

class MedicalTestsBloc extends Bloc<MedicalTestsEvent, MedicalTestsState> {
  final GetRemoteMedicalTestsUseCase _getRemoteMedicalTests;

  MedicalTestsBloc(this._getRemoteMedicalTests)
      : super(UnloadedMedicalTests()) {
    on<GetMedicalTests>(_onGetMedicalTests);
  }

  void _onGetMedicalTests(
      GetMedicalTests event, Emitter<MedicalTestsState> emit) async {
    emit(LoadingMedicalTests());
    var result = await _getRemoteMedicalTests.call();
    result.fold(
      (l) => emit(ErrorGetMedicalTests(l)),
      (r) => emit(SuccessGetMedicalTests(medicalTests: r)),
    );
  }
}
