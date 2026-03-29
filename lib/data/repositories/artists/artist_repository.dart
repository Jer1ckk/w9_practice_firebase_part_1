import '../../../model/artists/artist.dart';

abstract class ArtistRepository {
  Future<List<Artist>> fetchArtists();
  Future<List<Artist>> getArtists({bool forceFetch = false});
  Future<Artist?> fetchAristsById(String id);
}
