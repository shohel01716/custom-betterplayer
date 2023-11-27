import 'package:flutter/material.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'video_player.dart';

class VideoReelPage extends StatefulWidget {

  @override
  _VideoReelPageState createState() => _VideoReelPageState();
}

class _VideoReelPageState extends State<VideoReelPage> {
  late PreloadPageController _pageController;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PreloadPageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  static final reels = <String>[
    'http://sample.vodobox.com/skate_phantom_flex_4k/skate_phantom_flex_4k.m3u8',
    'https://diceyk6a7voy4.cloudfront.net/e78752a1-2e83-43fa-85ae-3d508be29366/hls/fitfest-sample-1_Ott_Hls_Ts_Avc_Aac_16x9_1280x720p_30Hz_6.0Mbps_qvbr.m3u8',
    'http://sample.vodobox.com/skate_phantom_flex_4k/skate_phantom_flex_4k.m3u8',
    'https://diceyk6a7voy4.cloudfront.net/e78752a1-2e83-43fa-85ae-3d508be29366/hls/fitfest-sample-1_Ott_Hls_Ts_Avc_Aac_16x9_1280x720p_30Hz_6.0Mbps_qvbr.m3u8',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PreloadPageView.builder(
        scrollDirection: Axis.vertical,
        controller: _pageController,
        itemCount: reels.length,
        onPageChanged: (index) {
          currentPage = index;
        },
        itemBuilder: (context, index) {
          return VideoPlayerWidget(
            key: Key(reels[index]),
            reelUrl: reels[index],
          );
        },
      ),
    );
  }
}
