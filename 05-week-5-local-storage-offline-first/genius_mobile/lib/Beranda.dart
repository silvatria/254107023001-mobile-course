import 'package:flutter/material.dart';
import 'Lyrics.dart';
import 'Song.dart';

void main() {
  runApp(const YouTubeMusicApp());
}

class YouTubeMusicApp extends StatelessWidget {
  const YouTubeMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube Music Replica',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.red,
        colorScheme: const ColorScheme.dark(
          primary: Colors.red,
          surface: Colors.black,
        ),
      ),
      home: const Beranda(),
    );
  }
}

class Beranda extends StatelessWidget {
  const Beranda({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> playlist = [
      {
        'title': 'Untungnya, Hidup Harus Tetap Berjalan',
        'artist': 'Bernadya',
        'img': 'assets/images/untungnya_hidup_harus_tetap_berjalan.png',
        'lyrics': '''[Verse 1]
Persis setahun yang lalu ku dijauhkan dari yang tak
Ditakdirkan untukku...''',
      },
      {
        'title': 'Satu Bulan',
        'artist': 'Bernadya',
        'img': 'assets/images/satu_bulan.png',
        'lyrics': '''[Verse 1]
Belum ada satu bulan
Ku yakin masih ada sisa wangiku di bajumu...''',
      },
      {
        'title': 'WILDFLOWER',
        'artist': 'Billie Eilish',
        'img': 'assets/images/wildflower.png',
        'lyrics': '''[Verse 1]
Things fall apart, and time breaks your heart
I wasn't there, but I know...''',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            const Icon(Icons.play_circle_fill, color: Colors.red, size: 28),
            const SizedBox(width: 8),
            const Text('Music', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.cast), onPressed: () {}),
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: CircleAvatar(
              backgroundColor: Colors.green,
              radius: 14,
              child: Text('G', style: TextStyle(color: Colors.white, fontSize: 14)),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12.0),
        children: [
          const Text(
            'Quick picks',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: playlist.length,
            itemBuilder: (context, index) {
              final song = playlist[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 4),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey[800],
                    child: const Icon(Icons.music_note, color: Colors.white54), // Ganti Image.asset jika asset sudah ada
                  ),
                ),
                title: Text(
                  song['title'],
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  song['artist'],
                  style: const TextStyle(color: Colors.grey),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.white54),
                  onPressed: () {},
                ),
                onTap: () {
                  final selectedSong = Song(
                    title: song['title'],
                    artist: song['artist'],
                    lyrics: song['lyrics'],
                    img: song['img'],
                    audioPath: _audioPathForTitle(song['title']),
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Lyrics(initialSong: selectedSong),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), label: 'Samples'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.library_music), label: 'Library'),
        ],
      ),
    );
  }
}

String _audioPathForTitle(String title) {
  switch (title) {
    case 'Untungnya, Hidup Harus Tetap Berjalan':
      return 'audio/bernadya_untungnya.mp3';
    case 'Satu Bulan':
      return 'audio/bernadya_satu_bulan.mp3';
    case 'WILDFLOWER':
      return 'audio/billie_wildflower.mp3';
    default:
      return 'audio/bernadya_untungnya.mp3';
  }
}

class DetailPlayerPage extends StatelessWidget {
  final Map<String, dynamic> song;

  const DetailPlayerPage({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 280,
                height: 280,
                color: Colors.grey[800],
                child: const Icon(Icons.music_note, size: 80, color: Colors.white54),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        song['title'],
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        song['artist'],
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.thumb_up_outlined, color: Colors.white),
                const SizedBox(width: 16),
                const Icon(Icons.thumb_down_outlined, color: Colors.white),
              ],
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: 0.4,
              backgroundColor: Colors.grey[800],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('3:58', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Text('4:48', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(Icons.shuffle, color: Colors.white, size: 28),
                const Icon(Icons.skip_previous, color: Colors.white, size: 36),
                Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle, 
                      color: Colors.white,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.play_arrow, color: Colors.black, size: 32),
                      onPressed: () {
                      },
                    ),
                  ),
                const Icon(Icons.skip_next, color: Colors.white, size: 36),
                const Icon(Icons.repeat, color: Colors.white, size: 28),
              ],
            ),
          ],
        ),
      ),
    );
  }
}