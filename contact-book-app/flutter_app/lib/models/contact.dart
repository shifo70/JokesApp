class Contact {
  final int id;
  final String fullName;
  final String phoneNumber;
  final String category;
  final bool isFavorite;
  final String displayTag;

  Contact({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.category,
    required this.isFavorite,
    required this.displayTag,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    final id = rawId is int ? rawId : int.parse(rawId.toString());

    return Contact(
      id: id,
      fullName: json['full_name']?.toString() ?? '',
      phoneNumber: json['phone_number']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      isFavorite: json['is_favorite'] == true ||
          json['is_favorite'] == 1 ||
          json['is_favorite']?.toString() == '1',
      displayTag: json['display_tag']?.toString() ??
          json['category']?.toString() ??
          '',
    );
  }
}
