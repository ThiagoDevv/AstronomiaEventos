class AstronomyEvent {
  final String title;
  final String description;
  final String imageUrl;
  final DateTime date;

  AstronomyEvent({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.date,
  });

  factory AstronomyEvent.fromJson(Map<String, dynamic> json) {
    return AstronomyEvent(
      title: json['title'] ?? 'Título não disponível',
      description: json['explanation'] ?? 'Descrição não disponível',
      imageUrl: json['url'] ?? '',
      date: DateTime.parse(json['date']),
    );
  }
}
