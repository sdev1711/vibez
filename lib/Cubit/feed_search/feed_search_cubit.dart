import 'package:bloc/bloc.dart';
import 'package:vibez/api_service/api_service.dart';
import 'package:vibez/model/user_model.dart';

import 'feed_search_state.dart';

class FeedSearchCubit extends Cubit<FeedSearchState> {
  FeedSearchCubit() : super(FeedSearchState(userList: [], isSearching: false));

  void searchUsers(String query) async {
    if (query.isEmpty) {
      emit(FeedSearchState(userList: [], isSearching: false)); // Reset to full list
      return;
    }

    final snapshot = await ApiService.firestore.collection('users').get();
    final users = snapshot.docs
        .map((e) => UserModel.fromJson(e.data()))
        .where((user) =>
    user.name.toLowerCase().contains(query.toLowerCase()) ||
        user.username.toLowerCase().contains(query.toLowerCase()))
        .toList();

    emit(FeedSearchState(userList: users, isSearching: true));
  }
}
