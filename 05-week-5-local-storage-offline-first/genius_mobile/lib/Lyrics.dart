import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:audioplayers/audioplayers.dart';
import 'Song.dart';

class Lyrics extends StatefulWidget {
  final Song? initialSong;

  const Lyrics({super.key, this.initialSong});

  @override
  State<Lyrics> createState() => _LyricsState();
}

class _LyricsState extends State<Lyrics> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;

  final List<Song> playlist = [
    Song(
      title: 'Untungnya, Hidup Harus Tetap Berjalan',
      artist: 'Bernadya',
      img: 'assets/images/untungnya_hidup_harus_tetap_berjalan.png',
      lyrics: 'Ringkasan lirik lagu...',
      audioPath: 'audio/bernadya_untungnya.mp3',
    ),
    Song(
      title: 'Satu Bulan',
      artist: 'Bernadya',
      img: 'assets/images/satu_bulan.png',
      lyrics: 'Ringkasan lirik lagu...',
      audioPath: 'audio/bernadya_satu_bulan.mp3',
    ),
    Song(
      title: 'WILDFLOWER',
      artist: 'Billie Eilish',
      img: 'assets/images/wildflower.png',
      lyrics: 'Ringkasan lirik lagu...',
      audioPath: 'audio/billie_wildflower.mp3',
    ),
  ];

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    if (widget.initialSong != null) {
      currentIndex = playlist.indexWhere((song) => song.title == widget.initialSong!.title);
      if (currentIndex == -1) currentIndex = 0;
    }

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void togglePlay() async {
    final song = playlist[currentIndex];
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(AssetSource(song.audioPath));
    }
  }

  void _goToPreviousSong() {
    setState(() {
      currentIndex = (currentIndex - 1 + playlist.length) % playlist.length;
    });
    _audioPlayer.stop();
    isPlaying = false;
  }

  void _goToNextSong() {
    setState(() {
      currentIndex = (currentIndex + 1) % playlist.length;
    });
    _audioPlayer.stop();
    isPlaying = false;
  }

  @override
  Widget build(BuildContext context) {
    final song = playlist[currentIndex];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
          onPressed: () {
            _audioPlayer.stop();
            context.go('/');
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  song.img,
                  width: 260,
                  height: 260,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                song.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                song.artist,
                style: const TextStyle(fontSize: 15, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              // Tombol kontrol pemutar (Play/Pause)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous, color: Colors.white, size: 36),
                    onPressed: _goToPreviousSong,
                  ),
                  const SizedBox(width: 20),
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: IconButton(
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.black,
                        size: 32,
                      ),
                      onPressed: togglePlay, // Menjalankan fungsi audio
                    ),
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const Icon(Icons.skip_next, color: Colors.white, size: 36),
                    onPressed: _goToNextSong,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    song.lyrics,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}