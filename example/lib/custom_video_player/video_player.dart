import 'dart:developer';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
class VideoPlayerWidget extends StatefulWidget {
  final String reelUrl;

  final Key key;

  const VideoPlayerWidget({
    required this.key,
    required this.reelUrl,
  });

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget>
    with WidgetsBindingObserver {
  //late VideoPlayerController _controller;
  BetterPlayerController? _controller;
  late BetterPlayerDataSource dataSource;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initializeController();
  }

  bool _videoInitialized = false;

 void initializeController() async {
   debugPrint("initializeVideoController:: ${widget.reelUrl}");
    if (mounted) {
      BetterPlayerConfiguration betterPlayerConfiguration =
      BetterPlayerConfiguration(
          aspectRatio: 9 / 16,
          fit: BoxFit.cover,
          handleLifecycle: true,
          autoPlay: true,
        looping: true,
      );
      _controller = BetterPlayerController(betterPlayerConfiguration);

      _controller?.setControlsVisibility(false);
      _controller?.setControlsAlwaysVisible(false);
      _controller?.setControlsEnabled(false);
      _setupDataSource();
      _controller?.addEventsListener((event) {
        //debugPrint("addEventsListener:: ${event.betterPlayerEventType.name}");
        if (_controller!.isPlaying()! && !_isPlaying) {
          // Video has started playing
          setState(() {
            _isPlaying = true;
          });
        }
        if(_controller!.isVideoInitialized()!){
          _videoInitialized = true;
        }
      });
   }
  }

  void _setupDataSource() async {
   dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      //'https://dyx282ufjlfk4.cloudfront.net/products/15133/videos/Snapinsta.app_video_403713817_1434880537434441_986734261436097531_n.mp4',
      widget.reelUrl,
      cacheConfiguration: BetterPlayerCacheConfiguration(
        useCache: true,
        preCacheSize: 10 * 1024 * 1024,
        maxCacheSize: 10 * 1024 * 1024,
        maxCacheFileSize: 10 * 1024 * 1024,

        ///Android only option to use cached video between app sessions
        key: "testCacheKey",
      ),
    );

   _controller!.preCache(dataSource);
    _controller?.setupDataSource(dataSource);

  }

  bool _isPlaying = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // App is in the foreground
      _controller?.play();
    } else if (state == AppLifecycleState.inactive) {
      // App is partially obscured
      _controller?.pause();
    } else if (state == AppLifecycleState.paused) {
      // App is in the background
      _controller?.pause();
    } else if (state == AppLifecycleState.detached) {
      // App is terminated
      _controller?.dispose();
    }
  }

  @override
  void dispose() {
    log('disposing a controller');
    if (mounted) {
      _controller?.dispose();
    } // Dispose of the controller when done
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      left: false,
      right: false,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              if (_videoInitialized) {
                setState(() {
                  if (_controller!.isPlaying()!) {
                    _controller?.pause();
                    _isPlaying = false;
                  } else {
                    _controller?.play();
                    _isPlaying = true;
                  }
                });
              }
            },
            child: Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                /*!_videoInitialized
                    // when the video is not initialized you can set a thumbnail.
                    // to make it simple, I use CircularProgressIndicator
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.amber,
                        ),
                      )
                    :*/ BetterPlayer(controller: _controller!),
                /*!_videoInitialized
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.amber,
                        ),
                      )
                    : const SizedBox(),*/
                /*if (!_isPlaying)
                  const Center(
                    child: Icon(
                      Icons.play_arrow,
                      size: 50.0,
                      color: Colors.white,
                    ),
                  )*/
              ],
            ),
          ),
          // here you can add title, user Info,
          // description, views count etc.
        ],
      ),
    );
  }
}
