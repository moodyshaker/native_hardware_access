import 'package:flutter/material.dart';

class AudioFile {
  final String filePath;
  bool isPlaying;

  AudioFile({@required this.filePath, this.isPlaying = false});

  void toggle() {
    isPlaying = !isPlaying;
  }
}
