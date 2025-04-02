import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:vibez/model/call_model.dart';

class CallService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Start a call
  Future<String> startCall({required String callerId, required String receiverId}) async {
    String channelId = Uuid().v4(); // Generate unique channel ID

    CallModel call = CallModel(
      callerId: callerId,
      receiverId: receiverId,
      status: 'ringing',
      channelId: channelId,
    );

    await _firestore.collection('calls').doc(channelId).set(call.toMap());

    return channelId; // Return the generated channelId
  }


  // Listen for incoming calls
  Stream<CallModel?> getIncomingCall(String userId) {
    return _firestore
        .collection('calls')
        .where('receiverId', isEqualTo: userId)
        .where('status', isEqualTo: 'ringing')
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      return CallModel.fromMap(snapshot.docs.first.data());
    });
  }
// Listen for call status updates
  Stream<CallModel?> listenToCallUpdates(String channelId) {
    return _firestore.collection('calls').doc(channelId).snapshots().map((snapshot) {
      if (!snapshot.exists) return null;
      return CallModel.fromMap(snapshot.data()!);
    });
  }

  // Accept call
  Future<void> acceptCall(String channelId) async {
    await _firestore.collection('calls').doc(channelId).update({'status': 'ongoing'});
  }

}
