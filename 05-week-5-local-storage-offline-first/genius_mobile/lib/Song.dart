class Song {
  final String title;
  final String artist;
  final String lyrics;
  final String img;
  final String audioPath; // Relative path: assets/audio/xxx.mp3 => use audio/xxx.mp3

  Song({
    required this.title,
    required this.artist,
    required this.lyrics,
    required this.img,
    required this.audioPath,
  });
}