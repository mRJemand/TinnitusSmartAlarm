class Stimuli {
  int? id;
  String? filename;
  int? categoryId;
  String? categoryName;
  bool? hasSpecialFrequency;
  int? frequency;

  Stimuli(
      {this.id,
      this.filename,
      this.categoryId,
      this.categoryName,
      this.hasSpecialFrequency,
      this.frequency});

  Stimuli.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    filename = json['filename'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    hasSpecialFrequency = json['has_speacial_frequency'];
    frequency = json['frequency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['filename'] = filename;
    data['category_id'] = categoryId;
    data['category_name'] = categoryName;
    data['has_speacial_frequency'] = hasSpecialFrequency;
    data['frequency'] = frequency;
    return data;
  }
}
