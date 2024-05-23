import 'dart:convert';

List<Tip> tipFromJson(String str) =>
    List<Tip>.from(json.decode(str).map((x) => Tip.fromJson(x)));

String tipToJson(List<Tip> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Tip {
  final int id;
  final dynamic key;
  final String title;
  final String objective;
  final String tip;
  final String explanation;
  final String language;
  bool? isFavorite;

  Tip({
    required this.id,
    required this.key,
    required this.title,
    required this.objective,
    required this.tip,
    required this.explanation,
    required this.language,
    isFavorite = false,
  });

  factory Tip.fromJson(Map<String, dynamic> json) => Tip(
        id: json["id"],
        key: json["key"],
        title: json["title"],
        objective: json["objective"],
        tip: json["tip"],
        explanation: json["explanation"],
        language: json["language"]!,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "key": key,
        "title": title,
        "objective": objective,
        "tip": tip,
        "explanation": explanation,
        "language": language,
      };
}

enum Language { DE, ENG }

final languageValues = EnumValues({"de": Language.DE, "eng": Language.ENG});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
