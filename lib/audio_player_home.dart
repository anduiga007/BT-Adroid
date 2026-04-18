import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerHome extends StatefulWidget {
  const AudioPlayerHome({super.key});

  @override
  State<AudioPlayerHome> createState() => _AudioPlayerHomeState();
}

class _AudioPlayerHomeState extends State<AudioPlayerHome>
    with TickerProviderStateMixin {
  late AudioPlayer _audioPlayer;
  late AnimationController _rotationController;
  late AnimationController _pulseController;

  int _currentIndex = 0;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  final List<Map<String, String>> _songs = [
    {
      'title': 'Sample 1',
      'artist': 'Artist One',
      'asset': 'audios/sample1.mp3',
      'color': 'E8FF47',
    },
    {
      'title': 'Sample 2',
      'artist': 'Artist Two',
      'asset': 'audios/sample2.mp3',
      'color': 'FF6B6B',
    },
    {
      'title': 'Sample 3',
      'artist': 'Artist Three',
      'asset': 'audios/sample3.mp3',
      'color': '47C8FF',
    },
  ];

  Color get _accentColor {
    final hex = _songs[_currentIndex]['color']!;
    return Color(int.parse('FF$hex', radix: 16));
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _audioPlayer.onDurationChanged.listen((d) {
      setState(() => _duration = d);
    });
    _audioPlayer.onPositionChanged.listen((p) {
      setState(() => _position = p);
    });
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() => _isPlaying = state == PlayerState.playing);
      if (_isPlaying) {
        _rotationController.repeat();
      } else {
        _rotationController.stop();
      }
    });
    _audioPlayer.onPlayerComplete.listen((_) => _next());
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _play() async {
    await _audioPlayer.play(AssetSource(_songs[_currentIndex]['asset']!));
  }

  Future<void> _pause() async => await _audioPlayer.pause();
  Future<void> _stop() async {
    await _audioPlayer.stop();
    setState(() => _position = Duration.zero);
  }

  void _next() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _songs.length;
    });
    _stop().then((_) => _play());
  }

  void _previous() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + _songs.length) % _songs.length;
    });
    _stop().then((_) => _play());
  }

  String _formatTime(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final song = _songs[_currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'BEATS',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 6,
                      color: _accentColor,
                    ),
                  ),
                  Icon(Icons.more_horiz, color: Colors.white38, size: 28),
                ],
              ),
            ),

            const SizedBox(height: 8),


            Expanded(
              flex: 4,
              child: Center(
                child: AnimatedBuilder(
                  animation: _rotationController,
                  builder: (_, child) => Transform.rotate(
                    angle: _rotationController.value * 2 * 3.14159,
                    child: child,
                  ),
                  child: _buildVinyl(),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: Text(
                      song['title']!,
                      key: ValueKey(song['title']),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    song['artist']!,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white38,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 3,
                      thumbShape: RoundSliderThumbShape(
                          enabledThumbRadius: 6),
                      overlayShape: RoundSliderOverlayShape(overlayRadius: 14),
                      activeTrackColor: _accentColor,
                      inactiveTrackColor: Colors.white12,
                      thumbColor: _accentColor,
                      overlayColor: _accentColor.withOpacity(0.2),
                    ),
                    child: Slider(
                      value: _position.inSeconds
                          .toDouble()
                          .clamp(0, _duration.inSeconds.toDouble()),
                      max: _duration.inSeconds.toDouble() == 0
                          ? 1
                          : _duration.inSeconds.toDouble(),
                      onChanged: (val) {
                        _audioPlayer.seek(Duration(seconds: val.toInt()));
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatTime(_position),
                            style: TextStyle(
                                color: Colors.white38, fontSize: 12)),
                        Text(_formatTime(_duration),
                            style: TextStyle(
                                color: Colors.white38, fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous
                  _ControlButton(
                    icon: Icons.skip_previous_rounded,
                    size: 32,
                    color: Colors.white60,
                    onTap: _previous,
                  ),

                  // Stop
                  _ControlButton(
                    icon: Icons.stop_rounded,
                    size: 28,
                    color: Colors.white38,
                    onTap: _stop,
                  ),

                  // Play / Pause (big)
                  GestureDetector(
                    onTap: () {
                      _isPlaying ? _pause() : _play();
                    },
                    child: AnimatedBuilder(
                      animation: _pulseController,
                      builder: (_, child) => Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _accentColor,
                          boxShadow: [
                            BoxShadow(
                              color: _accentColor.withOpacity(
                                  _isPlaying
                                      ? 0.3 + _pulseController.value * 0.3
                                      : 0.2),
                              blurRadius: _isPlaying
                                  ? 20 + _pulseController.value * 20
                                  : 12,
                              spreadRadius: _isPlaying ? 4 : 0,
                            ),
                          ],
                        ),
                        child: Icon(
                          _isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          size: 36,
                          color: const Color(0xFF0D0D0D),
                        ),
                      ),
                    ),
                  ),

                  // Next
                  _ControlButton(
                    icon: Icons.skip_next_rounded,
                    size: 32,
                    color: Colors.white60,
                    onTap: _next,
                  ),

                  // Placeholder for symmetry
                  const SizedBox(width: 40),
                ],
              ),
            ),

            const SizedBox(height: 28),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.07)),
              ),
              child: Column(
                children: List.generate(_songs.length, (i) {
                  final isActive = i == _currentIndex;
                  final c = Color(int.parse('FF${_songs[i]['color']!}', radix: 16));
                  return GestureDetector(
                    onTap: () {
                      setState(() => _currentIndex = i);
                      _stop().then((_) => _play());
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isActive ? c.withOpacity(0.12) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isActive ? c : Colors.white12,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              _songs[i]['title']!,
                              style: TextStyle(
                                color: isActive ? c : Colors.white54,
                                fontWeight: isActive
                                    ? FontWeight.w700
                                    : FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Text(
                            _songs[i]['artist']!,
                            style: TextStyle(
                              color: Colors.white24,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildVinyl() {
    return Container(
      width: 240,
      height: 240,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            const Color(0xFF1A1A1A),
            const Color(0xFF111111),
            _accentColor.withOpacity(0.15),
            const Color(0xFF0D0D0D),
          ],
          stops: const [0.0, 0.35, 0.7, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: _accentColor.withOpacity(0.18),
            blurRadius: 48,
            spreadRadius: 8,
          ),
          const BoxShadow(
            color: Colors.black54,
            blurRadius: 24,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Vinyl grooves
          ...List.generate(5, (i) {
            final r = 50.0 + i * 20;
            return Container(
              width: r * 2,
              height: r * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: Colors.white.withOpacity(0.04), width: 1),
              ),
            );
          }),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF1A1A1A),
              border: Border.all(color: _accentColor.withOpacity(0.4), width: 2),
            ),
            child: Center(
              child: Text(
                _songs[_currentIndex]['title']![0],
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  color: _accentColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color color;
  final VoidCallback onTap;

  const _ControlButton({
    required this.icon,
    required this.size,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        child: Icon(icon, size: size, color: color),
      ),
    );
  }
}
