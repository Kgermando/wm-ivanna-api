class UpdateModel {
  late int? id;
  late String version;
  late String urlUpdate;
  late DateTime created;
  late String isActive;
  late String motif;
  late String business;

  UpdateModel(
      {this.id,
      required this.version,
      required this.urlUpdate,
      required this.created,
      required this.isActive,
      required this.motif,
      required this.business});

  factory UpdateModel.fromSQL(List<dynamic> row) {
    return UpdateModel(
        id: row[0],
        version: row[1],
        urlUpdate: row[2],
        created: row[3],
        isActive: row[4],
        motif: row[5],
        business: row[6]);
  }

  factory UpdateModel.fromJson(Map<String, dynamic> json) {
    return UpdateModel(
      id: json['id'],
      version: json['version'],
      urlUpdate: json['urlUpdate'],
      created: DateTime.parse(json['created']),
      isActive: json['isActive'],
      motif: json['motif'],
      business: json['business'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'version': version,
      'urlUpdate': urlUpdate,
      'created': created.toIso8601String(),
      'isActive': isActive,
      'motif': motif,
      'business': business,
    };
  }
}
