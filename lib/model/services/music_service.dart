import 'package:w9/data/repositories/artists/artist_repository.dart';
import 'package:w9/data/repositories/songs/song_repository.dart';
import 'package:w9/model/artists/artist.dart';
import 'package:w9/model/songs/song_detail.dart';
import '../songs/song.dart';

class MusicService {
  final SongRepository songRepository;
  final ArtistRepository artistRepository;

  MusicService({required this.artistRepository, required this.songRepository});

  Future<List<SongDetail>> fetchSongDetails({bool forceFetch = false}) async {
    List<Song> songs = await songRepository.getSongs(forceFetch: forceFetch);
    List<Artist> artists = await artistRepository.getArtists(
      forceFetch: forceFetch,
    );

    Map<String, Artist> mapArtist = {};
    for (Artist artist in artists) {
      mapArtist[artist.id] = artist;
    }

    return songs
        .map(
          (song) => SongDetail(song: song, artist: mapArtist[song.artistId]!),
        )
        .toList();
  }
}
