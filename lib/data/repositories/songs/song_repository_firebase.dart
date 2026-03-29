import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../model/songs/song.dart';
import '../../dtos/song_dto.dart';
import 'song_repository.dart';

class SongRepositoryFirebase extends SongRepository {
  final Uri songsUri = Uri.https(
    'g2-the-best-76f22-default-rtdb.asia-southeast1.firebasedatabase.app',
    '/songs.json',
  );
  List<Song>? _cachedSong;

  @override
  Future<List<Song>> getSongs({bool forceFetch = false}) async {
    if (!forceFetch && _cachedSong != null) {
      return _cachedSong!;
    }

    final List<Song> songs = await fetchSongs();
    _cachedSong = songs;
    print("fetch Songs from database");

    return songs;
  }

  @override
  Future<List<Song>> fetchSongs() async {
    final http.Response response = await http.get(songsUri);

    if (response.statusCode == 200) {
      // 1 - Send the retrieved list of songs
      Map<String, dynamic> songJson = json.decode(response.body);
      return songJson.entries
          .map((entry) => SongDto.fromJson(entry.key, entry.value))
          .toList();
    } else {
      // 2- Throw expcetion if any issue
      throw Exception('Failed to load posts');
    }
  }

  @override
  Future<Song?> fetchSongById(String id) async {}

  @override
  Future<void> incrementLike(String songId, int currentLikes) async {
    final Uri uri = Uri.https(
      'g2-the-best-76f22-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/songs/$songId.json',
    );

    final response = await http.patch(
      uri,
      body: json.encode({'likesCount': currentLikes + 1}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update like count');
    }
  }
}
