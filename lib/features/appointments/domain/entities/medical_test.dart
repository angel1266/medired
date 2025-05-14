import 'package:medired/core/core_export.dart';
import 'package:medired/core/value_objects/medical_test_type.dart';
import 'package:medired/features/appointments/data/models/medical_test_model.dart';

class MedicalTest extends Equatable {
  final String id;
  final String name;
  final MedicalTestType category;
  final String description;
  final String durationDescription;

  const MedicalTest({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.durationDescription,
  });

  factory MedicalTest.toEntity(MedicalTestModel medicalTestModel) {
    return MedicalTestModel(
      id: medicalTestModel.id,
      name: medicalTestModel.name,
      category: medicalTestModel.category,
      description: medicalTestModel.description,
      durationDescription: medicalTestModel.durationDescription,
    );
  }

  MedicalTest copyWith({
    String? id,
    String? name,
    MedicalTestType? category,
    String? description,
    String? durationDescription,
  }) =>
      MedicalTest(
        id: id ?? this.id,
        name: name ?? this.name,
        category: category ?? this.category,
        description: description ?? this.description,
        durationDescription: durationDescription ?? this.durationDescription,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        category,
        description,
        durationDescription,
      ];
}
