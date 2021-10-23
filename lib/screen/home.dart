import 'dart:io';

import 'package:audio_recorder/audio_recorder.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:native_hardware_access/model/audio.dart';
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
  bool _isLoading = false;
  final AudioPlayer _player = AudioPlayer();
  List<AudioFile> files;

  @override
  void initState() {
    super.initState();
    getFiles();
  }

  void getFiles() async {
    setState(() => _isLoading = true);
    List<String> l = await getAllFiles();
    files = l.map((e) => AudioFile(filePath: e)).toList();
    setState(() => _isLoading = false);
  }

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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () async {
                        await stopRecording();
                      },
                      icon: const Icon(
                        Icons.stop_circle_outlined,
                        size: 40.0,
                        color: Colors.grey,
                      )),
                  const SizedBox(
                    width: 10.0,
                  ),
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
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : files.isNotEmpty
                        ? ListView.builder(
                            itemBuilder: (BuildContext context, int i) =>
                                ListTile(
                              title: Text(files[i].filePath.split('/').last),
                              leading: const Icon(Icons.multitrack_audio),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        if (files[i].isPlaying) {
                                          setState(() => files[i].toggle());
                                          await _player.stop();
                                          await _player.play(files[i].filePath);
                                          setState(() => files[i].toggle());
                                        } else {
                                          await _player.play(files[i].filePath);
                                          setState(() => files[i].toggle());
                                        }
                                      },
                                      icon: files[i].isPlaying
                                          ? const Icon(Icons.stop)
                                          : const Icon(Icons.play_arrow))
                                ],
                              ),
                            ),
                            itemCount: files.length,
                          )
                        : const Center(
                            child: Text(
                            'Now Audio Available',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> startRecording() async {
    Directory dir = await getExternalStorageDirectory();
    setState(() => _isRecording = true);
    Fluttertoast.showToast(msg: 'Recording Started');
    await AudioRecorder.start(
        audioOutputFormat: AudioOutputFormat.WAV,
        path: join(dir.path, DateTime.now().millisecondsSinceEpoch.toString()));
  }

  Future<List<String>> getAllFiles() async {
    List<String> list = [];
    List<Directory> dir = await getExternalStorageDirectories();
    dir.forEach((i) => i.listSync().map((e) => e.path).where((t) {
          if (t.endsWith('.wav')) {
            list.add(t);
          }
          return false;
        }).toList());
    return list;
  }

  Future<Recording> stopRecording() async {
    setState(() => _isRecording = false);
    Fluttertoast.showToast(msg: 'Recording Stopped');
    Recording r = await AudioRecorder.stop();
    return r;
  }
}
