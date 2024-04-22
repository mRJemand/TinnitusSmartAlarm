class Stimuli {
  String? id;
  String? displayName;
  String? filename;
  int? categoryId;
  String? categoryName;
  bool? hasSpecialFrequency;
  String? frequency;
  String? filepath;
  bool? isIndividual;

  Stimuli(
      {this.id,
      this.displayName,
      this.filename,
      this.categoryId,
      this.categoryName,
      this.hasSpecialFrequency,
      this.frequency,
      this.filepath,
      this.isIndividual});

  Stimuli.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    displayName = json['displayName'];
    filename = json['filename'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    hasSpecialFrequency = json['has_speacial_frequency'];
    frequency = json['frequency'];
    filepath = json['filepath'];
    isIndividual = json['isIndividual'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['displayName'] = displayName;
    data['filename'] = filename;
    data['category_id'] = categoryId;
    data['category_name'] = categoryName;
    data['has_speacial_frequency'] = hasSpecialFrequency;
    data['frequency'] = frequency;
    data['filepath'] = filepath;
    data['isIndividual'] = isIndividual;
    return data;
  }
}
