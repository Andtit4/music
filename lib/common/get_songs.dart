// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class MusicApi extends StatefulWidget {
//   MusicApi({Key? key}) : super(key: key);


// Future<List<Track>> fetchRandomTracks() async {
//     final token = await getAccessToken();
//     final url = 'https://api.spotify.com/v1/me/top/tracks?limit=10'; // Vous pouvez personnaliser l'URL pour obtenir des morceaux selon vos besoins
//     final response = await http.get(
//       Uri.parse(url),
//       headers: {'Authorization': 'Bearer $token'},
//     );

//     if (response.statusCode == 200) {
//       final List<dynamic> data = json.decode(response.body)['items'];
//       return data.map((item) => Track.fromJson(item['track'])).toList();
//     } else {
//       throw Exception('Failed to fetch tracks');
//     }
//   }

//   Future<String> getAccessToken() async {
//     final String basicAuth =
//         'Basic ${base64.encode(utf8.encode('$clientId:$clientSecret'))}';
//     final response = await http.post(
//       Uri.parse('https://accounts.spotify.com/api/token'),
//       headers: {'Authorization': basicAuth},
//       body: {'grant_type': 'client_credentials'},
//     );

//     if (response.statusCode == 200) {
//       final token = json.decode(response.body)['access_token'];
//       return token;
//     } else {
//       throw Exception('Failed to get access token');
//     }
//   }
  
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     throw UnimplementedError();
//   }
// }

// class Track {
//   final String name;
//   final String artist;
//   final String albumArtUrl;

//   Track({
//     required this.name,
//     required this.artist,
//     required this.albumArtUrl,
//   });

//   factory Track.fromJson(Map<String, dynamic> json) {
//     final List<dynamic> artists = json['artists'];
//     final Map<String, dynamic> album = json['album'];
//     final List<dynamic> images = album['images'];

//     return Track(
//       name: json['name'],
//       artist: artists[0]['name'],
//       albumArtUrl: images[0]['url'],
//     );
//   }
// }


//   @override
//   _MusicApiState createState() => _MusicApiState();
// }

// class _MusicApiState extends State<MusicApi> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//     );
//   }
// }