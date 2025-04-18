import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoCallScreen extends StatefulWidget {
  final String channelId;

  const VideoCallScreen({super.key, required this.channelId});

  @override
  VideoCallScreenState createState() => VideoCallScreenState();
}

class VideoCallScreenState extends State<VideoCallScreen> {
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initializeRenderers();
      await _createPeerConnection();
    });
  }

  Future<void> _initializeRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();

    try {
      final mediaConstraints = {
        'audio': true,
        'video': {
          'facingMode': 'user',
          'width': 640,
          'height': 480,
        }
      };

      _localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
      log("MediaStream retrieved successfully: ${_localStream!.id}");

      setState(() {
        _localRenderer.srcObject = _localStream;
      });
    } catch (e) {
      log("Error accessing media: $e");
    }
  }

  Future<void> requestPermissions() async {
    final status = await Permission.camera.request();
    final micStatus = await Permission.microphone.request();

    if (status.isDenied || micStatus.isDenied) {
      log("Camera or Microphone permission denied.");
    }
  }

  Future<void> _createPeerConnection() async {
    Map<String, dynamic> configuration = {
      "iceServers": [
        {"urls": "stun:stun.l.google.com:19302"},
        {"urls": "turn:your.turn.server", "username": "user", "credential": "pass"}
      ]
    };

    _peerConnection = await createPeerConnection(configuration);

    if (_localStream != null) {
      for (var track in _localStream!.getTracks()) {
        _peerConnection?.addTrack(track, _localStream!);
      }
    } else {
      log("_localStream is null! Video call may not work properly.");
    }

    _peerConnection?.onTrack = (RTCTrackEvent event) {
      if (event.streams.isNotEmpty) {
        log("Received remote stream: ${event.streams.first.id}");
        setState(() {
          _remoteRenderer.srcObject = event.streams.first;
        });
      } else {
        log("⚠ No Remote Stream found!");
      }
    };

    _peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
      log("Sending ICE Candidate: ${candidate.toMap()}");

    };
  }

  Future<void> _endCall() async {
    if (_localRenderer.srcObject != null) {
      _localRenderer.srcObject!.getTracks().forEach((track) {
        track.stop();
      });
      _localRenderer.srcObject = null;
    }

    if (_remoteRenderer.srcObject != null) {
      _remoteRenderer.srcObject!.getTracks().forEach((track) {
        track.stop();
      });
      _remoteRenderer.srcObject = null;
    }

    await Future.delayed(Duration(milliseconds: 300));
    _localRenderer.dispose();
    _remoteRenderer.dispose();

    _peerConnection?.close();
    _peerConnection = null;

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _endCall();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: RTCVideoView(_remoteRenderer, objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            width: 120,
            height: 160,
            child: RTCVideoView(_localRenderer, mirror: true),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: IconButton(
              icon: Icon(Icons.call_end, color: Colors.red, size: 40),
              onPressed: _endCall,
            ),
          ),
        ],
      ),
    );
  }
}


