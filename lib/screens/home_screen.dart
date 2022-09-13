import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:fluttertube/models/channel_model.dart';
import 'package:fluttertube/models/video_model.dart';
import 'package:fluttertube/screens/video_screen.dart';
import 'package:fluttertube/utilities/channel_ids.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Channel? _channel;
  bool _isLoading = false;

  //Shared prefs stores the value of the selected channel.
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    _initChannel();
  }

  _initChannel() async {
    //get the value stored in prefs
    SharedPreferences prefs = await _prefs;
    int? value = prefs.getInt('channel') ?? 0;
    Channel channel = await APIService.instance
        .fetchChannel(
      channelId: value == 1
          ? resoCoderChannelId
          : value == 0
              ? flutterDevChannelId
              : flutterFlyId,
    )
        .whenComplete(() {
      setState(() {});
    });
    _channel = channel;
  }

  _buildProfileInfo() {
    return Container(
      margin: const EdgeInsets.all(20.0),
      padding: const EdgeInsets.all(20.0),
      height: 100.0,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 1),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 35.0,
            backgroundImage: NetworkImage(_channel!.profilePictureUrl),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _channel!.title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Videos: ${_channel!.videoCount}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildVideo(Video video) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoScreen(id: video.url),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        padding: const EdgeInsets.all(10.0),
        height: 140.0,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 1),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Image(
              width: 150.0,
              image: NetworkImage(video.thumbnailUrl),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Text(
                video.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _loadMoreVideos() async {
    _isLoading = true;
    List<Video> moreVideos = await APIService.instance
        .fetchVideosFromPlaylist(playlistId: _channel!.uploadPlaylistId);
    List<Video> allVideos = _channel!.videos!..addAll(moreVideos);
    setState(() {
      _channel!.videos = allVideos;
    });
    _isLoading = false;
  }

  void _onItemTapped(int index) async {
    SharedPreferences prefs = await _prefs;
    if (index == 0) {
      prefs.setInt('channel', 0).whenComplete(() {
        Phoenix.rebirth(context);
      });
    } else if (index == 1) {
      prefs.setInt('channel', 1).whenComplete(() {
        Phoenix.rebirth(context);
      });
    } else if (index == 2) {
      prefs.setInt('channel', 2).whenComplete(() {
        Phoenix.rebirth(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.brown,
      appBar: AppBar(
        backgroundColor: Colors.brown,
        // backgroundColor: const Color.fromARGB(100, 255, 85, 85),
        title: const Text(
          'FlutterTube',
          style: TextStyle(fontFamily: 'KumarOneOutline', color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.info_rounded,
            ),
            onPressed: () => CoolAlert.show(
              autoCloseDuration: const Duration(seconds: 4),
              backgroundColor: Colors.brown,
              title: "FlutterTube",
              context: context,
              type: CoolAlertType.info,
              text: "v 1.1.0",
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 13,
        unselectedFontSize: 13,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.brown,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.google,
              // color: Colors.blueAccent,
            ),
            label: 'Flutter',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.playCircle,
              // color: Colors.green,
            ),
            label: 'ResoCoder',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              FontAwesomeIcons.userCircle,
              // color: Colors.blueAccent,
            ),
            label: 'Flutterly',
          ),
        ],
      ),
      body: _channel != null
          ? NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollDetails) {
                if (!_isLoading &&
                    _channel!.videos!.length !=
                        int.parse(_channel!.videoCount) &&
                    scrollDetails.metrics.pixels ==
                        scrollDetails.metrics.maxScrollExtent) {
                  _loadMoreVideos();
                }
                return false;
              },
              child: ListView.builder(
                itemCount: 1 + (_channel!.videos!.length),
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return _buildProfileInfo();
                  }
                  Video video = _channel!.videos![index - 1];
                  return _buildVideo(video);
                },
              ),
            )
          : Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor, // Red
                ),
              ),
            ),
    );
  }
}
