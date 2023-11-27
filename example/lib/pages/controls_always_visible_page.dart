import 'package:better_player/better_player.dart';
import 'package:better_player_example/constants.dart';
import 'package:flutter/material.dart';

class ControlsAlwaysVisiblePage extends StatefulWidget {
  @override
  _ControlsAlwaysVisiblePageState createState() =>
      _ControlsAlwaysVisiblePageState();
}

class _ControlsAlwaysVisiblePageState extends State<ControlsAlwaysVisiblePage> {
  late BetterPlayerController _betterPlayerController;

  @override
  void initState() {
    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
      aspectRatio: 9 / 16,
      fit: BoxFit.cover,
      handleLifecycle: true,
          autoPlay: true
    );
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);

    _betterPlayerController.setControlsVisibility(false);
    _betterPlayerController.setControlsAlwaysVisible(false);
    _betterPlayerController.setControlsEnabled(false);

    _setupDataSource();
    super.initState();
  }

  void _setupDataSource() async {
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      //'https://dyx282ufjlfk4.cloudfront.net/products/15133/videos/Snapinsta.app_video_403713817_1434880537434441_986734261436097531_n.mp4',
      Constants.phantomVideoUrl,
    );
    _betterPlayerController.setupDataSource(dataSource);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Controls Hide"),
      ),
      body: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            child: BetterPlayer(controller: _betterPlayerController),
            // ),
          ),
        ),
      ),
    );
  }
}
