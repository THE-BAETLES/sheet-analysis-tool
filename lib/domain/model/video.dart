class Video {
  final String id;
  final String thumbnailPath;
  final String title;
  final String genre;
  final String singer;
  final List<String> tags;
  final int length;
  final int difficultyAvg;
  final int playCount;
  final int sheetCount;
  final bool isInMyCollection;

  Video({
    required this.id,
    required this.thumbnailPath,
    required this.title,
    required this.genre,
    required this.singer,
    required this.tags,
    required this.length,
    required this.difficultyAvg,
    required this.playCount,
    required this.sheetCount,
    required this.isInMyCollection,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'],
      thumbnailPath: json['thumbnail_path'],
      title: json['title'],
      genre: json['genre'],
      singer: json['singer'],
      length: json['duration'],
      tags: json['tags'],
      difficultyAvg: json['difficulty_avg'],
      playCount: json['play_count'],
      sheetCount: json['sheet_count'],
      isInMyCollection: json['is_in_my_collection'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'thumbnail_path': thumbnailPath,
    'title': title,
    'genre': genre,
    'singer': singer,
    'duration': length,
    'difficulty_avg': difficultyAvg,
    'play_count': playCount,
    'sheet_count': sheetCount,
    'is_in_my_collection': isInMyCollection,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Video &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode =>
      id.hashCode;
}
