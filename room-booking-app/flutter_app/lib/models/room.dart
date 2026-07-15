class Room {
  final int id;
  final String name;
  final double price;
  final String status;

  Room({
    required this.id,
    required this.name,
    required this.price,
    required this.status,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] as int,
      name: json['name'] as String,
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : (json['price'] as num).toDouble(),
      status: json['status'] as String,
    );
  }

  bool get isAvailable => status == 'available';
}
