class Battery {
  final int? level;
  final String? status;
  final String? icon;

  Battery({this.level, this.status, this.icon});

  factory Battery.fromJson(Map<String, dynamic> json) {
    return Battery(
      level: json['level'],
      status: json['status'],
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() => {
        'level': level,
        'status': status,
        'icon': icon,
      };
}
