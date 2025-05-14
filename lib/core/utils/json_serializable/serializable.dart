abstract class Serializable {
  Map<String, dynamic> toJson();
  Serializable fromJson(Map<String, dynamic> json);
}
