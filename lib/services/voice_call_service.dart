import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vibez/screens/voice_call.dart';

class VoiceCallService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  StreamSubscription? _incomingCallSubscription;

  void startCall(BuildContext context, String callerId, String receiverId) async {
    final String callId = DateTime.now().millisecondsSinceEpoch.toString();

    await _firestore.collection('calls').doc(callId).set({
      'callerId': callerId,
      'receiverId': receiverId,
      'status': 'ringing',
      'timestamp': FieldValue.serverTimestamp(),
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VoiceCallPage(
          callId: callId,
          userId: callerId,
          peerId: receiverId,
          isCaller: true,
        ),
      ),
    );
  }

  void listenForIncomingCalls(BuildContext context, String currentUserId) {
    _incomingCallSubscription = _firestore
        .collection('calls')
        .where('receiverId', isEqualTo: currentUserId)
        .where('status', isEqualTo: 'ringing')
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.docs) {
        _showIncomingCallDialog(context, doc.id, doc['callerId']);
      }
    });
  }

  void _showIncomingCallDialog(BuildContext context, String callId, String callerId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Incoming Call'),
        content: Text('You have a call from $callerId'),
        actions: [
          TextButton(
            onPressed: () {
              _firestore.collection('calls').doc(callId).update({'status': 'rejected'});
              Navigator.pop(context);
            },
            child: const Text('Reject'),
          ),
          ElevatedButton(
            onPressed: () {
              _firestore.collection('calls').doc(callId).update({'status': 'accepted'});
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => VoiceCallPage(
                    callId: callId,
                    userId: callerId,
                    peerId: callerId,
                    isCaller: false,
                  ),
                ),
              );
            },
            child: const Text('Accept'),
          ),
        ],
      ),
    );
  }

  void dispose() {
    _incomingCallSubscription?.cancel();
  }
}
