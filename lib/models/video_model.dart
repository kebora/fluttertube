class Video {
  // final String id;
  final String url;
  final String title;
  final String thumbnailUrl;
  final String channelTitle;

  Video({
    // this.id,
    required this.url,
    required this.title,
    required this.channelTitle,
    required this.thumbnailUrl,
  });

  factory Video.fromMap(Map<String, dynamic> snippet) {
    return Video(
      // id: snippet['id'],
      url: snippet['resourceId']['videoId'],
      title: snippet['title'],
      thumbnailUrl: snippet['thumbnails']['high']['url'],
      channelTitle: snippet['channelTitle'],
    );
  }
}
