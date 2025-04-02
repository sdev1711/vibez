import 'package:bloc/bloc.dart';
import 'package:vibez/Cubit/search_field_cubit/search_field_state.dart';

class SearchFieldCubit extends Cubit<SearchFieldState> {
  SearchFieldCubit() : super(SearchFieldState());

  void clearSearch() {
    emit(state.copyWith(isSearching: false,isShow: false));
  }

  void toggleSearchVisibility(bool value) {
    emit(state.copyWith(isShow: value));
  }
}

