// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:video_player/video_player.dart';
import 'media_picker_home.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(SimpleAudioPlayer());
}

class SimpleAudioPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Audio Player',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AudioPlayerHome(),
    );
  }
}

class AudioPlayerHome extends StatefulWidget {
  @override
  _AudioPlayerHomeState createState() => _AudioPlayerHomeState();
}

class _AudioPlayerHomeState extends State<AudioPlayerHome> {
  late AudioPlayer _audioPlayer;
  int _currentSongIndex = 0;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  // Danh sách các bài hát (từ assets)
  final List<String> _songs = [
    'audios/sample1.mp3',
    'audios/sample2.mp3',
    'audios/sample3.mp3',
  ];

  // Tên bài hát để hiển thị
  final List<String> _songTitles = ['sample1', 'sample2', 'sample3'];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Lắng nghe trạng thái phát
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });

    // Lắng nghe thời gian hiện tại
    _audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        _currentPosition = position;
      });
    });

    // Lắng nghe tổng thời gian bài hát
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _totalDuration = duration;
      });
    });

    // Lắng nghe khi bài hát kết thúc → tự chuyển bài
    _audioPlayer.onPlayerComplete.listen((event) {
      _nextSong();
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // Phát bài hát
  Future<void> _playSong() async {
    await _audioPlayer.play(AssetSource(_songs[_currentSongIndex]));
    setState(() {
      _isPlaying = true;
    });
  }

  // Tạm dừng bài hát
  Future<void> _pauseSong() async {
    await _audioPlayer.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  // Dừng bài hát
  Future<void> _stopSong() async {
    await _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
      _currentPosition = Duration.zero;
    });
  }

  // Chuyển sang bài tiếp theo
  Future<void> _nextSong() async {
    await _stopSong();
    setState(() {
      _currentSongIndex = (_currentSongIndex + 1) % _songs.length;
    });
    await _playSong();
  }

  // Quay lại bài trước
  Future<void> _previousSong() async {
    await _stopSong();
    setState(() {
      _currentSongIndex =
          (_currentSongIndex - 1 + _songs.length) % _songs.length;
    });
    await _playSong();
  }

  // Format thời gian mm:ss
  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('Simple Audio Player'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // Album art placeholder
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade200,
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.music_note,
                  size: 80,
                  color: Colors.blue,
                ),
              ),

              SizedBox(height: 32),

              // Tên bài hát
              Text(
                _songTitles[_currentSongIndex],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),

              SizedBox(height: 8),

              // Số thứ tự bài
              Text(
                '${_currentSongIndex + 1} / ${_songs.length}',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),

              SizedBox(height: 24),

              // Thanh tiến trình
              Column(
                children: [
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                      overlayShape: RoundSliderOverlayShape(overlayRadius: 12),
                    ),
                    child: Slider(
                      value: _totalDuration.inSeconds > 0
                          ? _currentPosition.inSeconds
                          .toDouble()
                          .clamp(0, _totalDuration.inSeconds.toDouble())
                          : 0,
                      min: 0,
                      max: _totalDuration.inSeconds > 0
                          ? _totalDuration.inSeconds.toDouble()
                          : 1,
                      activeColor: Colors.blue,
                      inactiveColor: Colors.blue.shade100,
                      onChanged: (value) {
                        _audioPlayer.seek(Duration(seconds: value.toInt()));
                      },
                    ),
                  ),
                  // Hiển thị thời gian
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(_currentPosition),
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        _formatDuration(_totalDuration),
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 16),

              // Nút điều khiển
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Previous
                  IconButton(
                    icon: Icon(Icons.skip_previous, size: 44),
                    color: Colors.blue,
                    tooltip: 'Previous',
                    onPressed: _previousSong,
                  ),

                  SizedBox(width: 8),

                  // Play / Pause
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        size: 40,
                        color: Colors.white,
                      ),
                      tooltip: _isPlaying ? 'Pause' : 'Play',
                      onPressed: () {
                        _isPlaying ? _pauseSong() : _playSong();
                      },
                    ),
                  ),

                  SizedBox(width: 8),

                  // Stop
                  IconButton(
                    icon: Icon(Icons.stop, size: 44),
                    color: Colors.red,
                    tooltip: 'Stop',
                    onPressed: _stopSong,
                  ),

                  SizedBox(width: 8),

                  // Next
                  IconButton(
                    icon: Icon(Icons.skip_next, size: 44),
                    color: Colors.blue,
                    tooltip: 'Next',
                    onPressed: _nextSong,
                  ),
                ],
              ),

              SizedBox(height: 32),

              // Danh sách bài hát
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: List.generate(_songs.length, (index) {
                    final isActive = index == _currentSongIndex;
                    return ListTile(
                      leading: Icon(
                        isActive && _isPlaying
                            ? Icons.volume_up
                            : Icons.music_note,
                        color: isActive ? Colors.blue : Colors.grey,
                      ),
                      title: Text(
                        _songTitles[index],
                        style: TextStyle(
                          fontWeight: isActive
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isActive ? Colors.blue : Colors.black87,
                        ),
                      ),
                      trailing: isActive
                          ? Icon(Icons.equalizer, color: Colors.blue)
                          : null,
                      onTap: () async {
                        await _stopSong();
                        setState(() {
                          _currentSongIndex = index;
                        });
                        await _playSong();
                      },
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// void main() {
//   runApp(VideoRecorderApp());
// }
//
// class VideoRecorderApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Video Recorder & Playback',
//       theme: ThemeData(primarySwatch: Colors.purple),
//       home: VideoRecorderHome(),
//     );
//   }
// }
//
// class VideoRecorderHome extends StatefulWidget {
//   @override
//   _VideoRecorderHomeState createState() => _VideoRecorderHomeState();
// }
//
// class _VideoRecorderHomeState extends State<VideoRecorderHome> {
//   File? _videoFile;
//   VideoPlayerController? _videoController;
//   final ImagePicker _picker = ImagePicker();
//   Duration _currentPosition = Duration.zero;
//   Duration _totalDuration = Duration.zero;
//
//   // Yêu cầu quyền
//   Future<void> _requestPermission(Permission permission) async {
//     if (await permission.isDenied) {
//       await permission.request();
//     }
//   }
//
//   // Chọn video từ gallery
//   Future<void> _pickVideoFromGallery() async {
//     await _requestPermission(Permission.photos);
//     final XFile? pickedFile = await _picker.pickVideo(
//       source: ImageSource.gallery,
//     );
//     if (pickedFile != null) {
//       _loadVideo(File(pickedFile.path));
//     }
//   }
//
//   // Quay video từ camera
//   Future<void> _recordVideoFromCamera() async {
//     await _requestPermission(Permission.camera);
//     await _requestPermission(Permission.microphone);
//     final XFile? recordedFile = await _picker.pickVideo(
//       source: ImageSource.camera,
//     );
//     if (recordedFile != null) {
//       _loadVideo(File(recordedFile.path));
//     }
//   }
//
//   // Tải và khởi tạo video
//   void _loadVideo(File videoFile) {
//     setState(() {
//       _videoFile = videoFile;
//       _videoController?.dispose();
//       _videoController = VideoPlayerController.file(_videoFile!)
//         ..initialize().then((_) {
//           setState(() {
//             _totalDuration = _videoController!.value.duration;
//           });
//           _videoController!.play();
//         });
//
//       // Lắng nghe vị trí hiện tại của video
//       _videoController!.addListener(() {
//         if (_videoController!.value.isInitialized) {
//           setState(() {
//             _currentPosition = _videoController!.value.position;
//             _totalDuration = _videoController!.value.duration;
//           });
//         }
//       });
//     });
//   }
//
//   // Format thời gian mm:ss
//   String _formatDuration(Duration d) {
//     final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
//     final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
//     return '$minutes:$seconds';
//   }
//
//   @override
//   void dispose() {
//     _videoController?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Video Recorder & Playback')),
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(height: 20),
//
//             // Khung hiển thị video
//             _videoController != null && _videoController!.value.isInitialized
//                 ? Column(
//               children: [
//                 AspectRatio(
//                   aspectRatio: _videoController!.value.aspectRatio,
//                   child: VideoPlayer(_videoController!),
//                 ),
//                 SizedBox(height: 8),
//
//                 // Thanh tiến trình video
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 16),
//                   child: Column(
//                     children: [
//                       VideoProgressIndicator(
//                         _videoController!,
//                         allowScrubbing: true, // cho phép kéo thanh tiến trình
//                         colors: VideoProgressColors(
//                           playedColor: Colors.purple,
//                           bufferedColor: Colors.purple.shade100,
//                           backgroundColor: Colors.grey.shade300,
//                         ),
//                       ),
//                       SizedBox(height: 4),
//                       // Hiển thị thời gian
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             _formatDuration(_currentPosition),
//                             style: TextStyle(fontSize: 12, color: Colors.grey),
//                           ),
//                           Text(
//                             _formatDuration(_totalDuration),
//                             style: TextStyle(fontSize: 12, color: Colors.grey),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             )
//                 : Container(
//               height: 200,
//               color: Colors.black12,
//               child: Center(child: Text('Chưa có video nào được chọn.')),
//             ),
//
//             SizedBox(height: 16),
//
//             // Nút Play / Pause / Stop
//             if (_videoController != null)
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Nút Replay (quay lại đầu)
//                   IconButton(
//                     icon: Icon(Icons.replay, size: 36),
//                     tooltip: 'Replay',
//                     onPressed: () {
//                       _videoController!.seekTo(Duration.zero);
//                       _videoController!.play();
//                     },
//                   ),
//                   SizedBox(width: 8),
//
//                   // Nút Play / Pause
//                   ElevatedButton.icon(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.purple,
//                       foregroundColor: Colors.white,
//                       padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _videoController!.value.isPlaying
//                             ? _videoController!.pause()
//                             : _videoController!.play();
//                       });
//                     },
//                     icon: Icon(
//                       _videoController!.value.isPlaying
//                           ? Icons.pause
//                           : Icons.play_arrow,
//                       size: 28,
//                     ),
//                     label: Text(
//                       _videoController!.value.isPlaying ? 'Pause' : 'Play',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ),
//                   SizedBox(width: 8),
//
//                   // Nút Stop
//                   IconButton(
//                     icon: Icon(Icons.stop, size: 36, color: Colors.red),
//                     tooltip: 'Stop',
//                     onPressed: () {
//                       setState(() {
//                         _videoController!.pause();
//                         _videoController!.seekTo(Duration.zero);
//                       });
//                     },
//                   ),
//                 ],
//               ),
//
//             SizedBox(height: 24),
//
//             // Nút chọn / quay video
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 32),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   ElevatedButton.icon(
//                     onPressed: _pickVideoFromGallery,
//                     icon: Icon(Icons.video_library),
//                     label: Text('Chọn video từ Gallery'),
//                   ),
//                   SizedBox(height: 8),
//                   ElevatedButton.icon(
//                     onPressed: _recordVideoFromCamera,
//                     icon: Icon(Icons.videocam),
//                     label: Text('Quay video từ Camera'),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }

// void main() {
//   runApp(PhotoCaptureApp());
// }
//
// class PhotoCaptureApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Photo Capture & Preview',
//       theme: ThemeData(primarySwatch: Colors.green),
//       home: PhotoCaptureHome(),
//     );
//   }
// }
//
// class PhotoCaptureHome extends StatefulWidget {
//   @override
//   _PhotoCaptureHomeState createState() => _PhotoCaptureHomeState();
// }
//
// class _PhotoCaptureHomeState extends State<PhotoCaptureHome> {
//   File? _imageFile;
//   final ImagePicker _picker = ImagePicker();
//
//   // Yêu cầu quyền
//   Future<void> _requestPermission(Permission permission) async {
//     if (await permission.isDenied) {
//       await permission.request();
//     }
//   }
//
//   // Chọn ảnh từ gallery
//   Future<void> _pickImageFromGallery() async {
//     await _requestPermission(Permission.photos);
//     final XFile? pickedFile = await _picker.pickImage(
//       source: ImageSource.gallery,
//     );
//     if (pickedFile != null) {
//       setState(() {
//         _imageFile = File(pickedFile.path);
//       });
//     }
//   }
//
//   // Chụp ảnh từ camera
//   Future<void> _captureImageFromCamera() async {
//     await _requestPermission(Permission.camera);
//     final XFile? capturedFile = await _picker.pickImage(
//       source: ImageSource.camera,
//     );
//     if (capturedFile != null) {
//       setState(() {
//         _imageFile = File(capturedFile.path);
//       });
//     }
//   }
//
//   // Xem trước ảnh toàn màn hình
//   void _showFullScreenPreview(BuildContext context) {
//     if (_imageFile != null) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => FullScreenImage(imageFile: _imageFile!),
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Photo Capture & Preview')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _imageFile == null
//                 ? Text('Chưa có ảnh nào được chọn.')
//                 : GestureDetector(
//               onTap: () => _showFullScreenPreview(context),
//               child: Image.file(_imageFile!, height: 300),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _pickImageFromGallery,
//               child: Text('Chọn ảnh từ Gallery'),
//             ),
//             ElevatedButton(
//               onPressed: _captureImageFromCamera,
//               child: Text('Chụp ảnh từ Camera'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// class FullScreenImage extends StatelessWidget {
//   final File imageFile;
//   FullScreenImage({required this.imageFile});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         iconTheme: IconThemeData(color: Colors.white),
//         title: Text('Xem trước', style: TextStyle(color: Colors.white)),
//       ),
//       body: Center(
//         child: InteractiveViewer(
//           // Cho phép zoom ảnh bằng cử chỉ pinch
//           panEnabled: true,
//           minScale: 0.5,
//           maxScale: 4.0,
//           child: Image.file(imageFile),
//         ),
//       ),
//     );
//   }
// }








// void main() {
//   runApp(MediaPickerApp());
// }
//
// class MediaPickerApp extends StatelessWidget {
//   const MediaPickerApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Media Picker App',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: MediaPickerHome(),
//     );
//   }
// }