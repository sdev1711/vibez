class SearchFieldState {
  final bool isSearching;
  final bool isShow;

  SearchFieldState({
    this.isSearching = false,
    this.isShow = false,
  });

  SearchFieldState copyWith({
    bool? isSearching,
    bool? isShow,
  }) {
    return SearchFieldState(
      isSearching: isSearching ?? this.isSearching,
      isShow: isShow ?? this.isShow,
    );
  }
}