import 'package:json_annotation/json_annotation.dart';

class DateTimeConverter implements JsonConverter<DateTime, DateTime> {
  const DateTimeConverter();

  @override
  DateTime fromJson(DateTime json) => json;

  @override
  DateTime toJson(DateTime object) => object;
}