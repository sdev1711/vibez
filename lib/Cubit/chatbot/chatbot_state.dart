import 'package:equatable/equatable.dart';
import 'package:vibez/model/chatbot_msg_model.dart';

class ChatBotState extends Equatable {
  final List<ChatbotMessageModel> messages;
  final bool isLoading;

  const ChatBotState({required this.messages, this.isLoading = false});

  ChatBotState copyWith({List<ChatbotMessageModel>? messages, bool? isLoading}) {
    return ChatBotState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [messages, isLoading];
}
