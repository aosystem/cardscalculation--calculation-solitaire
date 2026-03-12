import 'package:just_audio/just_audio.dart';

import 'package:cardscalculation/const_value.dart';

class AudioPlay {
  static final Map<_SoundKey, _SoundPool> _soundPools = {
    _SoundKey.start: _SoundPool(assetPath: ConstValue.soundStart, playerCount: 3),
    _SoundKey.retry: _SoundPool(assetPath: ConstValue.soundRetry, playerCount: 3),
    _SoundKey.back: _SoundPool(assetPath: ConstValue.soundBack, playerCount: 10),
    _SoundKey.slide: _SoundPool(assetPath: ConstValue.soundSlide, playerCount: 10),
    _SoundKey.complete: _SoundPool(assetPath: ConstValue.soundComplete, playerCount: 3),
  };

  bool _soundEnabled = true;

  AudioPlay() {
    _init();
  }

  void _init() async {
    for (final pool in _soundPools.values) {
      await pool.preload();
    }
  }

  void dispose() {
    for (final pool in _soundPools.values) {
      pool.dispose();
    }
  }

  void setSoundEnabled(bool flag) {
    _soundEnabled = flag;
  }

  void playSoundStart() {
    _playSound(_SoundKey.start);
  }

  void playSoundRetry() {
    _playSound(_SoundKey.retry);
  }

  void playSoundBack() {
    _playSound(_SoundKey.back);
  }

  void playSoundSlide() {
    _playSound(_SoundKey.slide);
  }

  void playSoundComplete() {
    _playSound(_SoundKey.complete);
  }

  void _playSound(_SoundKey key) async {
    if (!_soundEnabled) {
      return;
    }
    final pool = _soundPools[key];
    if (pool == null) {
      return;
    }
    await pool.play();
  }
}

enum _SoundKey { start, retry, back, slide, complete }

class _SoundPool {
  _SoundPool({required this.assetPath, required int playerCount})
      : players = List<AudioPlayer>.generate(playerCount, (_) => AudioPlayer());

  final String assetPath;
  final List<AudioPlayer> players;
  bool _isLoaded = false;
  int _pointer = 0;

  Future<void> preload() async {
    if (_isLoaded) {
      return;
    }
    for (final player in players) {
      await player.setAsset(assetPath);
    }
    _isLoaded = true;
  }

  Future<void> play() async {
    if (players.isEmpty) {
      return;
    }
    _pointer += 1;
    if (_pointer >= players.length) {
      _pointer = 0;
    }
    final player = players[_pointer];
    await player.pause();
    await player.seek(Duration.zero);
    await player.play();
  }

  void dispose() {
    for (final player in players) {
      player.dispose();
    }
    _isLoaded = false;
  }
}
