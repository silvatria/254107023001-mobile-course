import 'package:flutter/material.dart';
import 'Song.dart';
import 'Lyrics.dart';

class Beranda extends StatelessWidget {
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> playlist = [
    {
      'title': 'Untungnya, Hidup Harus Tetap Berjalan',
      'artist': 'Bernadya',
      'img': 'assets/images/untungnya_hidup_harus_tetap_berjalan.png',
      'lyrics': '''
        [Verse 1]
        Persis setahun yang lalu ku dijauhkan dari yang tak
        Ditakdirkan untukku
        Yang kuingat saat itu, yang kulakukan hanya menggerutu
        Angkuh
        Lebih percaya cara-caraku, pilih ragukan rencana Sang Maha Penentu

        [Chorus]
        Untungnya bumi masih berputar
        Untungnya ku tak pilih menyerah
        Untungnya ku bisa rasa hal-hal baik yang datangnya
        Belakangan

        [Bridge]
        Ada waktu-waktu
        Hal buruk datang berturut-turut
        Semua yang tinggal juga yang hilang, seberapa pun absurdnya
        Pasti ada makna

        [Instrumental]

        [Chorus]
        Untungnya bumi masih berputar
        Untungnya ku tak pilih menyerah
        Itu memang paling mudah, untungnya kupilih
        Yang lebih susah
        Untungnya kupakai akal sehat
        Untungnya hidup terus berjalan
        Untungnya ku bisa rasa hal-hal baik yang datangnya
        Belakangan

        [Outro]
        Untungnya, untungnya
        Hidup harus tetap berjalan''',
    },
    {
      'title': 'Satu Bulan',
      'artist': 'Bernadya',
      'img': 'assets/images/satu_bulan.png',
      'lyrics': '''
        [Verse 1]
        Belum ada satu bulan
        Ku yakin masih ada sisa wangiku di bajumu
        Namun kau tampak baik saja
        Bahkan senyummu lebih lepas
        Sedang aku di sini hampir gila

        [Verse 2]
        Kita tak temukan jalan
        Sepakat akhiri setelah beribu debat panjang
        Namun kau tampak baik saja
        Bahkan senyummu lebih lepas
        Sedang aku di sini belum terima

        [Pre-Chorus]
        Bohongkah tangismu sore itu di pelukku?
        Nyatanya pergiku pun tak lagi mengganggumu
        Apa sudah ada kabar lain yang kau tunggu?

        [Chorus]
        Sudah adakah yang gantikanku
        Yang khawatirkanmu setiap waktu
        Yang cerita tentang apapun sampai hal-hal tak perlu?
        Kalau bisa jangan buru-buru
        Kalau bisa jangan ada dulu''',
    },
    {
      'title': 'WILDFLOWER',
      'artist': 'Billie Eilish',
      'img': 'assets/images/wildflower.png',
      'lyrics': '''
        [Verse 1]
        Things fall apart, and time breaks your heart
        I wasn't there, but I know
        She was your girl, you showed her the world
        But fell out of love and you both let go

        [Pre-Chorus]
        She was cryin’ on my shoulder, all I could do was hold her
        Only made us closer until July
        Now, I know that you love me, you don't need to remind me
        I should put it all behind me, shouldn't I?

        [Chorus]
        But I see her in the back of my mind all the time
        Like a fever, like I’m burning alive, like a sign
        Did I cross the line?

        [Post-Chorus]
        (Mm) Hmm

        [Verse 2]
        Well, good things don't last (Good things don't last)
        And life moves so fast (Life moves so fast)
        I'd never ask who was better (I'd never ask who was better)
        'Cause she couldn't be (Couldn't)
        More different from me (Different)
        Happy and free in leather (Happy in leather)

        [Pre-Chorus]
        And I know that you love me (You love me)
        You don’t need to remind me (Remind me)
        Wanna put it all behind me, but baby

        [Chorus]
        I see her in the back of my mind (Back of my mind) all the time (All the time)
        Feels like a fever (Like a fever), like I’m burning alive (Burning alive), like a sign
        Did I cross the line?

        [Bridge]
        You say no one knows you so well (Oh)
        But every time you touch me, I just wonder how she felt
        Valentine's Day, cryin’ in the hotel
        I know you didn't mean to hurt me, so I kept it to myself

        [Chorus]
        And I wonder
        Do you see her in the back of your mind in my eyes?

        [Outro]
        You say no one knows you so well
        But every time you touch me, I just wonder how she felt
        Valentine's Day, cryin' in the hotel
        I know you didnt mean to hurt me, so I kept it to myself''',
    },
  ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Genius Mobile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to Genius Mobile!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the lyrics page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Beranda()),
                );
              },
              child: Text('View Lyrics'),
            ),
          ],
        ),
      ),
    );
  }
  
  // This widget is the root of your application.

}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late AnimationController _controller;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
       
      //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      //   title: Text(widget.title),
      // ),
      body: Center(
        child: Column(
          children: [
            Text('\n${song.title}\n', style: TextStyle(fontWeight: FontWeight.bold)),
            ClipRRect(borderRadius: BorderRadius.circular(0), child: Image.asset(song.img, width: 150, height: 150)),
            Text('${song.artist} \n', style: TextStyle(fontStyle: FontStyle.italic)),
            Expanded(
                child: SingleChildScrollView(
                child: Text(song.lyrics),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_music),
          label: 'Library',
        ),
      ],
      )
    );
  }
}
