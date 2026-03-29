import '../../../model/songs/song.dart';

abstract class SongRepository {
  Future<List<Song>> fetchSongs();
  Future<List<Song>> getSongs({bool forceFetch = false});

  Future<Song?> fetchSongById(String id);
  Future<void> incrementLike(String songId, int currentLikes);
}
