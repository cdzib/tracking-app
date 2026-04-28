class BookingSeat {
  BookingSeat({
    required this.seat,
    required this.qr,
  });

  final int seat;
  final String qr;

  factory BookingSeat.fromJson(Map<String, dynamic> json) {
    return BookingSeat(
      seat: json['seat'] as int,
      qr: json['qr']?.toString() ?? '',
    );
  }
}
