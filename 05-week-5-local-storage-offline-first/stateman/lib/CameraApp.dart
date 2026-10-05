import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    _cameras = await availableCameras();
  } catch (e) {
    debugPrint("Gagal memuat daftar kamera: $e");
  }
  runApp(const CameraApp());
}

class CameraApp extends StatefulWidget {
  const CameraApp({super.key});

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late CameraController controller;
  bool isTakingPicture = false;
  String statusMessage = "Kamera Siap";

  @override
  void initState() {
    super.initState();
    controller = CameraController(_cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {
        statusMessage = "Kamera Terinisialisasi";
      });
    }).catchError((Object e) {
      if (e is CameraException) {
        setState(() {
          statusMessage = "Eror Kamera: ${e.description}";
        });
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _takeAndSavePicture() async {
    if (!controller.value.isInitialized || controller.value.isTakingPicture) {
      return;
    }

    try {
      setState(() {
        isTakingPicture = true;
        statusMessage = "Sedang menjepret...";
      });

      // 1. Jepret Gambar ke cache temporary
      final XFile image = await controller.takePicture();
      
      // 2. Dapatkan folder penyimpanan eksternal khusus aplikasi
      // Fungsi ini membuat folder yang bisa dibuka via File Manager HP
      Directory? directory = await getExternalStorageDirectory();
      
      // Jika folder eksternal tidak ditemukan, fallback ke folder internal dokumen
      directory ??= await getApplicationDocumentsDirectory();
      
      // 3. Buat nama file unik berdasarkan timestamp
      final String fileName = 'foto_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String localPath = path.join(directory.path, fileName);

      // 4. Salin file secara permanen ke folder aplikasi
      final File savedImage = await File(image.path).copy(localPath);

      if (mounted) {
        setState(() {
          statusMessage = "SUKSES!\nTersimpan di:\n${savedImage.path}";
        });
        
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Foto berhasil disimpan ke folder aplikasi!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          statusMessage = "Gagal Menyimpan: $e";
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          isTakingPicture = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cameras.isEmpty) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: Text("Tidak ada kamera"))),
      );
    }

    if (!controller.value.isInitialized) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 10),
                Text(statusMessage),
              ],
            ),
          ),
        ),
      );
    }

    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: CameraPreview(controller),
            ),
            // Teks status di atas kamera untuk memantau path lokasi file
            Positioned(
              top: 50,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(10),
                color: Colors.black54,
                child: Text(
                  statusMessage,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: isTakingPicture ? null : _takeAndSavePicture,
                  child: isTakingPicture
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Icon(Icons.camera_alt, color: Colors.black, size: 28),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
