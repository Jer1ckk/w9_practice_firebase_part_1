import 'package:flutter/material.dart';
import 'package:w9/model/services/music_service.dart';
import 'package:w9/model/songs/song_detail.dart';
import '../../../states/player_state.dart';
import '../../../../model/songs/song.dart';
import '../../../utils/async_value.dart';

class LibraryViewModel extends ChangeNotifier {
  final MusicService musicService;
  final PlayerState playerState;

  AsyncValue<List<SongDetail>> songsValue = AsyncValue.loading();

  LibraryViewModel({required this.musicService, required this.playerState}) {
    playerState.addListener(notifyListeners);

    // init
    _init();
  }

  @override
  void dispose() {
    playerState.removeListener(notifyListeners);
    super.dispose();
  }

  void _init() async {
    fetchSong();
  }

  void fetchSong({bool forceFetch = false}) async {
    // 1- Loading state
    songsValue = AsyncValue.loading();
    notifyListeners();

    try {
      // 2- Fetch is successfull
      List<SongDetail> songs = await musicService.fetchSongDetails(
        forceFetch: forceFetch,
      );
      songsValue = AsyncValue.success(songs);
    } catch (e) {
      // 3- Fetch is unsucessfull
      songsValue = AsyncValue.error(e);
    }
    notifyListeners();
  }

  void incrementLike(String songId, int currentLikes) async {
    try {
      await musicService.songRepository.incrementLike(songId, currentLikes);
    } catch (e) {
      print(e);
    }
    fetchSong();
    notifyListeners();
  }

  bool isSongPlaying(Song song) => playerState.currentSong == song;

  void start(Song song) => playerState.start(song);
  void stop(Song song) => playerState.stop();
}
