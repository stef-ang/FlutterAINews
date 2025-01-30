class Article {
  final String title;
  final String? description;
  final String date;
  final String? imageUrl;
  final String? url;

  Article({
    required this.title,
    this.description,
    required this.date,
    this.imageUrl,
    this.url,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
        title: json['title'] ?? 'No Title',
        description: json['description'],
        date: json['publishedAt'] ?? '',
        imageUrl: json['urlToImage'],
        url: json['url']);
  }
}
