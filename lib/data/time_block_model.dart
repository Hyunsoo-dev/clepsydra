class TimeBlockModel {
  final String id;
  final int seconds;
  final DateTime createdAt;
  final DateTime updatedAt;

  TimeBlockModel({
    required this.id,
    required this.seconds,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TimeBlockModel.fromJson(Map<String, dynamic> json) {
    return TimeBlockModel(
      id: json['id'].toString(),
      seconds: json['seconds'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  @override
  String toString() {
    return 'TimeBlockModel(id: $id, seconds: $seconds, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}