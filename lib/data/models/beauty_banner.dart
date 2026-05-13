class BeautyBanner {
  const BeautyBanner({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.highlight,
  });

  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String highlight;

  factory BeautyBanner.fromMap(String id, Map<String, dynamic> map) {
    return BeautyBanner(
      id: id,
      title: map['title'] as String? ?? '',
      subtitle: map['subtitle'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
      highlight: map['highlight'] as String? ?? '',
    );
  }
}
