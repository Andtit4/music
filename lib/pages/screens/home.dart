import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music/models/recent_model_card.dart';
import 'package:music/pages/widgets/button_icons.dart';
import 'package:music/pages/widgets/input.dart';
import 'package:flukit/flukit.dart';
import 'package:music/pages/widgets/tab_view.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<RecentMusicModel> musicRecent = RecentMusicModel.getAll();
  final OnAudioQuery _audioQuery = OnAudioQuery();
  bool _hasPermission = false;
  bool _onPlay = false;
  bool _onPlaying = false;
  PlayerState playerState = PlayerState.stopped;
  Duration durationPlaying = Duration();
  Duration position = Duration();

  String titre = "";
  String artiste = "";
  String url = "";
  int id = 0;
  int duration = 0;
  late AudioPlayer audioPlayer;
  String trackName = '';
  String artistNames = '';
  String audioUrl = '';
  String imgTrack = "";

  Future<void> fetchTrackData(String trackId) async {
    // Remplacez "YOUR_ACCESS_TOKEN" par votre jeton d'accès à l'API Spotify
    final String accessToken =
        'BQCLLHYIx-TkyC9H30q8TnxitGMKVsIA4eRHfBau8-5H0dIJarBUUfHOOT5vQrUrFg9tOF0dZZJheqDLBM0f_sOh1BASOG3-dT8GEB8RPB5g7eAcMJj-u6n1xMjhKhEGvOAZSyshx5yRjEhRmHCItysYqseJYxcppWe-43nbk1B_qT_mU6K9VhrGTRuwxGAkXLJ6HTdVqMXIQK36vMR6Q66mAC8ADN4c8WfbgVTq4CaGDByuRcLiT8kIKdpEa3ZWVwXZwr6R8woOELGdHwUWVA';

    final response = await http.get(
      Uri.parse('https://api.spotify.com/v1/tracks/$trackId'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        final album = data['album'];
        final images = album['images'];
        imgTrack = images[0]['url'];
        trackName = data['name'];
        artistNames =
            data['artists'].map((artist) => artist['name']).toList().join(', ');
        audioUrl = data['preview_url'];
      });
      print('____url__$audioUrl');

      // playAudio();
    } else {
      print('Erreur lors de la récupération des données de la piste');
    }
  }

  checkAndRequestPermissions({bool retry = false}) async {
    // The param 'retryRequest' is false, by default.
    _hasPermission = await _audioQuery.checkAndRequest(
      retryRequest: retry,
    );

    // Only call update the UI if application has all required permissions.
    _hasPermission ? setState(() {}) : null;
  }

  getFile() async {
    var status = await Permission.storage.status;

    if (status.isDenied) {
      Permission.storage.request();
    } else {
      checkAndRequestPermissions();
    }
  }

  playing(width, height, titre, artiste, img, duration, url) {
    int totalSeconds = (duration / 1000).round();
    int minutes =
        totalSeconds ~/ 60; // Division entière pour obtenir les minutes
    int seconds = totalSeconds % 60;
    return Positioned(
      bottom: 30,
      left: 5,
      child: Container(
        width: width * .9,
        height: height * .13,
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color.fromARGB(255, 18, 90, 116),
            boxShadow: [
              BoxShadow(
                  color: Color.fromARGB(185, 53, 52, 52),
                  blurRadius: 12,
                  offset: Offset(0, 1),
                  spreadRadius: 1)
            ]),
        child: Row(
          children: [
            QueryArtworkWidget(
              id: img,
              type: ArtworkType.AUDIO,
              artworkWidth: width * .19,
              artworkHeight: height * .1,
              controller: _audioQuery,
              // format: ArtworkFormat.PNG,
              nullArtworkWidget: FluButton(
                  width: width * .19,
                  height: height * .1,
                  backgroundColor: Color.fromARGB(255, 9, 72, 94),
                  child: FluIcon(
                    FluIcons.music,
                    color: Colors.white,
                  )),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      SizedBox(
                        width: width * .2,
                        height: height * .03,
                        child: Text(
                          '   $titre',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: width * .2,
                        height: height * .03,
                        child: Text(
                          '  $artiste',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Color.fromARGB(197, 250, 249, 249)),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: width * .4,
                  height: height * .03,
                  child: Slider(
                    activeColor: Colors.white,
                    inactiveColor: Color.fromARGB(255, 196, 194, 194),
                    min: 0.0,
                    max: durationPlaying.inMilliseconds.toDouble(),
                    // value: position,
                    value: position.inMilliseconds.toDouble(),
                    onChanged: (double value) {
                      audioPlayer.seek(Duration(milliseconds: value.round()));
                    },
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      Text(
                        '  ${durationToString(position)}',
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '  $minutes:$seconds',
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Color.fromARGB(197, 250, 249, 249)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            /* SizedBox(
              width: 15,
            ), */
            FluButton(
                backgroundColor: Colors.transparent,
                width: width * .08,
                child: FluIcon(
                  FluIcons.previous,
                  color: Colors.white,
                )),
            _onPlaying == true
                ? FluButton(
                    onPressed: () {
                      if (playerState != PlayerState.playing) {
                        audioPlayer.play(UrlSource(url));
                        print('Playing_Media');
                      }
                      setState(() {
                        _onPlaying = !_onPlaying;
                      });
                      if (playerState == PlayerState.playing) {
                        audioPlayer.pause();
                      }

                      /* playerState != PlayerState.playing
                          ? () => audioPlayer.play(UrlSource(url))
                          : null; */
                    },
                    backgroundColor: Colors.transparent,
                    width: width * .08,
                    child: FluIcon(
                      FluIcons.pause,
                      color: Colors.white,
                    ))
                : FluButton(
                    backgroundColor: Colors.transparent,
                    width: width * .08,
                    onPressed: () {
                      setState(() {
                        _onPlaying = !_onPlaying;
                      });
                      if (playerState == PlayerState.playing) {
                        audioPlayer.pause();
                      }
                    },
                    child: FluIcon(
                      FluIcons.play,
                      color: Colors.white,
                    )),
            FluButton(
                backgroundColor: Colors.transparent,
                width: width * .08,
                child: FluIcon(
                  FluIcons.next,
                  color: Colors.white,
                )),
          ],
        ),
      ),
    );
  }

  playingControl(url) {
    AudioPlayer audioPlayer = AudioPlayer();
    if (_onPlaying == true) {
      audioPlayer.stop();
      audioPlayer.play(UrlSource(url));
    } else {
      audioPlayer.pause();
    }
  }

  @override
  void initState() {
    super.initState();
    /* LogConfig logConfig = LogConfig(logType: LogType.DEBUG);
    _audioQuery.setLogConfig(logConfig); */
    getFile();
    audioPlayer = AudioPlayer();
    audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        this.durationPlaying = duration;
      });
    });
    audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        this.position = position;
      });
    });
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        playerState = state;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
    fetchTrackData('35b2aICqZwjqrS7eKAzrjE?si=00d8a7edb7004356');
  }

  @override
  Widget build(BuildContext context) {
    late double width = MediaQuery.of(context).size.width;
    late double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xff073b4c),
      body: SingleChildScrollView(
        // physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: SizedBox(
            width: width,
            height: height,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: height * .08,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FluButton(
                            height: height * .08,
                            child: FluIcon(
                              FluIcons.listUlUnicon,
                              color: Color.fromARGB(197, 245, 241, 241),
                            ),
                            backgroundColor: Color.fromARGB(255, 9, 72, 94),
                            // size: 65,
                            cornerRadius: 15,
                            onPressed: () {},
                          ),
                          InputCustom(
                            width: width * .6,
                            height: height * .08,
                            margin: const EdgeInsets.only(top: 5),
                            prefixIcon: FluIcon(
                              FluIcons.search,
                              color: Color.fromARGB(197, 245, 241, 241),
                            ),
                            inputColor: const Color.fromARGB(255, 9, 72, 94),
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            hintColor: Color.fromARGB(197, 245, 241, 241),
                            hintText: 'Rechercher',
                          )
                        ],
                      ),
                      SizedBox(
                        height: height * .02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(),
                          FluButton(
                              backgroundColor:
                                  Color.fromARGB(88, 245, 180, 192),
                              width: width * .18,
                              height: height * .08,
                              child: FluIcon(
                                FluIcons.heart,
                                color: const Color.fromARGB(255, 194, 49, 97),
                              )),
                          FluButton(
                              backgroundColor:
                                  Color.fromARGB(55, 169, 253, 172),
                              width: width * .18,
                              height: height * .08,
                              child: FluIcon(
                                FluIcons.music,
                                color: Color.fromARGB(255, 90, 235, 95),
                              )),
                          FluButton(
                              backgroundColor:
                                  const Color.fromARGB(96, 33, 149, 243),
                              width: width * .18,
                              height: height * .08,
                              child: FluIcon(
                                FluIcons.radio,
                                color: Colors.blue,
                              )),
                          SizedBox()
                        ],
                      ),
                      SizedBox(
                        height: height * .02,
                      ),
                      SizedBox(
                        width: width,
                        height: height * .3,
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: musicRecent
                                .map((e) => Container(
                                      width: width * .6,
                                      height: height * .3,
                                      margin:
                                          EdgeInsets.only(right: width * .06),
                                      clipBehavior: Clip.hardEdge,
                                      decoration: const BoxDecoration(
                                          color: Color.fromARGB(255, 9, 72, 94),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          FluImage(e.img,
                                              height: height * .3,
                                              imageSource:
                                                  ImageSources.network),
                                          Positioned(
                                              bottom: 10,
                                              left: 15,
                                              child: Container(
                                                width: width * .5,
                                                height: height * .08,
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Color.fromARGB(
                                                        255, 9, 72, 94),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Color.fromARGB(
                                                              185, 53, 52, 52),
                                                          blurRadius: 12,
                                                          offset: Offset(0, 1),
                                                          spreadRadius: 1)
                                                    ]),
                                                child: Row(
                                                  children: [
                                                    FluButton(
                                                        onPressed: () async {
                                                          await audioPlayer
                                                              .play(UrlSource(
                                                                  audioUrl));
                                                        },
                                                        width: width * .12,
                                                        backgroundColor:
                                                            Color.fromARGB(255,
                                                                18, 90, 116),
                                                        child: FluIcon(
                                                          FluIcons.play,
                                                          color: Colors.white,
                                                        )),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          e.name,
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                        Text(
                                                          e.title,
                                                          style: GoogleFonts
                                                              .poppins(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          197,
                                                                          245,
                                                                          241,
                                                                          241),
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ))
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * .02,
                      ),
                      TabView(),
                      FutureBuilder<List<SongModel>>(
                        future: _audioQuery.querySongs(
                          sortType: null,
                          orderType: OrderType.ASC_OR_SMALLER,
                          uriType: UriType.EXTERNAL,
                          ignoreCase: true,
                        ),
                        builder: (context, item) {
                          if (item.hasError) {
                            return Text(item.error.toString());
                          }
                          // Waiting content.
                          if (item.data == null) {
                            return const CircularProgressIndicator();
                          }
                          // 'Library' is empty.
                          if (item.data!.isEmpty)
                            return Text(
                              "Aucune musique trouvée!",
                              style: GoogleFonts.poppins(color: Colors.white),
                            );
                          return SizedBox(
                            width: width,
                            height: height * .4,
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: item.data!.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 9, 72, 94),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: FluButton(
                                    backgroundColor: Colors.transparent,
                                    onPressed: () {
                                      AudioPlayer audioPlayer = AudioPlayer();
                                      PlayerState.stopped;
                                      print(item.data![index].uri);
                                      print(item.data![index].duration);
                                      setState(() {
                                        titre = item.data![index].title;
                                        artiste = item.data![index].artist ??
                                            "Inconnu";
                                        id = item.data![index].id;
                                        duration =
                                            item.data![index].duration ?? 0;
                                        url = item.data![index].data;
                                      });
                                      setState(() {
                                        _onPlay = true;
                                        _onPlaying = true;
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        // QueryArtworkWidget(id: id, type: type)
                                        QueryArtworkWidget(
                                          id: item.data![index].id,
                                          type: ArtworkType.AUDIO,
                                          artworkWidth: width * .18,
                                          artworkHeight: height * .08,
                                          controller: _audioQuery,
                                          nullArtworkWidget: FluButton(
                                              width: width * .18,
                                              height: height * .08,
                                              backgroundColor: Color.fromARGB(
                                                  255, 9, 72, 94),
                                              child: FluIcon(
                                                FluIcons.music,
                                                color: Colors.white,
                                              )),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: width * .5,
                                              height: height * .03,
                                              child: Text(
                                                item.data![index].title,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Text(
                                              item.data![index].artist ??
                                                  "Inconnu",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  color: Color.fromARGB(
                                                      197, 250, 249, 249)),
                                            ),
                                          ],
                                        ),
                                        FluButton(
                                            width: width * .18,
                                            height: height * .08,
                                            backgroundColor: Color.fromARGB(
                                                255, 18, 90, 116),
                                            onPressed: () {
                                              /*    audioPlayer
                                                  .play(UrlSource(item.data![index].data));
                                              print(audioPlayer.source); */
                                            },
                                            child: FluIcon(
                                              FluIcons.heart,
                                              color: Colors.white,
                                            )),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
                _onPlay
                    ? playing(width, height, titre, artiste, id, duration, url)
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }

  String durationToString(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
}
