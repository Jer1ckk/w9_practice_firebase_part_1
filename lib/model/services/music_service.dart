import 'package:w9/data/repositories/artists/artist_repository.dart';
import 'package:w9/data/repositories/songs/song_repository.dart';
import 'package:w9/model/artists/artist.dart';
import 'package:w9/model/songs/song_detail.dart';
import '../songs/song.dart';

class MusicService {
  final SongRepository songRepository;
  final ArtistRepository artistRepository;

  MusicService({required this.artistRepository, required this.songRepository});

  Future<List<SongDetail>> fetchSongDetails() async {
    List<Song> songs = await songRepository.fetchSongs();
    List<Artist> artists = await artistRepository.fetchArtists();

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
