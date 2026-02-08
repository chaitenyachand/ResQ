import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  static final AudioPlayer _player = AudioPlayer();

  /// Play a simple system click sound or custom asset
  static Future<void> playClick() async {
    // Try playing the asset first
    try {
      await _player.play(AssetSource('sounds/click.mp3.mp3'), volume: 0.5);
    } catch (e) {
      // Fallback to system sound if asset fails
      await SystemSound.play(SystemSoundType.click);
    }
  }

  /// Play a high-alert sound (SOS)
  static Future<void> playSiren() async {
    try {
      await _player.play(AssetSource('sounds/siren.mp3.mp3'), volume: 1.0);
    } catch (e) {
      // Fallback
      await HapticFeedback.heavyImpact();
    }
  }

  /// Play a success chime (Mission Accepted / Sent)
  static Future<void> playSuccess() async {
    try {
      await _player.play(AssetSource('sounds/success.mp3.mp3'), volume: 0.8);
    } catch (e) {
      await HapticFeedback.mediumImpact();
    }
  }

  /// Stop any currently playing sound
  static Future<void> stop() async {
    await _player.stop();
  }
}
