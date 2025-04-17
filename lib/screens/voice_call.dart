import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VoiceCallPage extends StatefulWidget {
  final String callId;
  final String userId;
  final String peerId;
  final bool isCaller;
  const VoiceCallPage({super.key, required this.callId, required this.userId, required this.peerId, required this.isCaller});

  @override
  State<VoiceCallPage> createState() => _VoiceCallPageState();
}

class _VoiceCallPageState extends State<VoiceCallPage> {
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Map<String, dynamic> _iceServers = {
    'iceServers': [
      {'urls': 'stun:stun.l.google.com:19302'},
    ]
  };

  final Map<String, dynamic> _mediaConstraints = {
    'audio': true,
    'video': false,
  };

  @override
  void initState() {
    super.initState();
    widget.isCaller ? _startCaller() : _startReceiver();
  }

  Future<void> _startCaller() async {
    _localStream = await navigator.mediaDevices.getUserMedia(_mediaConstraints);
    _peerConnection = await createPeerConnection(_iceServers);

    _localStream?.getTracks().forEach((track) {
      _peerConnection?.addTrack(track, _localStream!);
    });

    _peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
      _firestore.collection('calls').doc(widget.callId).collection('candidates').add({
        'candidate': candidate.candidate,
        'sdpMid': candidate.sdpMid,
        'sdpMLineIndex': candidate.sdpMLineIndex,
        'userId': widget.userId
      });
    };

    RTCSessionDescription offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);

    await _firestore.collection('calls').doc(widget.callId).set({
      'callerId': widget.userId,
      'receiverId': widget.peerId,
      'status': 'ringing',
      'offer': offer.toMap(),
    });

    _firestore.collection('calls').doc(widget.callId).snapshots().listen((snapshot) async {
      if (snapshot.exists && snapshot.data() != null && snapshot.data()!.containsKey('answer')) {
        var answer = snapshot.data()!['answer'];
        await _peerConnection?.setRemoteDescription(
          RTCSessionDescription(answer['sdp'], answer['type']),
        );
      }
    });

    _listenCandidates();
  }

  Future<void> _startReceiver() async {
    _localStream = await navigator.mediaDevices.getUserMedia(_mediaConstraints);
    _peerConnection = await createPeerConnection(_iceServers);

    _localStream?.getTracks().forEach((track) {
      _peerConnection?.addTrack(track, _localStream!);
    });

    _peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
      _firestore.collection('calls').doc(widget.callId).collection('candidates').add({
        'candidate': candidate.candidate,
        'sdpMid': candidate.sdpMid,
        'sdpMLineIndex': candidate.sdpMLineIndex,
        'userId': widget.userId
      });
    };

    DocumentSnapshot snapshot = await _firestore.collection('calls').doc(widget.callId).get();
    if (snapshot.exists && snapshot.data() != null) {
      var data = snapshot.data() as Map<String, dynamic>; // Cast the data to Map
      if (data.containsKey('offer')) {
        var offer = data['offer']; // Access offer from the casted map
        await _peerConnection?.setRemoteDescription(
          RTCSessionDescription(offer['sdp'], offer['type']),
        );

        RTCSessionDescription answer = await _peerConnection!.createAnswer();
        await _peerConnection!.setLocalDescription(answer);

        await _firestore.collection('calls').doc(widget.callId).update({
          'answer': answer.toMap(),
          'status': 'accepted',
        });
      }
    }


    _listenCandidates();
  }

  void _listenCandidates() {
    _firestore.collection('calls').doc(widget.callId).collection('candidates').snapshots().listen((snapshot) {
      for (var change in snapshot.docChanges) {
        var data = change.doc.data();
        if (data != null && data['userId'] != widget.userId) {
          RTCIceCandidate candidate = RTCIceCandidate(
            data['candidate'],
            data['sdpMid'],
            data['sdpMLineIndex'],
          );
          _peerConnection?.addCandidate(candidate);
        }
      }
    });
  }

  @override
  void dispose() {
    _localStream?.getTracks().forEach((track) => track.stop());
    _peerConnection?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Voice Call")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.phone_in_talk,
              size: 100,
              color: Colors.green.shade700,
            ),
            const SizedBox(height: 20),
            const Text("Voice call is active."),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                _firestore.collection('calls').doc(widget.callId).update({'status': 'ended'});
                Navigator.pop(context);
              },
              child: const Text("End Call"),
            ),
          ],
        ),
      ),
    );
  }
}

