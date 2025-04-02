import 'package:vibez/model/user_model.dart';

/// **Search State Model**
class SearchState {
  final List<UserModel> userList;
  final bool isSearching;

  SearchState({required this.userList, required this.isSearching});
}