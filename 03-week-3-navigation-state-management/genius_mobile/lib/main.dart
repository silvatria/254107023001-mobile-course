import 'package:flutter/material.dart';
import 'Song.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Genius Mobile',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Genius Mobile'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

var song = Song(
    title: 'Untungnya, Hidup Harus Tetap Berjalan',
    artist: 'Bernadya',
    img: 'assets/images/untungnya_hidup_harus_tetap_berjalan.png',
    lyrics: '''
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
);

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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('\n${song.title}\n', style: TextStyle(fontWeight: FontWeight.bold)),
            ClipRRect(borderRadius: BorderRadius.circular(150), child: Image.asset(song.img, width: 150, height: 150)),
            Text('${song.artist} \n', style: TextStyle(fontStyle: FontStyle.italic)),
            Expanded(
                child: SingleChildScrollView(
                child: Text(song.lyrics),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
