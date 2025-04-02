class CallModel {
  String callerId;
  String receiverId;
  String status;
  String channelId;

  CallModel({
    required this.callerId,
    required this.receiverId,
    required this.status,
    required this.channelId,
  });

  Map<String, dynamic> toMap() {
    return {
      'callerId': callerId,
      'receiverId': receiverId,
      'status': status,
      'channelId': channelId,
    };
  }

  factory CallModel.fromMap(Map<String, dynamic> map) {
    return CallModel(
      callerId: map['callerId'],
      receiverId: map['receiverId'],
      status: map['status'],
      channelId: map['channelId'],
    );
  }
}
