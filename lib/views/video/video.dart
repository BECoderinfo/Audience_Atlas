import 'package:audience_atlas/utils/import.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import 'dart:async';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _controller;
  String link = Get.arguments['video'];
  bool _isControlsVisible = true;
  bool _isFullscreen = true;
  bool _showLeftSeek = false;
  bool _showRightSeek = false;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(link))
      ..initialize().then((_) {
        setState(() {});
      }).catchError((error) {
        debugPrint("Video initialization failed: $error");
      });

    _controller.addListener(() {
      setState(() {});
    });

    // Initialize UI
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    _resetAutoHideTimer();
  }

  void _togglePlayPause() {
    setState(() {
      _controller.value.isPlaying ? _controller.pause() : _controller.play();
    });
    _resetAutoHideTimer();
  }

  void _toggleControlsVisibility() {
    setState(() {
      _isControlsVisible = !_isControlsVisible;
    });
    if (_isControlsVisible) _resetAutoHideTimer();
  }

  void _seekForward() {
    _controller
        .seekTo(_controller.value.position + const Duration(seconds: 10));
    _showSeekAnimation(right: true);
  }

  void _seekBackward() {
    _controller
        .seekTo(_controller.value.position - const Duration(seconds: 10));
    _showSeekAnimation(right: false);
  }

  void _showSeekAnimation({required bool right}) {
    setState(() {
      if (right) {
        _showRightSeek = true;
      } else {
        _showLeftSeek = true;
      }
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _showLeftSeek = false;
        _showRightSeek = false;
      });
    });
  }

  void _enterFullScreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
      if (_isFullscreen) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      } else {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
      }
    });
  }

  void _resetAutoHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (_controller.value.isPlaying) {
        setState(() {
          _isControlsVisible = false;
        });
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonSize = _isFullscreen ? 50 : 40;
    double iconSize = _isFullscreen ? 30 : 25;
    double progressBarHeight = _isFullscreen ? 5 : 3;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _isFullscreen
          ? null
          : AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: const Text("Video Player"),
              centerTitle: true,
            ),
      body: Center(
        child: _controller.value.isInitialized
            ? GestureDetector(
                onTap: _toggleControlsVisibility,
                onDoubleTapDown: (details) {
                  if (details.globalPosition.dx < screenWidth / 2) {
                    _seekBackward();
                  } else {
                    _seekForward();
                  }
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ),

                    if (_controller.value.isBuffering)
                      const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),

                    // Controls Overlay
                    if (_isControlsVisible)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withOpacity(0.3),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(height: 20), // Top Padding

                              // Play/Pause Button
                              IconButton(
                                icon: Icon(
                                  _controller.value.isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  size: buttonSize,
                                  color: Colors.white,
                                ),
                                onPressed: _togglePlayPause,
                              ),

                              // Bottom Controls
                              Column(
                                children: [
                                  VideoProgressIndicator(
                                    _controller,
                                    allowScrubbing: true,
                                    colors: VideoProgressColors(
                                      playedColor: Colors.red,
                                      bufferedColor: Colors.white38,
                                      backgroundColor: Colors.grey,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: progressBarHeight,
                                      horizontal: _isFullscreen ? 20 : 10,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: _isFullscreen ? 10 : 4,
                                    ),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 10),
                                        Text(
                                          _formatDuration(
                                              _controller.value.position),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  _isFullscreen ? 16 : 12),
                                        ),
                                        Text(
                                          ' / ',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  _isFullscreen ? 16 : 12),
                                        ),
                                        Text(
                                          _formatDuration(
                                              _controller.value.duration),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  _isFullscreen ? 16 : 12),
                                        ),
                                        Spacer(),
                                        IconButton(
                                          icon: Icon(
                                            _isFullscreen
                                                ? Icons.fullscreen_exit
                                                : Icons.fullscreen,
                                            color: Colors.white,
                                            size: iconSize,
                                          ),
                                          onPressed: _enterFullScreen,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                    if (_showLeftSeek)
                      Positioned(
                        left: 50,
                        child: Icon(Icons.replay_10,
                            size: buttonSize, color: Colors.white),
                      ),

                    if (_showRightSeek)
                      Positioned(
                        right: 50,
                        child: Icon(Icons.forward_10,
                            size: buttonSize, color: Colors.white),
                      ),
                  ],
                ),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }
}
