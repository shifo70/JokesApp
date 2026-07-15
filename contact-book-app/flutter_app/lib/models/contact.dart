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
    return Contact(
      id: json['id'] as int,
      fullName: json['full_name'] as String,
      phoneNumber: json['phone_number'] as String,
      category: json['category'] as String,
      isFavorite: json['is_favorite'] == true || json['is_favorite'] == 1,
      displayTag: json['display_tag'] as String? ?? json['category'] as String,
    );
  }
}
