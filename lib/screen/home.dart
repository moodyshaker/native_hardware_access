import 'dart:io';

import 'package:audio_recorder/audio_recorder.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget {
  static const String id = 'HOME';

  @override
  State<Home> createState() => _HomeState();

  const Home({Key key}) : super(key: key);
}

class _HomeState extends State<Home> {
  bool _isRecording = false;
  final AudioPlayer _player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _isRecording
                  ? const SpinKitDoubleBounce(
                      size: 40.0,
                      color: Colors.red,
                    )
                  : IconButton(
                      onPressed: () async {
                        PermissionStatus status =
                            await Permission.microphone.request();
                        if (status == PermissionStatus.granted) {
                          await startRecording();
                        } else if (status == PermissionStatus.granted) {
                          Fluttertoast.showToast(
                              msg:
                                  'To record an audio you have to accept the permission');
                        }
                      },
                      icon: const Icon(
                        Icons.fiber_manual_record,
                        size: 40.0,
                        color: Colors.red,
                      )),
              const SizedBox(
                height: 20.0,
              ),
              IconButton(
                  onPressed: () async {
                    Recording r = await stopRecording();
                    print(r.path);
                    print(r.duration);
                    print(r.audioOutputFormat);
                    print(r.extension);
                  },
                  icon: const Icon(
                    Icons.stop_circle_outlined,
                    size: 40.0,
                    color: Colors.grey,
                  )),
              const SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.play_arrow,
                        size: 30.0,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.pause,
                        size: 30.0,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.stop,
                        size: 30.0,
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> startRecording() async {
    Directory dir = await getExternalStorageDirectory();
    setState(() => _isRecording = true);
    await AudioRecorder.start(
        audioOutputFormat: AudioOutputFormat.WAV,
        path: join(dir.path, DateTime.now().millisecondsSinceEpoch.toString()));
  }

  Future<Recording> stopRecording() async {
    setState(() => _isRecording = false);
    Recording r = await AudioRecorder.stop();
    return r;
  }
}
