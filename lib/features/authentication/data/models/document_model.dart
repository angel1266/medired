import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:medired/core/utils/json_serializable/time_stamp_converter.dart';
import 'package:medired/core/value_objects/country.dart';
import 'package:medired/core/value_objects/document_type.dart';
import 'package:medired/features/authentication/domain/entities/authentication_entities.dart';

part 'document_model.g.dart';

@JsonSerializable(explicitToJson: true)
class DocumentModel extends Document {
  @TimestampConverter()
  @override
  DateTime get expirationDate => super.expirationDate;

  set expirationDate(DateTime value) {
    super.copyWith(expirationDate: value);
  }

  const DocumentModel({
    required super.value,
    required super.country,
    required super.documentType,
    required super.expirationDate,
    super.photos,
  });

  factory DocumentModel.fromEntity(Document document) {
    return DocumentModel(
      value: document.value,
      country: document.country,
      documentType: document.documentType,
      expirationDate: document.expirationDate,
      photos: document.photos,
    );
  }

  factory DocumentModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DocumentModelToJson(this);
}
