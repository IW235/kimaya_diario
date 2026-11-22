import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../state.dart';
import '../theme.dart';
import 'settings.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key, required this.state});
  final AppState state;

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late final VideoPlayerController _video;
  bool _ready = false;
  bool _openingProgress = false;
  String? _videoError;

  @override
  void initState() {
    super.initState();
    _video = VideoPlayerController.asset('assets/video/inicio_app.mp4')
      ..addListener(_onVideoChanged);
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      await _video.initialize();
      await _video.setLooping(false);
      if (!mounted) return;

      // Chrome bloquea el autoplay con sonido. Mostramos el primer fotograma
      // y dejamos que el usuario inicie el video con el botón central.
      setState(() => _ready = true);
      if (!kIsWeb) await _video.play();
    } catch (_) {
      if (mounted) {
        setState(() => _videoError = 'No se pudo cargar el video de inicio.');
      }
    }
  }

  void _onVideoChanged() {
    if (!_video.value.isInitialized || _openingProgress) return;
    final duration = _video.value.duration;
    if (duration > Duration.zero &&
        _video.value.position >= duration - const Duration(milliseconds: 150)) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _openProgress());
    }
  }

  Future<void> _openProgress() async {
    if (!mounted || _openingProgress) return;
    final navigator = Navigator.of(context);
    _openingProgress = true;
    await _video.pause();
    await navigator.push(
      MaterialPageRoute(builder: (_) => SettingsScreen(state: widget.state)),
    );

    // Si el usuario regresa sin elegir, puede continuar viendo el video.
    if (mounted && widget.state.progress == null) {
      _openingProgress = false;
      if (_video.value.position >=
          _video.value.duration - const Duration(milliseconds: 150)) {
        await _video.seekTo(Duration.zero);
      }
      await _video.play();
    }
  }

  Future<void> _togglePlayback() async {
    if (!_ready) return;
    try {
      if (_video.value.isPlaying) {
        await _video.pause();
      } else {
        await _video.play();
      }
    } catch (_) {
      if (mounted) {
        setState(() => _videoError = 'No se pudo reproducir el video.');
      }
    }
  }

  @override
  void dispose() {
    _video
      ..removeListener(_onVideoChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            if (_ready)
              GestureDetector(
                onTap: _togglePlayback,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _video.value.size.width,
                    height: _video.value.size.height,
                    child: VideoPlayer(_video),
                  ),
                ),
              )
            else if (_videoError == null)
              const Center(child: CircularProgressIndicator(color: K.gold)),
            if (_videoError != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    _videoError!,
                    textAlign: TextAlign.center,
                    style: K.body(16, color: K.paper),
                  ),
                ),
              ),
            if (_ready)
              Center(
                child: ValueListenableBuilder<VideoPlayerValue>(
                  valueListenable: _video,
                  builder: (_, value, __) => AnimatedOpacity(
                    opacity: value.isPlaying ? 0 : 1,
                    duration: const Duration(milliseconds: 180),
                    child: IconButton.filled(
                      tooltip: 'Reproducir video',
                      onPressed: _togglePlayback,
                      iconSize: 44,
                      style: IconButton.styleFrom(
                        backgroundColor: K.night.withValues(alpha: .72),
                        foregroundColor: K.gold,
                      ),
                      icon: const Icon(Icons.play_arrow_rounded),
                    ),
                  ),
                ),
              ),
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: K.night.withValues(alpha: .72),
                      foregroundColor: K.paper,
                    ),
                    onPressed: _openProgress,
                    child: const Text('Omitir'),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
