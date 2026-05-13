class BeautyCategory {
  const BeautyCategory({
    required this.id,
    required this.name,
    required this.icon,
  });

  final String id;
  final String name;
  final String icon;

  factory BeautyCategory.fromMap(String id, Map<String, dynamic> map) {
    return BeautyCategory(
      id: id,
      name: map['name'] as String? ?? '',
      icon: map['icon'] as String? ?? '',
    );
  }
}
