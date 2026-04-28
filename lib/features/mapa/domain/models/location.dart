class Location {
  double? latitude;
  double? longitude;
  double? speed;
  int? altitude;
  int? course;
  String? direction;
  String? recordedAt;
  bool? isMoving;

  Location(
      {this.latitude,
      this.longitude,
      this.speed,
      this.altitude,
      this.course,
      this.direction,
      this.recordedAt,
      this.isMoving});

  Location.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'] != null ? (json['latitude'] as num).toDouble() : null;
    longitude = json['longitude'] != null ? (json['longitude'] as num).toDouble() : null;
    speed = json['speed'] != null ? (json['speed'] as num).toDouble() : null;
    altitude = json['altitude'] ?? 0;
    course = json['course'] ?? 0;
    direction = json['direction'] ?? '';
    recordedAt = json['recorded_at'] ?? '';
    isMoving = json['is_moving'] ?? false;
      accuracy = json['accuracy'] != null ? (json['accuracy'] as num).toDouble() : null;
      satellites = json['satellites'] ?? 0;
      humanTime = json['human_time'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['speed'] = this.speed;
    data['altitude'] = this.altitude;
    data['course'] = this.course;
    data['direction'] = this.direction;
    data['recorded_at'] = this.recordedAt;
    data['is_moving'] = this.isMoving;
      data['accuracy'] = accuracy;
      data['satellites'] = satellites;
      data['human_time'] = humanTime;
    return data;
  }
    double? accuracy;
    int? satellites;
    String? humanTime;
}