import 'package:bloc/bloc.dart';
import 'package:vibez/Cubit/search/search_state.dart';
import 'package:vibez/api_service/api_service.dart';
import 'package:vibez/model/user_model.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchState(userList: [], isSearching: false));

  void searchUsers(String query) async {
    if (query.isEmpty) {
      emit(SearchState(userList: [], isSearching: false)); // Reset to full list
      return;
    }

    final snapshot = await ApiService.firestore.collection('users').get();
    final users = snapshot.docs
        .map((e) => UserModel.fromJson(e.data()))
        .where((user) =>
    user.name.toLowerCase().contains(query.toLowerCase()) ||
        user.username.toLowerCase().contains(query.toLowerCase()))
        .toList();

    emit(SearchState(userList: users, isSearching: true));
  }
}


