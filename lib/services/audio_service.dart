import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();

  factory AudioService() {
    return _instance;
  }

  AudioService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  final FlutterTts _tts = FlutterTts();

  Future<void> initialize() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.5); // Chậm hơn cho trẻ
    await _tts.setPitch(1.0);
  }

  /// Phát âm từ từ văn bản (text-to-speech)
  Future<void> speak(String text) async {
    await _tts.speak(text);
  }

  /// Phát âm thanh từ tập tin
  Future<void> playAudio(String audioPath) async {
    try {
      await _audioPlayer.play(AssetSource(audioPath));
    } catch (e) {
      print('Error playing audio: $e');
    }
  }

  /// Dừng phát âm
  Future<void> stop() async {
    await _tts.stop();
    await _audioPlayer.stop();
  }

  /// Tạm dừng
  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  /// Tiếp tục phát
  Future<void> resume() async {
    await _audioPlayer.resume();
  }

  /// Đặt âm lượng
  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume);
  }

  /// Lắng nghe sự kiện kết thúc
  Stream<void> get onPlayerComplete => _audioPlayer.onPlayerComplete;
}
