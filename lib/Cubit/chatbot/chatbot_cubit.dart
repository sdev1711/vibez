import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:vibez/Cubit/chatbot/chatbot_state.dart';
import 'package:vibez/model/chatbot_msg_model.dart';

class ChatBotCubit extends Cubit<ChatBotState> {
  static const apiKey = "AIzaSyCDrGGDce8WKQIl5cl49l-NomhpRDUI8CQ";
  final model = GenerativeModel(model: 'gemini-2.0-flash', apiKey: apiKey);

  ChatBotCubit() : super(const ChatBotState(messages: []));

  Future<void> sendMessage(String message) async {
    if (message.isEmpty) return;

    // Add User Message
    final userMessage = ChatbotMessageModel(isUser: true, message: message, date: DateTime.now());
    emit(state.copyWith(messages: [...state.messages, userMessage], isLoading: true));

    // Get AI Response
    final content = [Content.text(message)];
    final response = await model.generateContent(content);

    final botMessage = ChatbotMessageModel(
      isUser: false,
      message: response.text ?? "No response",
      date: DateTime.now(),
    );

    // Add AI Message
    emit(state.copyWith(messages: [...state.messages, botMessage], isLoading: false));
  }
}