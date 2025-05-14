import 'package:json_annotation/json_annotation.dart';
import 'package:medired/core/value_objects/medical_test_type.dart';
import 'package:medired/features/appointments/domain/entities/medical_test.dart';

part 'medical_test_model.g.dart';

@JsonSerializable(explicitToJson: true)
class MedicalTestModel extends MedicalTest {
  const MedicalTestModel({
    required super.id,
    required super.name,
    required super.category,
    required super.description,
    required super.durationDescription,
  });

  factory MedicalTestModel.fromEntity(MedicalTest medicalTest) {
    return MedicalTestModel(
      id: medicalTest.id,
      name: medicalTest.name,
      category: medicalTest.category,
      description: medicalTest.description,
      durationDescription: medicalTest.durationDescription,
    );
  }

  factory MedicalTestModel.fromJson(Map<String, dynamic> json) =>
      _$MedicalTestModelFromJson(json);

  Map<String, dynamic> toJson() => _$MedicalTestModelToJson(this);
}
